package events
{
	import flash.events.Event;

	public class GameEvent extends Event
	{
		public static const TICK:String = "tick";
		public static const TAP:String = "tap";

		public function GameEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
