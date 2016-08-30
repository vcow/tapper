package events
{
	import flash.events.Event;

	public class UIEvent extends Event
	{
		public static const UPDATE_MONEY:String = "updateMoney";
		public static const UPDATE_UNITS_LIST:String = "updateUnitsList";
		public static const UPDATE_LEVEL:String = "updateLevel";

		public function UIEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
