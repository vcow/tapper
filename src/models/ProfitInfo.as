package models
{
	public class ProfitInfo implements IReward
	{
		private var _value:RelValue;
		private var _maxCount:int;

		public function ProfitInfo(src:XML)
		{
			_value = new RelValue(src.@value);
			_maxCount = int(src.@maxCount);
		}

		public function get value():RelValue
		{
			return _value;
		}

		public function get maxCount():int
		{
			return _maxCount;
		}
	}
}
