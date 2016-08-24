package models
{
	/**
	 * Условие на наличие у юзера определенного количества юнитов.
	 */
	public class UnitCondition extends ConditionBase
	{
		private var _unitId:String;

		public function UnitCondition(src:XML)
		{
			super(true);

			if (src.hasOwnProperty("@min")) _min = Number(src.@min);
			if (src.hasOwnProperty("@max")) _max = Number(src.@max);
			if (src.children().length() > 0) _unitId = src.children()[0];
		}

		public function get unitId():String
		{
			return _unitId;
		}
	}
}
