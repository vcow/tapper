package models
{
	/**
	 * Условие на достижение игроком определенного уровня.
	 */
	public class LevelCondition extends ConditionBase
	{
		public function LevelCondition(src:XML)
		{
			super(true);

			if (src.hasOwnProperty("@min")) _min = Number(src.@min);
			if (src.hasOwnProperty("@max")) _max = Number(src.@max);
		}
	}
}
