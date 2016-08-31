package models
{
	import resources.locale.LocaleManager;

	public class UnitInfo
	{
		private var _id:String;
		private var _name:String;
		private var _description:String;
		private var _price:Number;
		private var _priceGrowth:RelValue;
		private var _maxCount:int;
		private var _perSecondProfit:ProfitInfo;
		private var _perClickProfit:ProfitInfo;
		private var _profit:ProfitInfo;
		private var _action:ActionReward;

		[Inject]
		public var gameModel:GameModel;

		public function UnitInfo(src:XML)
		{
			_id = src.@id;
			_name = LocaleManager.getInstance().getString("units", src.@name) || src.@name;
			_description = LocaleManager.getInstance().getString("units", src.@descrption) || src.@description;
			_price = Number(src.@price);
			_maxCount = int(src.@maxCount);
			if (src.hasOwnProperty("@priceGrowth")) _priceGrowth = new RelValue(src.@priceGrowth);

			for each (var p:XML in src.pps) _perSecondProfit = new ProfitInfo(p);
			for each (p in src.ppc) _perClickProfit = new ProfitInfo(p);
			for each (p in src.p) _profit = new ProfitInfo(p);
			for each (p in src.action) _action = new ActionReward(p);
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
			if (_maxCount > 0) res += " (" + gameModel.getUnitsCount(this) + "/" + _maxCount + ")";
			return res;
		}

		public function get price():Number
		{
			var increase:Number = 0;
			var numUnits:Number = gameModel.getUnitsCount(this);
			if (_maxCount > 0 && numUnits >= maxCount) return NaN;
			if (_priceGrowth) {
				if (!isNaN(_priceGrowth.value)) increase = numUnits * _priceGrowth.value;
				else if (!isNaN(_priceGrowth.percentValue)) increase = _price * numUnits * _priceGrowth.percentValue;
			}
			return Math.round(_price + increase);
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
