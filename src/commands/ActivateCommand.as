package commands
{
	import com.adobe.crypto.MD5;

	import app.AppFacade;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	import models.GameModel;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import proxy.AchievementsProxy;
	import proxy.UnitsProxy;

	import vo.AchievementInfo;
	import vo.Unit;

	public class ActivateCommand extends SerializationCommandBase
	{
		private var _unitsModel:UnitsProxy;

		private function get unitsModel():UnitsProxy
		{
			if (!_unitsModel)
				_unitsModel = facade.retrieveProxy(UnitsProxy.NAME) as UnitsProxy;
			return _unitsModel;
		}

		override public function execute(notification:INotification):void
		{
			var file:File = File.applicationStorageDirectory;
			file = file.resolvePath(Const.APP_NAME + ".state");
			if (file.exists && !file.isDirectory)
			{
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.READ);
				deserializeGameModel(stream.readUTFBytes(stream.bytesAvailable));
				stream.close();
			}
		}

		private function deserializeGameModel(data:String):void
		{
			try
			{
				var dataObject:Object = JSON.parse(data as String);
			}
			catch (e:Error)
			{
				trace("Wrong data format.");
				return;
			}

			if (!dataObject.hasOwnProperty("hash")) return;

			var hash:String = dataObject.hash;
			delete dataObject["hash"];
			if (MD5.hashBytes(getBytes(dataObject)) != hash)
			{
				trace("Wrong signature.");
				return;
			}

			var achievementsProxy:AchievementsProxy = facade.retrieveProxy(AchievementsProxy.NAME) as AchievementsProxy;
			var gameModel:GameModel = AppFacade(facade).gameModel;

			var achievementMap:Object = {};
			for each (listData in dataObject.achievements)
			{
				achievementMap[listData.achievement] = listData.received;
			}
			for (var i:int = 0, l:int = achievementsProxy.achievements.length; i < l; i++)
			{
				var achievement:AchievementInfo = achievementsProxy.achievements[i];
				achievement.receive(achievementMap[achievement.id]);
			}

			gameModel.money = dataObject.money;
			gameModel.tapsTotal = dataObject.tapsTotal;
			gameModel.moneyTotal = dataObject.moneyTotal;
			gameModel.tickCount = dataObject.tickCount;
			gameModel.level = dataObject.level;
			gameModel.currentSkin = dataObject.skin;

			gameModel.units.splice(0, gameModel.units.length);
			for each (var listData:Object in dataObject.units)
			{
				var unit:Unit = new Unit(null, NaN, false);
				unit.initializeNotifier(multitonKey);
				deserializeUnit(unit, listData);
				gameModel.units.push(unit);
			}
			gameModel.sortUnitsByPrice();

			sendNotification(Const.UPDATE_LEVEL);
			sendNotification(Const.UPDATE_MONEY);
			sendNotification(Const.UPDATE_UNITS_LIST);
		}

		private function deserializeUnit(unit:Unit, dataObject:Object):void
		{
			unit.info = unitsModel.getUnitById(dataObject.unit);
			unit.taps = dataObject.taps;
			unit.ticks = dataObject.ticks;
			unit.buyPrice = dataObject.buyPrice;
			unit.active = dataObject.active;
		}
	}
}
