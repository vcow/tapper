package models
{
	import events.UIEvent;
	import events.UnitEvent;

	import flash.events.IEventDispatcher;

	public class Unit
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;

		[Inject]
		public var unitsModel:UnitsModel;

		private var _info:UnitInfo;
		private var _taps:uint;
		private var _ticks:uint;
		private var _buyPrice:Number;
		private var _active:Boolean;

		public function serialize(asString:Boolean):Object
		{
			var dataObject:Object = {
				unit: info.id,
				taps: taps,
				ticks: ticks,
				buyPrice: buyPrice,
				active: active
			};
			return asString ? JSON.stringify(dataObject) : dataObject;
		}

		public function deserialize(data:Object):void
		{
			var dataObject:Object = data is String ? JSON.parse(data as String) : data;
			_info = unitsModel.getUnitById(dataObject.unit);
			_taps = dataObject.taps;
			_ticks = dataObject.ticks;
			_buyPrice = dataObject.buyPrice;
			_active = dataObject.active;
		}

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
			if (_info.perClickProfit && _info.perClickProfit.maxCount) {
				if (_taps >= _info.perClickProfit.maxCount)
				{
					_active = false;
					eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_UNITS_LIST));
				}
				eventDispatcher.dispatchEvent(new UnitEvent(UnitEvent.COUNT_CHANGED, this,
						_info.perClickProfit.maxCount - _taps));
			}
		}

		public function tick():void
		{
			_ticks++;
			if (_info.perSecondProfit && _info.perSecondProfit.maxCount) {
				if (_ticks >= _info.perSecondProfit.maxCount) {
					_active = false;
					eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_UNITS_LIST));
				}
				eventDispatcher.dispatchEvent(new UnitEvent(UnitEvent.COUNT_CHANGED, this,
						_info.perSecondProfit.maxCount - _ticks));
			}
		}

		public function get taps():uint
		{
			return _taps;
		}

		public function get ticks():uint
		{
			return _ticks;
		}
	}
}
