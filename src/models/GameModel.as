package models
{
	import gears.TriggerBroadcaster;

	import org.puremvc.as3.multicore.core.Model;

	import vo.Unit;

	public class GameModel extends Model
	{
		private var _callbackId:uint;
		private var _money:Number = 0;
		private var _tapsTotal:uint;
		private var _units:Vector.<Unit> = new Vector.<Unit>();

		private const _triggerBroadcaster:TriggerBroadcaster = new TriggerBroadcaster();

		public var tickCount:uint;
		public var moneyTotal:Number = 0;
		public var level:uint;
		public var currentSkin:String;

		public function GameModel(key:String)
		{
			super(key);
		}

		override protected function initializeModel():void
		{
			currentSkin = SkinType.WOOD;
			_triggerBroadcaster.init(this);
		}

		public function get triggerBroadcaster():TriggerBroadcaster
		{
			return _triggerBroadcaster;
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

		public function getUnitsCount(info:UnitInfo):int
		{
			var res:int = 0;
			for (var i:int = 0, l:int = _units.length; i < l; i++)
			{
				if (_units[i].info === info) res++;
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
			for (var i:int = 0, l:int = _units.length; i < l; i++)
			{
				var unit:Unit = _units[i];
				if (unit.active) res.push(unit);
			}
			return res;
		}

		public function applyEnvVariables(src:String):String
		{
			if (src)
			{
				var match:Array = src.match(/%[^\s]+%/g);
				while (match.length > 0)
				{
					var tag:String = match.shift();
					var index:int = src.search(tag);
					switch (tag)
					{
						case "%LEVEL%":
							src = src.substr(0, index) + level + src.substr(index + tag.length);
							break;
					}
				}
			}
			return src;
		}

		public function sortUnitsByPrice():void
		{
			_units.sort(sortByPrice);
		}

		private static function sortByPrice(a:Unit, b:Unit):int
		{
			if (a.buyPrice < b.buyPrice) return 1;
			else if (a.buyPrice > b.buyPrice) return -1;
			return 0;
		}
	}
}
