package commands
{
	import com.adobe.crypto.MD5;

	import config.ApplicationConfig;

	import facade.AppFacade;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	import models.AchievementInfo;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	import proxy.AchievementsProxy;
	import models.GameModel;
	import models.Unit;
	import proxy.UnitsProxy;

	import org.puremvc.as3.multicore.core.Model;

	import org.puremvc.as3.multicore.interfaces.INotification;

	public class ActivateCommand extends SerializationCommandBase
	{
		private var _unitsModel:UnitsProxy;

		private function get unitsModel():UnitsProxy
		{
			if (!_unitsModel)
				_unitsModel = Facade.getInstance(AppFacade.NAME).retrieveProxy(UnitsProxy.NAME) as UnitsProxy;
			return _unitsModel;
		}

		override public function execute(notification:INotification):void
		{
			var file:File = File.applicationStorageDirectory;
			file = file.resolvePath(ApplicationConfig.APP_NAME + ".state");
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

			var achievementsProxy:AchievementsProxy = Facade.getInstance(AppFacade.NAME).
					retrieveProxy(AchievementsProxy.NAME) as AchievementsProxy;
			var gameModel:GameModel = Model.getInstance(GameModel.NAME) as GameModel;

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
