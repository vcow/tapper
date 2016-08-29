package models
{
	public class GameModel
	{
		private var _callbackId:uint;

		public var tickCount:uint;
		public var money:Number = 0;
		public var moneyTotal:Number = 0;
		public var tapsTotal:uint;
		public var units:Vector.<Unit> = new Vector.<Unit>();

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

	}
}
