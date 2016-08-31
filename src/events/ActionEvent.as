package events
{
	import flash.events.Event;

	public class ActionEvent extends Event
	{
		public static const LEVEL_UP:String = "levelUp";
		public static const SET_SKIN_BRONZE:String = "setSkinBronze";

		public function ActionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
