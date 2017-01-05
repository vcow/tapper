package vo
{
	import app.AppFacade;

	import models.*;

	import gears.TriggerBroadcaster;

	import org.puremvc.as3.multicore.patterns.observer.Notifier;

	import resources.locale.LocaleManager;

	public class UnitInfo extends Notifier
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
		}

		private function onTrigger(trigger:String, value:*, ...args):void
		{
			if (trigger == TriggerBroadcaster.BUY)
			{
				_calcPrice = NaN;
			}
		}

		public function get id():String
		{
			return _id;
		}

		public function get name():String
		{
			return _name;
		}

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
