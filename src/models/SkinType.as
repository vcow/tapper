package models
{
	/**
	 * Перечисление типов кабинетов.
	 */
	public class SkinType
	{
		public static const WOOD:String = "wood";
		public static const BRONZE:String = "bronze";
		public static const SILVER:String = "silver";
		public static const GOLD:String = "gold";

		public function SkinType()
		{
			throw Error("Static.");
		}
	}
}
