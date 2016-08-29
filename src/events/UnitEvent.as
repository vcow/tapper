package events
{
	import flash.events.Event;

	import models.Unit;

	public class UnitEvent extends Event
	{
		public static const REMOVE_UNIT:String = "removeUnit";

		public var unit:Unit;

		public function UnitEvent(type:String, unit:Unit, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.unit = unit;
		}

		override public function clone():Event
		{
			return new UnitEvent(type, unit, bubbles, cancelable);
		}
	}
}
