package models
{
	public class MoneyCondition extends ConditionBase
	{
		public function MoneyCondition(src:XML)
		{
			super(true);

			if (src.hasOwnProperty("@min")) _min = Number(src.@min);
			if (src.hasOwnProperty("@max")) _max = Number(src.@max);
		}
	}
}
