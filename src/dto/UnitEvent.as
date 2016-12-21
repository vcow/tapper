package dto
{
	import flash.events.Event;

	import models.Unit;

	public class UnitEvent extends Event
	{
		public static const COUNT_CHANGED:String = "counterChanged";

		public var unit:Unit;
		public var count:int;

		public function UnitEvent(type:String, unit:Unit, count:int, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.unit = unit;
			this.count = count;
		}

		override public function clone():Event
		{
			return new UnitEvent(type, unit, count, bubbles, cancelable);
		}
	}
}
