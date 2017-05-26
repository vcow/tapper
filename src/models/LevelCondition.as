package models
{
	public class LevelCondition extends ConditionBase
	{
		public function LevelCondition(src:XML)
		{
			super(false);

			if (src.hasOwnProperty("@value")) _min = _max = int(src.@value);
		}
	}
}
