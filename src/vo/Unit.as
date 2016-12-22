package vo
{
	import models.*;

	import org.puremvc.as3.multicore.patterns.observer.Notifier;

	public class Unit extends Notifier
	{
		private var _info:UnitInfo;
		private var _taps:uint;
		private var _ticks:uint;
		private var _buyPrice:Number;
		private var _active:Boolean;

		public function Unit(info:UnitInfo, buyPrice:Number, active:Boolean)
		{
			super();

			_info = info;
			_buyPrice = buyPrice;
			_active = active;
		}

		public function get info():UnitInfo
		{
			return _info;
		}

		public function set info(value:UnitInfo):void
		{
			_info = value;
		}

		public function get buyPrice():Number
		{
			return _buyPrice;
		}

		public function set buyPrice(value:Number):void
		{
			_buyPrice = value;
		}

		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			_active = value;
		}

		public function tap():void
		{
			_taps++;
			if (_info.perClickProfit && _info.perClickProfit.maxCount) {
				if (_taps >= _info.perClickProfit.maxCount)
				{
					_active = false;
					sendNotification(Const.UPDATE_UNITS_LIST);
				}
				sendNotification(Const.COUNT_CHANGED, {unit: this, count: _info.perClickProfit.maxCount - _taps});
			}
		}

		public function tick():void
		{
			_ticks++;
			if (_info.perSecondProfit && _info.perSecondProfit.maxCount) {
				if (_ticks >= _info.perSecondProfit.maxCount) {
					_active = false;
					sendNotification(Const.UPDATE_UNITS_LIST);
				}
				sendNotification(Const.COUNT_CHANGED, {unit: this, count: _info.perSecondProfit.maxCount - _ticks});
			}
		}

		public function get taps():uint
		{
			return _taps;
		}

		public function set taps(value:uint):void
		{
			_taps = value;
		}

		public function get ticks():uint
		{
			return _ticks;
		}

		public function set ticks(value:uint):void
		{
			_ticks = value;
		}
	}
}
