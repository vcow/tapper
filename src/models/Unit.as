package models
{
	import events.UIEvent;

	import flash.events.IEventDispatcher;

	public class Unit
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;

		private var _info:UnitInfo;
		private var _taps:uint;
		private var _ticks:uint;
		private var _buyPrice:Number;
		private var _active:Boolean;

		public function Unit(info:UnitInfo, buyPrice:Number, active:Boolean)
		{
			_info = info;
			_buyPrice = buyPrice;
			_active = active;
		}

		public function get info():UnitInfo
		{
			return _info;
		}

		public function get buyPrice():Number
		{
			return _buyPrice;
		}

		public function get active():Boolean
		{
			return _active;
		}

		public function tap():void
		{
			_taps++;
			if (_info.perClickProfit && _info.perClickProfit.maxCount && _taps >= _info.perClickProfit.maxCount) {
				_active = false;
				eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_UNITS_LIST));
			}
		}

		public function tick():void
		{
			_ticks++;
			if (_info.perSecondProfit && _info.perSecondProfit.maxCount && _ticks >= _info.perSecondProfit.maxCount) {
				_active = false;
				eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_UNITS_LIST));
			}
		}
	}
}
