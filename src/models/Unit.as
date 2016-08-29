package models
{
	import events.UnitEvent;

	import flash.events.IEventDispatcher;

	public class Unit
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;

		private var _info:UnitInfo;
		private var _taps:uint;
		private var _ticks:uint;

		public function Unit(info:UnitInfo)
		{
			_info = info;
		}

		public function get info():UnitInfo
		{
			return _info;
		}

		public function tap():void
		{
			_taps++;
			if (_info.perClickProfit && _info.perClickProfit.maxCount && _taps >= _info.perClickProfit.maxCount) {
				eventDispatcher.dispatchEvent(new UnitEvent(UnitEvent.REMOVE_UNIT, this));
			}
		}

		public function tick():void
		{
			_ticks++;
			if (_info.perSecondProfit && _info.perSecondProfit.maxCount && _taps >= _info.perSecondProfit.maxCount) {
				eventDispatcher.dispatchEvent(new UnitEvent(UnitEvent.REMOVE_UNIT, this));
			}
		}
	}
}
