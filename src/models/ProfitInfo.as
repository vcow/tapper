package models
{
	/**
	 * Профит.
	 */
	public class ProfitInfo
	{
		private var _value:RelValue;
		private var _maxCount:int;

		public function ProfitInfo(src:XML)
		{
			_value = new RelValue(src.@value);
			_maxCount = int(src.@maxCount);
		}

		/**
		 * Количественное выражение профита.
		 */
		public function get value():RelValue
		{
			return _value;
		}

		/**
		 * Максимальное количество раз выдачи профита.
		 */
		public function get maxCount():int
		{
			return _maxCount;
		}
	}
}
