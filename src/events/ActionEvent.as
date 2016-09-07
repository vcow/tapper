package events
{
	import flash.events.Event;

	public class ActionEvent extends Event
	{
		public static const LEVEL_UP:String = "levelUp";
		public static const SET_SKIN_BRONZE:String = "setSkinBronze";

		public var data:Object;

		public function ActionEvent(type:String, data:Object = null,
									bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}

		override public function clone():Event
		{
			return new ActionEvent(type, data, bubbles, cancelable);
		}
	}
}
