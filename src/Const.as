package
{
	public class Const
	{
		public static const APP_NAME:String = "simdev";
		public static const APP_VERSION:String = "1.0.0.0";

		public static const ON_OK:uint = 1;
		public static const ON_CANCEL:uint = 2;
		public static const ON_YES:uint = 4;
		public static const ON_NO:uint = 8;

		public static const STATE_START:String = "stateStart";
		public static const STATE_GAME:String = "stateGame";
		public static const STATE_SHOP:String = "stateShop";
		public static const STATE_VIP:String = "stateVip";
		public static const STATE_PANTHEON:String = "statePantheon";

		public static const ACTIVATE:String = "notifyActivate";
		public static const DEACTIVATE:String = "notifyDeactivate";
		public static const TICK:String = "notifyTick";
		public static const TAP:String = "notifyTap";

		public static const UPDATE_MONEY:String = "notifyUpdateMoney";
		public static const UPDATE_TAPS:String = "notifyUpdateTaps";
		public static const UNIT_PURCHASED:String = "notifyUnitPurchased";
		public static const UPDATE_UNITS_LIST:String = "notifyUpdateUnitsList";
		public static const UPDATE_LEVEL:String = "notifyUpdateLevel";
		public static const UPDATE_CURRENT_GAME:String = "notifyUpdateCurrentGame";
		public static const UPDATE_ACTIVITY:String = "notifyUpdateActivity";
		public static const UPDATE_ADDONS:String = "notifyUpdateAddons";
		public static const UPDATE_MULTIPLIER:String = "notifyUpdateMultiplier";
		public static const UPDATE_GOD_MODE:String = "notifyUpdateGodMode";

		public static const START_GAME:String = "notifyStartGame";
		public static const STOP_GAME:String = "notifyStopGame";

		public static const BUY:String = "notifyBuy";
		public static const BUY_PACK:String = "notifyBuyPack";
		public static const RESTORE_PACK:String = "notifyRestorePack";
		public static const APPLY_PACK:String = "notifyApplyPack";
		public static const UPDATE_PACKS_LIST:String = "notifyUpdatePacksList";

		public static const ACHIEVE:String = "notifyAchieve";

		public static const LEVEL_UP_ACTION:String = "levelUp";
		public static const SET_SKIN_BRONZE_ACTION:String = "setSkinBronze";

		public static const SHOW_MESSAGE:String = "notifyShowMessage";
		public static const SHOW_TUTORIAL:String = "notifyShowTutorial";

		public static const POP:String = "notifyPop";
		public static const POP_TO_ROOT:String = "notifyPopToRoot";
		public static const SWITCH_TO:String = "notifySwitchTo";

		public static const NEW_GAME:String = "notifyNewGame";

		public static const OVERFLOW:String = "notifyOverflow";

		public static const SAVE_ADDONS:String = "notifySaveAddons";

		public static const PLAY_GAME_SOUND:String = "playGameSound";

		public static const ACTION_GOD_MODE:String = "godMode";

		public function Const()
		{
			throw Error("Const is a static class.");
		}
	}
}
