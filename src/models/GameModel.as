package models
{
	import flash.utils.Dictionary;

	import org.puremvc.as3.multicore.core.Model;

	import vo.Unit;

	public class GameModel extends Model
	{
		private var _callbackId:uint;
		private var _money:Number = 0;
		private var _units:Vector.<Unit> = new Vector.<Unit>();
		private var _unitsById:Dictionary = new Dictionary();
		private var _unitsByIndex:Dictionary = new Dictionary();
		private var _topUnitIndex:int;

		public var tickCount:uint;
		public var level:uint;
		public var currentSkin:String;
		public var currentState:String;
		public var hasCurrentGame:Boolean;
		public var isActive:Boolean;
		public var tapsTotal:uint;

		private static const LIMIT:Number = 999999999999.0;

		public function GameModel(key:String)
		{
			super(key);
		}

		override protected function initializeModel():void
		{
			currentSkin = SkinType.WOOD;
			currentState = Const.STATE_START;
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

		public function get money():Number
		{
			return _money;
		}

		public function setMoney(value:Number):Boolean
		{
			if (value > LIMIT)
			{
				if (_money < LIMIT)
				{
					_money = LIMIT;
					return true;
				}
				return false;
			}
			_money = value;
			return true;
		}

		public function get isStarted():Boolean
		{
			return _callbackId != 0;
		}

		public function get topUnitIndex():int
		{
			return _topUnitIndex;
		}

		public function getUnitsCount(id:String):int
		{
			var byIdList:Vector.<Unit> = _unitsById[id];
			return byIdList ? byIdList.length : 0;
		}

		public function getUnitsCountByIndex(index:int):int
		{
			var byIndexList:Vector.<Unit> = _unitsByIndex[index];
			return byIndexList ? byIndexList.length : 0;
		}

		public function clearUnits():void
		{
			_topUnitIndex = 0;
			_units.length = 0;
			for each (var unitsList:Vector.<Unit> in _unitsById) unitsList.length = 0;
			for each (unitsList in _unitsByIndex) unitsList.length = 0;
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

			var unitsList:Vector.<Unit> = _unitsById[unit.info.id];
			if (!unitsList) _unitsById[unit.info.id] = unitsList = new Vector.<Unit>();
			unitsList.push(unit);

			unitsList = _unitsByIndex[unit.info.index];
			if (!unitsList) _unitsByIndex[unit.info.index] = unitsList = new Vector.<Unit>();
			unitsList.push(unit);

			if (unit.info.index > _topUnitIndex) _topUnitIndex = unit.info.index;
		}

		public function sortUnitsByPrice():void
		{
			_units.sort(sortByPrice);
			for each (var byIdList:Vector.<Unit> in _unitsById) byIdList.sort(sortByPrice);
		}

		public function sortUnitsByIndex():void
		{
			_units.sort(sortByIndex);
			for each (var byIdList:Vector.<Unit> in _unitsById) byIdList.sort(sortByIndex);
		}

		private static function sortByIndex(a:Unit, b:Unit):int
		{
			if (a.info.index > 0 && b.info.index <= 0) return 1;
			else if (a.info.index <= 0 && b.info.index > 0) return -1;
			else if (a.info.index < b.info.index) return 1;
			else if (a.info.index > b.info.index) return -1;
			return 0;
		}

		private static function sortByPrice(a:Unit, b:Unit):int
		{
			if (a.buyPrice < b.buyPrice) return 1;
			else if (a.buyPrice > b.buyPrice) return -1;
			return 0;
		}
	}
}
