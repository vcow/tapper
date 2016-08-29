package models
{
	import gears.TriggerBroadcaster;

	public class GameModel
	{
		private var _callbackId:uint;
		private var _money:Number = 0;
		private var _tapsTotal:uint;

		public var tickCount:uint;
		public var moneyTotal:Number = 0;
		public var level:uint;
		public var units:Vector.<Unit> = new Vector.<Unit>();

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
	}
}
