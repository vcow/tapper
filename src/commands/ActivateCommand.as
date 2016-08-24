package commands
{
	import com.adobe.crypto.MD5;

	import app.AppFacade;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	import models.GameModel;

	import net.Statistics;
	import net.Purchase;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import proxy.AchievementsProxy;
	import proxy.UnitsProxy;

	import vo.AchievementInfo;
	import vo.Unit;

	/**
	 * Команда активации приложения. Вызывается при старте или выходе из неактивного режима. Восстанавливает
	 * исходное состояние игры, проверяет целостность данных.
	 */
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

			try {
				var file:File = File.documentsDirectory.resolvePath("miroed");
				file.createDirectory();
			}
			catch (e:Error) {
				file = File.applicationStorageDirectory;
			}
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
				else
				{
					gameModel.startBonus = 1000;
				}
			}

			try {
				file = File.documentsDirectory.resolvePath("miroed");
				file.createDirectory();
			}
			catch (e:Error) {
				file = File.applicationStorageDirectory;
			}
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

			gameModel.lastActivityTimestamp = getTimer();

			Statistics.getInstance().startMonitor();
			Purchase.getInstance().startMonitor();
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
			gameModel.pantheonUserName = dataObject.name || "";
			gameModel.currentSkin = dataObject.skin;
			gameModel.godModeOff = dataObject.godModeOff;
			gameModel.tutorial = dataObject.tutorial || {};

			gameModel.clearUnits();
			for each (var listData:Object in dataObject.units)
			{
				var unit:Unit = new Unit(null, NaN, false);
				unit.initializeNotifier(multitonKey);
				deserializeUnit(unit, listData);
				gameModel.addUnit(unit);
			}
			gameModel.sortUnitsByIndex();

			var soundManager:SoundManager = SoundManager.getInstance();
			var value:Number = Number(dataObject.music);
			soundManager.muteMusic = isNaN(value) ? false : value < 0;
			soundManager.setVolume(SoundManager.MUSIC, isNaN(value) ? 0.5 : Math.abs(value) / 1000.0);
			value = Number(dataObject.sound);
			soundManager.muteSound = isNaN(value) ? false : value < 0;
			soundManager.setVolume(SoundManager.SOUND, isNaN(value) ? 1.0 : Math.abs(value) / 1000.0);

			sendNotification(Const.UPDATE_TAPS, gameModel.tapsTotal);
			sendNotification(Const.UPDATE_LEVEL, gameModel.level);
			sendNotification(Const.UPDATE_MONEY, gameModel.money);
			sendNotification(Const.UPDATE_GOD_MODE, gameModel.addonModel.godMode);
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
