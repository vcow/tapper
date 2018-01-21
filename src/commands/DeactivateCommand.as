package commands
{
	import com.adobe.crypto.MD5;

	import app.AppFacade;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	import models.GameModel;

	import net.Statistics;
	import net.Purchase;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import proxy.AchievementsProxy;

	import vo.AchievementInfo;
	import vo.Unit;

	/**
	 * Команда деактивации приложения. Вызывается при закрытии приложения или переходе его в неактивное состояние.
	 * Сохраняет текущее состояние игры.
	 */
	public class DeactivateCommand extends SerializationCommandBase
	{
		override public function execute(notification:INotification):void
		{
			var data:String = serializeGameModel();
			data.replace(/\n/g, File.lineEnding);
			try {
				var file:File = File.documentsDirectory.resolvePath("miroed");
				file.createDirectory();
			}
			catch (e:Error) {
				file = File.applicationStorageDirectory;
			}
			file = file.resolvePath(Const.APP_NAME + ".state");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(data);
			stream.close();

			var gameModel:GameModel = AppFacade(facade).gameModel;
			if (gameModel.isActive)
			{
				gameModel.isActive = false;
				sendNotification(Const.UPDATE_ACTIVITY, false);
			}

			var soundManager:SoundManager = SoundManager.getInstance();
			soundManager.muteMusic = true;
			soundManager.muteSound = true;

			Statistics.getInstance().stopMonitor();
			Purchase.getInstance().stopMonitor();
		}

		private function serializeGameModel():String
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			var achievementsProxy:AchievementsProxy = facade.retrieveProxy(AchievementsProxy.NAME) as AchievementsProxy;

			var unitsList:Array = [];
			var units:Vector.<Unit> = gameModel.getUnits();
			for (var i:int = 0, l:int = units.length; i < l; i++)
			{
				unitsList.push(serializeUnit(units[i]));
			}

			var achievementsList:Array = [];
			for (i = 0, l = achievementsProxy.achievements.length; i < l; i++)
			{
				var achievement:AchievementInfo = achievementsProxy.achievements[i];
				if (achievement.isReceived) achievementsList.push(serializeAchievement(achievement));
			}

			var soundManager:SoundManager = SoundManager.getInstance();
			var dataObject:Object = {
				money: gameModel.money,
				tapsTotal: gameModel.tapsTotal,
				tickCount: gameModel.tickCount,
				level: gameModel.level,
				name: gameModel.pantheonUserName,
				skin: gameModel.currentSkin,
				units: unitsList,
				achievements: achievementsList,
				godModeOff: gameModel.godModeOff,
				timestamp: new Date().time,
				music: int(soundManager.getVolume(SoundManager.MUSIC) * 1000.0 * (soundManager.muteMusic ? -1 : 1)),
				sound: int(soundManager.getVolume(SoundManager.SOUND) * 1000.0 * (soundManager.muteSound ? -1 : 1)),
				tutorial: gameModel.tutorial
			};
			dataObject.hash = MD5.hashBytes(getBytes(dataObject));
			return JSON.stringify(dataObject);
		}

		private static function serializeUnit(unit:Unit):Object
		{
			var dataObject:Object = {
				unit: unit.info.id,
				taps: unit.taps,
				ticks: unit.ticks,
				buyPrice: unit.buyPrice,
				active: unit.active
			};
			return dataObject;
		}

		private static function serializeAchievement(achievement:AchievementInfo):Object
		{
			var dataObject:Object = {
				achievement: achievement.id,
				received: achievement.isReceived ? achievement.receivedTime : -1
			};
			return dataObject;
		}
	}
}
