package models
{
	/**
	 * Условие на определенное количество кликов по кнопке "Действовать".
	 */
	public class TapsCondition extends ConditionBase
	{
		public function TapsCondition(src:XML)
		{
			super(true);

			if (src.hasOwnProperty("@min")) _min = Number(src.@min);
			if (src.hasOwnProperty("@max")) _max = Number(src.@max);
		}
	}
}
