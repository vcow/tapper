package models
{
	import com.adobe.crypto.MD5;

	import config.ApplicationConfig;

	import events.UIEvent;

	import flash.events.IEventDispatcher;

	import flash.utils.ByteArray;

	import gears.TriggerBroadcaster;

	import robotlegs.bender.framework.api.IInjector;

	public class GameModel
	{
		private var _callbackId:uint;
		private var _money:Number = 0;
		private var _tapsTotal:uint;
		private var _units:Vector.<Unit> = new Vector.<Unit>();

		public var tickCount:uint;
		public var moneyTotal:Number = 0;
		public var level:uint;

		[Inject]
		public var triggerBroadcaster:TriggerBroadcaster;

		[Inject]
		public var injector:IInjector;

		[Inject]
		public var eventDispatcher:IEventDispatcher;

		public function GameModel()
		{
		}

		public function serialize(asString:Boolean):Object
		{
			var unitsList:Array = [];
			for (var i:int = 0, l:int = _units.length; i < l; i++) {
				unitsList.push(_units[i].serialize(false));
			}

			var achievementsModel:AchievementsModel = injector.getInstance(AchievementsModel);
			var achievementsList:Array = [];
			for (i = 0, l = achievementsModel.achievements.length; i < l; i++) {
				var achievement:AchievementInfo = achievementsModel.achievements[i];
				if (achievement.isReceived) achievementsList.push(achievement.serialize(false));
			}

			var dataObject:Object = {
				money: money,
				tapsTotal: tapsTotal,
				moneyTotal: moneyTotal,
				tickCount: tickCount,
				level: level,
				units: unitsList,
				achievements: achievementsList,
				timestamp: new Date().time
			};
			dataObject.hash = MD5.hashBytes(getBytes(dataObject));
			return asString ? JSON.stringify(dataObject) : dataObject;
		}

		public function deserialize(data:Object):void
		{
			if (data is String) {
				try {
					var dataObject:Object = JSON.parse(data as String);
				}
				catch (e:Error) {
					trace("Wrong data format.");
					return;
				}
			}
			else {
				dataObject = data;
			}

			if (!dataObject.hasOwnProperty("hash")) return;
			var hash:String = dataObject.hash;
			delete dataObject["hash"];
			if (MD5.hashBytes(getBytes(dataObject)) != hash) {
				trace("Wrong signature.");
				return;
			}

			_money = dataObject.money;
			_tapsTotal = dataObject.tapsTotal;
			moneyTotal = dataObject.moneyTotal;
			tickCount = dataObject.tickCount;
			level = dataObject.level;

			_units.splice(0, _units.length);
			for each (var listData:Object in dataObject.units) {
				var unit:Unit = new Unit(null, NaN, false);
				injector.injectInto(unit);
				unit.deserialize(listData);
				_units.push(unit);
			}
			sortUnitsByPrice();

			var achievementsModel:AchievementsModel = injector.getInstance(AchievementsModel);
			var achievementMap:Object = {};
			for each (listData in dataObject.achievements) {
				achievementMap[listData.achievement] = listData.received;
			}
			for (var i:int = 0, l:int = achievementsModel.achievements.length; i < l; i++) {
				var achievement:AchievementInfo = achievementsModel.achievements[i];
				achievement.receive(achievementMap[achievement.id]);
			}

			eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_LEVEL));
			eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_MONEY));
			eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_UNITS_LIST));
		}

		private static function getBytes(dataObject:Object):ByteArray
		{
			var res:ByteArray = new ByteArray();
			res.writeUTFBytes(ApplicationConfig.APP_VERSION);
			res.writeFloat(dataObject.money);
			res.writeFloat(dataObject.moneyTotal);
			res.writeUnsignedInt(dataObject.tapsTotal);
			res.writeUnsignedInt(dataObject.tickCount);
			res.writeUnsignedInt(dataObject.level);
//			res.writeUTFBytes(MD5.hash(JSON.stringify(dataObject.units)));
//			res.writeUTFBytes(MD5.hash(JSON.stringify(dataObject.achievements)));
			res.writeUTFBytes(ApplicationConfig.APP_NAME);
			res.writeFloat(dataObject.timestamp);
			res.position = 0;
			return res;
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
			for (var i:int = 0, l:int = _units.length; i < l; i++) {
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
			for (var i:int = 0, l:int = _units.length; i < l; i++) {
				var unit:Unit = _units[i];
				if (unit.active) res.push(unit);
			}
			return res;
		}

		public function applyEnvVariables(src:String):String
		{
			if (src) {
				var match:Array = src.match(/%[^\s]+%/g);
				while (match.length > 0) {
					var tag:String = match.shift();
					var index:int = src.search(tag);
					switch (tag) {
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
