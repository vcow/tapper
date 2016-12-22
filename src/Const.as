package
{
	public class Const
	{
		public static const APP_NAME:String = "simjew";
		public static const APP_VERSION:String = "1.0.0.0";

		public static const ACTIVATE:String = "activate";
		public static const DEACTIVATE:String = "deactivate";
		public static const TICK:String = "tick";
		public static const TAP:String = "tap";

		public static const UPDATE_MONEY:String = "updateMoney";
		public static const UPDATE_UNITS_LIST:String = "updateUnitsList";
		public static const UPDATE_LEVEL:String = "updateLevel";

		public static const START_GAME:String = "startGame";
		public static const STOP_GAME:String = "stopGame";

		public static const BUY:String = "buy";

		public static const ACHIEVE:String = "achieve";

		public static const LEVEL_UP:String = "levelUp";
		public static const SET_SKIN_BRONZE:String = "setSkinBronze";

		public static const SHOW:String = "show";

		public static const POP:String = "pop";
		public static const POP_TO_ROOT:String = "popToRoot";

		public static const SWITCH_TO_START:String = "switchToStart";
		public static const SWITCH_TO_GAME:String = "switchToGame";
		public static const SWITCH_TO_SHOP:String = "switchToShop";

		public static const COUNT_CHANGED:String = "counterChanged";

		public function Const()
		{
			throw Error("Const is a static class.");
		}
	}
}
