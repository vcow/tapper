package events
{
	import flash.events.Event;

	import models.UnitInfo;

	public class BuyUnitEvent extends Event
	{
		public static const BUY:String = "buy";

		public var unit:UnitInfo;

		public function BuyUnitEvent(type:String, unit:UnitInfo, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.unit = unit;
		}

		override public function clone():Event
		{
			return new BuyUnitEvent(type, unit, bubbles, cancelable);
		}
	}
}
