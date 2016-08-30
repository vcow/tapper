package events
{
	import flash.events.Event;

	public class PopUpEvent extends Event
	{
		public static const SHOW:String = "show";

		public var title:String;
		public var description:String;

		public function PopUpEvent(type:String, title:String, description:String,
								   bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.title = title;
			this.description = description;
		}

		override public function clone():Event
		{
			return new PopUpEvent(type, title, description, bubbles, cancelable);
		}
	}
}
