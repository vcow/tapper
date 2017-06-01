package commands
{
	import com.adobe.crypto.MD5;

	import app.AppFacade;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

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
			var gameModel:GameModel = AppFacade(facade).gameModel;

			var file:File = File.applicationStorageDirectory;
			file = file.resolvePath(Const.APP_NAME + ".state");
			if (file.exists && !file.isDirectory)
			{
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.READ);
				deserializeGameModel(stream.readUTFBytes(stream.bytesAvailable));
				stream.close();
			}
			else
			{
				if (gameModel.hasCurrentGame)
				{
					gameModel.hasCurrentGame = false;
					sendNotification(Const.UPDATE_CURRENT_GAME, false);
				}
			}

			file = File.applicationStorageDirectory;
			file = file.resolvePath(Const.APP_NAME + ".addon");
			if (file.exists && !file.isDirectory)
			{
				stream ||= new FileStream();
				stream.open(file, FileMode.READ);
				var data:ByteArray = new ByteArray();
				stream.readBytes(data);
				deserializeAddon(data);
				stream.close();
				sendNotification(Const.UPDATE_ADDONS);
			}

			if (!gameModel.isActive)
			{
				gameModel.isActive = true;
				sendNotification(Const.UPDATE_ACTIVITY, true);
			}

			var soundManager:SoundManager = SoundManager.getInstance();
			soundManager.muteMusic = gameModel.muteMusic;
			soundManager.muteSounds = gameModel.muteSound;
		}

		private function deserializeGameModel(data:String):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			try
			{
				var dataObject:Object = JSON.parse(data);
			}
			catch (e:Error)
			{
				trace("Wrong data format.");
				if (gameModel.hasCurrentGame)
				{
					gameModel.hasCurrentGame = false;
					sendNotification(Const.UPDATE_CURRENT_GAME, false);
				}
				return;
			}

			if (!dataObject.hasOwnProperty("hash")) return;

			var hash:String = dataObject.hash;
			delete dataObject["hash"];
			if (MD5.hashBytes(getBytes(dataObject)) != hash)
			{
				trace("Wrong signature.");
				if (gameModel.hasCurrentGame)
				{
					gameModel.hasCurrentGame = false;
					sendNotification(Const.UPDATE_CURRENT_GAME, false);
				}
				return;
			}

			if (!gameModel.hasCurrentGame)
			{
				gameModel.hasCurrentGame = true;
				sendNotification(Const.UPDATE_CURRENT_GAME, true);
			}

			var achievementsProxy:AchievementsProxy = facade.retrieveProxy(AchievementsProxy.NAME) as AchievementsProxy;

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

			gameModel.setMoney(dataObject.money);
			gameModel.tapsTotal = dataObject.tapsTotal;
			gameModel.tickCount = dataObject.tickCount;
			gameModel.level = dataObject.level;
			gameModel.currentSkin = dataObject.skin;

			gameModel.clearUnits();
			for each (var listData:Object in dataObject.units)
			{
				var unit:Unit = new Unit(null, NaN, false);
				unit.initializeNotifier(multitonKey);
				deserializeUnit(unit, listData);
				gameModel.addUnit(unit);
			}
			gameModel.sortUnitsByIndex();

			sendNotification(Const.UPDATE_TAPS, gameModel.tapsTotal);
			sendNotification(Const.UPDATE_LEVEL, gameModel.level);
			sendNotification(Const.UPDATE_MONEY, gameModel.money);
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

		private function deserializeAddon(data:ByteArray):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			try {
				gameModel.addonModel.deserialize(data);
			}
			catch (e:Error) {
				gameModel.addonModel.reset();
			}
		}
	}
}
