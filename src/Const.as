package
{
	public class Const
	{
		public static const APP_NAME:String = "simjew";
		public static const APP_VERSION:String = "1.0.0.0";

		public static const ON_OK:uint = 1;
		public static const ON_CANCEL:uint = 2;
		public static const ON_YES:uint = 4;
		public static const ON_NO:uint = 8;

		public static const STATE_START:String = "stateStart";
		public static const STATE_GAME:String = "stateGame";
		public static const STATE_SHOP:String = "stateShop";
		public static const STATE_VIP:String = "stateVip";

		public static const ACTIVATE:String = "notifyActivate";
		public static const DEACTIVATE:String = "notifyDeactivate";
		public static const TICK:String = "notifyTick";
		public static const TAP:String = "notifyTap";

		public static const UPDATE_MONEY:String = "notifyUpdateMoney";
		public static const UPDATE_UNITS_LIST:String = "notifyUpdateUnitsList";
		public static const UPDATE_LEVEL:String = "notifyUpdateLevel";

		public static const START_GAME:String = "notifyStartGame";
		public static const STOP_GAME:String = "notifyStopGame";

		public static const BUY:String = "notifyBuy";

		public static const ACHIEVE:String = "notifyAchieve";

		public static const LEVEL_UP:String = "levelUp";
		public static const SET_SKIN_BRONZE:String = "setSkinBronze";

		public static const SHOW_MESSAGE:String = "notifyShowMessage";

		public static const POP:String = "notifyPop";
		public static const POP_TO_ROOT:String = "notifyPopToRoot";
		public static const SWITCH_TO:String = "notifySwitchTo";

		public static const NEW_GAME:String = "notifyNewGame";

		public function Const()
		{
			throw Error("Const is a static class.");
		}
	}
}
