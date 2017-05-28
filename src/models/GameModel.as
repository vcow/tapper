package models
{
	import flash.utils.Dictionary;

	import org.puremvc.as3.multicore.core.Model;

	import vo.Unit;

	public class GameModel extends Model
	{
		private var _callbackId:uint;
		private var _units:Vector.<Unit> = new Vector.<Unit>();
		private var _unitsById:Dictionary = new Dictionary();

		public var tickCount:uint;
		public var moneyTotal:Number;
		public var level:uint;
		public var currentSkin:String;
		public var currentState:String;
		public var hasCurrentGame:Boolean;
		public var isActive:Boolean;
		public var money:Number = 0;
		public var tapsTotal:uint;

		public function GameModel(key:String)
		{
			super(key);
		}

		override protected function initializeModel():void
		{
			currentSkin = SkinType.WOOD;
			currentState = Const.STATE_START;
			moneyTotal = 0;
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

		public function get isStarted():Boolean
		{
			return _callbackId != 0;
		}

		public function getUnitsCount(id:String):int
		{
			var byIdList:Vector.<Unit> = _unitsById[id];
			return byIdList ? byIdList.length : 0;
		}

		public function clearUnits():void
		{
			_units.length = 0;
			for each (var byIdList:Vector.<Unit> in _unitsById) byIdList.length = 0;
		}

		public function getUnits():Vector.<Unit>
		{
			return _units;
		}

		public function getActiveUnits():Vector.<Unit>
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

		public function addUnit(unit:Unit):void
		{
			_units.push(unit);
			var byIdList:Vector.<Unit> = _unitsById[unit.info.id];
			if (!byIdList) _unitsById[unit.info.id] = byIdList = new Vector.<Unit>();
			byIdList.push(unit);
		}

		public function sortUnitsByPrice():void
		{
			_units.sort(sortByPrice);
			for each (var byIdList:Vector.<Unit> in _unitsById) byIdList.sort(sortByPrice);
		}

		private static function sortByPrice(a:Unit, b:Unit):int
		{
			if (a.buyPrice < b.buyPrice) return 1;
			else if (a.buyPrice > b.buyPrice) return -1;
			return 0;
		}
	}
}
