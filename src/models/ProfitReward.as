package models
{
	/**
	 * Награда в виде профита.
	 */
	public class ProfitReward extends ProfitInfo implements IReward
	{
		public function ProfitReward(src:XML)
		{
			super(src);
		}

		public function get title():String
		{
			return "";
		}

		public function get description():String
		{
			return "";
		}
	}
}
