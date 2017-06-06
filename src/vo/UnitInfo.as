package vo
{
	import app.AppFacade;

	import models.ActionReward;
	import models.GameModel;
	import models.ProfitInfo;
	import models.RelValue;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import resources.AtlasLibrary;
	import resources.locale.LocaleManager;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class UnitInfo extends BindableNotifier
	{
		private var _src:XML;

		private var _id:String;
		private var _index:int;
		private var _name:String;
		private var _description:String;
		private var _price:Number;
		private var _currentPrice:Number;
		private var _calcPrice:Number;
		private var _priceGrowth:RelValue;
		private var _maxCount:int;
		private var _rest:int = -1;
		private var _perSecondProfit:ProfitInfo;
		private var _perClickProfit:ProfitInfo;
		private var _profit:ProfitInfo;
		private var _action:ActionReward;

		private var _ppcLabel:String;
		private var _ppsLabel:String;
		private var _profitLabel:String;
		private var _actionLabel:String;

		private var _profitLimit:int;
		private var _money:Number;

		private var _available:Boolean;

		public function UnitInfo(src:XML)
		{
			super();
			_src = src;
		}

		override public function initializeNotifier(key:String):void
		{
			super.initializeNotifier(key);

			var locale:LocaleManager = LocaleManager.getInstance();
			_id = _src.@id;
			_index = _src.@index;
			_name = locale.getString("units", _src.@name) || _src.@name;
			_description = locale.getString("units", _src.@descrption) || _src.@description;
			_price = Number(_src.@price);
			_maxCount = int(_src.@maxCount);
			if (_src.hasOwnProperty("@priceGrowth")) _priceGrowth = new RelValue(_src.@priceGrowth);

			for each (var p:XML in _src.pps) _perSecondProfit = new ProfitInfo(p);
			for each (p in _src.ppc) _perClickProfit = new ProfitInfo(p);
			for each (p in _src.p) _profit = new ProfitInfo(p);
			for each (p in _src.action) _action = new ActionReward(p);

			var gameModel:GameModel = AppFacade(facade).gameModel;
			if (gameModel.money != _money)
			{
				_money = gameModel.money;
				dispatchEventWith("moneyChanged");
			}

			if (_perClickProfit)
			{
				_ppcLabel = (_perClickProfit.value.value ? cropValueK(_perClickProfit.value.value) :
				Math.round(_perClickProfit.value.percentValue * 100.0) + "%");
				_profitLimit = Math.max(_profitLimit, _perClickProfit.maxCount);
			}

			if (_perSecondProfit)
			{
				_ppsLabel = (_perSecondProfit.value.value ? cropValueK(_perSecondProfit.value.value) :
				Math.round(_perSecondProfit.value.percentValue * 100.0) + "%");
				_profitLimit = Math.max(_profitLimit, _perSecondProfit.maxCount);
			}

			if (_profit)
			{
				_profitLabel = "+" + (_profit.value.value ? cropValueK(_profit.value.value) :
						Math.round(_profit.value.percentValue * 100.0) + "%");
			}

			if (_action)
			{
				_actionLabel = _action.description;
			}

			if (gameModel.isActive)
			{
				calculatePrice();
				calculateRest();
			}

			dispatchEventWith("dataChanged");
		}

		private static function cropValueK(value:Number):String
		{
			value = Math.round(value);
			if (value >= 10000.0) return Math.floor(value / 1000.0) + "к";
			return value.toString();
		}

		private static function cropValueM(value:Number):String
		{
			value = Math.round(value);
			if (value >= 9000000.0)
			{
				value = Math.floor(value / 1000.0);
				if (value >= 9000000.0)
					return Math.floor(value / 1000.0) + "м";
				return value + "к";
			}
			return value.toString();
		}

		private static var _atlasIconSmall:TextureAtlas;
		private static function get atlasIconSmall():TextureAtlas
		{
			if (!_atlasIconSmall)
			{
				_atlasIconSmall = AtlasLibrary.getInstance().manager.getTextureAtlas("units_small");
			}
			return _atlasIconSmall;
		}

		private static var _atlasIconBig:TextureAtlas;
		private static function get atlasIconBig():TextureAtlas
		{
			if (!_atlasIconBig)
			{
				_atlasIconBig = AtlasLibrary.getInstance().manager.getTextureAtlas("units_big");
			}
			return _atlasIconBig;
		}

		public function updateUnitWith(notification:INotification):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			switch (notification.getName())
			{
				case Const.UPDATE_MONEY:
					_currentPrice = NaN;
					calculatePrice();

					if (gameModel.money != _money)
					{
						_money = gameModel.money;
						dispatchEventWith("moneyChanged");
					}
					break;
				case Const.UNIT_PURCHASED:
					var unit:Unit = notification.getBody() as Unit;
					if (unit && unit.info == this)
					{
						_currentPrice = NaN;
						calculatePrice();

						if (maxCount)
						{
							calculateRest();
						}
					}
					break;
				case Const.UPDATE_ACTIVITY:
					if (gameModel.isActive)
					{
						calculatePrice();
						calculateRest();
					}
					break;
				case Const.UPDATE_MULTIPLIER:
					calculatePrice();
					calculateRest();
					break;
				default:
					throw Error("Unsupported update with " + notification.getName() + ".");
			}
		}

		private function calculatePrice():void
		{
			if (_price <= 0)
			{
				_currentPrice = 0;
				return;
			}

			var newPrice:Number;
			var available:Boolean;
			var gameModel:GameModel = AppFacade(facade).gameModel;

			var numUnits:int = gameModel.getUnitsCount(id);
			var increase:Number = 0;
			if (_priceGrowth)
			{
				if (!isNaN(_priceGrowth.value)) increase = numUnits * _priceGrowth.value;
				else if (!isNaN(_priceGrowth.percentValue)) increase = _price * numUnits * _priceGrowth.percentValue;
			}
			_calcPrice = Math.round(_price + increase);

			var maxCount:int = this.maxCount;
			if (maxCount > 0 && numUnits >= maxCount)
			{
				newPrice = -1;
				available = false;
			}
			else
			{
				newPrice = _calcPrice;
				available = newPrice <= gameModel.money && (!maxCount || gameModel.getUnitsCount(id) < maxCount);
			}

			if (newPrice != _currentPrice)
			{
				_currentPrice = newPrice;
				dispatchEventWith("priceChanged");
			}

			if (available != _available)
			{
				_available = available;
				dispatchEventWith("availableChanged");
			}
		}

		private function calculateRest():void
		{
			var rest:int;
			var available:Boolean;
			var gameModel:GameModel = AppFacade(facade).gameModel;
			var maxCount:int = this.maxCount;
			if (maxCount)
			{
				rest = Math.max(0, maxCount - gameModel.getUnitsCount(id));
				available = _currentPrice <= gameModel.money && rest > 0;
			}
			else
			{
				rest = -1;
				available = _currentPrice <= gameModel.money
			}

			if (rest != _rest)
			{
				_rest = rest;
				dispatchEventWith("restChanged");
			}

			if (available != _available)
			{
				_available = available;
				dispatchEventWith("availableChanged");
			}
		}

		public function get id():String
		{
			return _id;
		}

		public function get index():int
		{
			return _index;
		}

		[Bindable(event="dataChanged")]
		public function get name():String
		{
			return _name;
		}

		[Bindable(event="dataChanged")]
		public function get iconSmall():Texture
		{
			return _id ? atlasIconSmall.getTexture(_id) : null;
		}

		[Bindable(event="dataChanged")]
		public function get iconBig():Texture
		{
			return _id ? atlasIconBig.getTexture(_id) : null;
		}

		[Bindable(event="dataChanged")]
		public function get description():String
		{
			return _description;
		}

		[Bindable(event="priceChanged")]
		public function get price():Number
		{
			return _currentPrice;
		}

		[Bindable(event="priceChanged")]
		public function get priceLabel():String
		{
			return cropValueM(_currentPrice < 0 ? _calcPrice : _currentPrice);
		}

		[Bindable(event="availableChanged")]
		public function get available():Boolean
		{
			return _available;
		}

		[Bindable(event="restChanged")]
		public function get rest():int
		{
			return _rest;
		}

		[Bindable(event="dataChanged")]
		public function get ppcLabel():String
		{
			return _ppcLabel;
		}

		[Bindable(event="dataChanged")]
		public function get ppsLabel():String
		{
			return _ppsLabel;
		}

		[Bindable(event="dataChanged")]
		public function get profitLabel():String
		{
			return _profitLabel;
		}

		[Bindable(event="dataChanged")]
		public function get actionLabel():String
		{
			return _actionLabel;
		}

		[Bindable(event="dataChanged")]
		public function get maxCount():int
		{
			return _maxCount ? _maxCount * AppFacade(facade).gameModel.addonModel.multiplier : 0;
		}

		[Bindable(event="dataChanged")]
		public function get profitLimit():int
		{
			return _profitLimit;
		}

		[Bindable(event="moneyChanged")]
		public function get money():int
		{
			return _money;
		}

		public function get perSecondProfit():ProfitInfo
		{
			return _perSecondProfit;
		}

		public function get perClickProfit():ProfitInfo
		{
			return _perClickProfit;
		}

		public function get profit():ProfitInfo
		{
			return _profit;
		}

		public function get action():ActionReward
		{
			return _action;
		}
	}
}
