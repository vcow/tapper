package events
{
	import flash.events.Event;

	public class SwitchScreenEvent extends Event
	{
		public static const POP:String = "pop";
		public static const POP_TO_ROOT:String = "popToRoot";

		public static const SWITCH_TO_START:String = "switchToStart";
		public static const SWITCH_TO_GAME:String = "switchToGame";
		public static const SWITCH_TO_SHOP:String = "switchToShop";

		public function SwitchScreenEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
