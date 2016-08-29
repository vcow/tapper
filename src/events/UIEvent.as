package events
{
	import flash.events.Event;

	public class UIEvent extends Event
	{
		public static const UPDATE_ALL:String = "updateAll";
		public static const UPDATE_MONEY:String = "updateMoney";
		public static const UPDATE_UNITS_LIST:String = "updateUnitsList";

		public function UIEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
