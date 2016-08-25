package events
{
	import flash.events.Event;

	public class GameStateEvent extends Event
	{
		public static const START_GAME:String = "startGame";
		public static const STOP_GAME:String = "stopGame";

		public function GameStateEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
