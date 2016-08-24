package models
{
	/**
	 * Условие на набор определенного количества денег.
	 */
	public class MoneyCondition extends ConditionBase
	{
		public function MoneyCondition(src:XML)
		{
			super(false);

			if (src.hasOwnProperty("@min")) _min = Number(src.@min);
			if (src.hasOwnProperty("@max")) _max = Number(src.@max);
		}
	}
}
