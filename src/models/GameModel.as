package models
{
	import gears.TriggerBroadcaster;

	public class GameModel
	{
		private var _callbackId:uint;
		private var _money:Number = 1000;
		private var _tapsTotal:uint;
		private var _units:Vector.<Unit> = new Vector.<Unit>();

		public var tickCount:uint;
		public var moneyTotal:Number = 0;
		public var level:uint;

		[Inject]
		public var triggerBroadcaster:TriggerBroadcaster;

		public function GameModel()
		{
		}

		public function set callbackId(value:uint):void
		{
			if (value == _callbackId) throw Error("Wrong callback Id.");
			_callbackId = value;
		}

		public function get callbackId():uint
		{
			return _callbackId;
		}

		public function get isActive():Boolean
		{
			return _callbackId != 0;
		}

		public function get money():Number
		{
			return _money;
		}

		public function set money(value:Number):void
		{
			if (value == _money) return;
			_money = value;
			triggerBroadcaster.broadcast(TriggerBroadcaster.MONEY, _money);
		}

		public function get tapsTotal():uint
		{
			return _tapsTotal;
		}

		public function set tapsTotal(value:uint):void
		{
			if (value == _tapsTotal) return;
			_tapsTotal = value;
			triggerBroadcaster.broadcast(TriggerBroadcaster.TAP, _tapsTotal);
		}

		public function getUnitsByInfo(info:UnitInfo):Vector.<Unit>
		{
			var res:Vector.<Unit> = new Vector.<Unit>();
			for (var i:int = 0, l:int = _units.length; i < l; i++) {
				var unit:Unit = _units[i];
				if (unit.info === info) res.push(unit);
			}
			return res;
		}

		public function get units():Vector.<Unit>
		{
			return _units;
		}

		public function get activeUnits():Vector.<Unit>
		{
			var res:Vector.<Unit> = new Vector.<Unit>();
			for (var i:int = 0, l:int = _units.length; i < l; i++) {
				var unit:Unit = _units[i];
				if (unit.active) res.push(unit);
			}
			return res;
		}
	}
}
