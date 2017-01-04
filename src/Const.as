package
{
	public class Const
	{
		public static const APP_NAME:String = "simjew";
		public static const APP_VERSION:String = "1.0.0.0";

		public static const ACTIVATE:String = "_activate_";
		public static const DEACTIVATE:String = "_deactivate_";
		public static const TICK:String = "_tick_";
		public static const TAP:String = "_tap_";

		public static const UPDATE_MONEY:String = "_updateMoney_";
		public static const UPDATE_UNITS_LIST:String = "_updateUnitsList_";
		public static const UPDATE_LEVEL:String = "_updateLevel_";

		public static const START_GAME:String = "_startGame_";
		public static const STOP_GAME:String = "_stopGame_";

		public static const BUY:String = "_buy_";

		public static const ACHIEVE:String = "_achieve_";

		public static const LEVEL_UP:String = "_levelUp_";
		public static const SET_SKIN_BRONZE:String = "_setSkinBronze_";

		public static const SHOW:String = "_show_";

		public static const POP:String = "_pop_";
		public static const POP_TO_ROOT:String = "_popToRoot_";

		public static const SWITCH_TO_START:String = "_switchToStart_";
		public static const SWITCH_TO_GAME:String = "_switchToGame_";
		public static const SWITCH_TO_SHOP:String = "_switchToShop_";

		public static const COUNT_CHANGED:String = "_counterChanged_";

		public function Const()
		{
			throw Error("Const is a static class.");
		}
	}
}
