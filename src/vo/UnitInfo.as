package vo
{
	import app.AppFacade;

	import gears.TriggerBroadcaster;

	import models.*;

	import resources.AtlasLibrary;

	import resources.locale.LocaleManager;

	import starling.textures.Texture;

	public class UnitInfo extends BindableNotifier
	{
		private var _src:XML;

		private var _id:String;
		private var _name:String;
		private var _description:String;
		private var _price:Number;
		private var _calcPrice:Number;
		private var _priceGrowth:RelValue;
		private var _maxCount:int;
		private var _perSecondProfit:ProfitInfo;
		private var _perClickProfit:ProfitInfo;
		private var _profit:ProfitInfo;
		private var _action:ActionReward;

		private var _ppcLabel:String;
		private var _ppsLabel:String;
		private var _profitLabel:String;
		private var _actionLabel:String;

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
			_name = locale.getString("units", _src.@name) || _src.@name;
			_description = locale.getString("units", _src.@descrption) || _src.@description;
			_price = Number(_src.@price);
			_maxCount = int(_src.@maxCount);
			if (_src.hasOwnProperty("@priceGrowth")) _priceGrowth = new RelValue(_src.@priceGrowth);

			for each (var p:XML in _src.pps) _perSecondProfit = new ProfitInfo(p);
			for each (p in _src.ppc) _perClickProfit = new ProfitInfo(p);
			for each (p in _src.p) _profit = new ProfitInfo(p);
			for each (p in _src.action) _action = new ActionReward(p);

			AppFacade(facade).gameModel.triggerBroadcaster.subscribe(onTrigger);

			if (_perClickProfit)
			{
				_ppcLabel = (_perClickProfit.value.value ? cropValue(_perClickProfit.value.value) :
						Math.round(_perClickProfit.value.percentValue * 100.0) + "%");
			}

			if (_perSecondProfit)
			{
				_ppsLabel = (_perSecondProfit.value.value ? cropValue(_perSecondProfit.value.value) :
						Math.round(_perSecondProfit.value.percentValue * 100.0) + "%");
			}

			if (_profit)
			{
				_profitLabel = "+" + (_profit.value.value ? cropValue(_profit.value.value) :
						Math.round(_profit.value.percentValue * 100.0) + "%");
			}

			if (_action)
			{
				_actionLabel = _action.description;
			}

			dispatchEventWith("dataChanged");
		}

		private static function cropValue(value:Number):String
		{
			value = Math.round(value);
			if (value >= 10000.0) return Math.floor(value / 1000.0) + "K";
			return value.toString();
		}

		private function onTrigger(trigger:String, value:*, ...args):void
		{
			if (trigger == TriggerBroadcaster.BUY)
			{
				_calcPrice = NaN;
				dispatchEventWith("priceChanged");
			}
		}

		public function get id():String
		{
			return _id;
		}

		[Bindable(event="dataChanged")]
		public function get name():String
		{
			return _name;
		}

		[Bindable(event="dataChanged")]
		public function get icon():Texture
		{
			return _id ? AtlasLibrary.getInstance().unitsSmall.getTexture(_id) : null;
		}

		[Bindable(event="dataChanged")]
		public function get description():String
		{
			return _description;
		}

		public function get nameWithCounter():String
		{
			var res:String = _name;
			if (_maxCount > 0) res += " (" + AppFacade(facade).gameModel.getUnitsCount(this) + "/" + _maxCount + ")";
			return res;
		}

		[Bindable(event="priceChanged")]
		public function get price():Number
		{
			if (isNaN(_calcPrice))
			{
				var numUnits:Number = AppFacade(facade).gameModel.getUnitsCount(this);
				if (_maxCount > 0 && numUnits >= maxCount)
				{
					_calcPrice = -1;
				}
				else
				{
					var increase:Number = 0;
					if (_priceGrowth)
					{
						if (!isNaN(_priceGrowth.value)) increase = numUnits * _priceGrowth.value;
						else if (!isNaN(_priceGrowth.percentValue)) increase = _price * numUnits * _priceGrowth.percentValue;
					}
					_calcPrice = Math.round(_price + increase);
				}
			}
			return _calcPrice;
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

		public function get maxCount():int
		{
			return _maxCount;
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
