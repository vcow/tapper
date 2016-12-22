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

	import org.puremvc.as3.multicore.core.Model;

	import org.puremvc.as3.multicore.interfaces.INotification;

	public class DeactivateCommand extends SerializationCommandBase
	{
		override public function execute(notification:INotification):void
		{
			var data:String = serializeGameModel();
			data.replace(/\n/g, File.lineEnding);
			var file:File = File.applicationStorageDirectory;
			file = file.resolvePath(ApplicationConfig.APP_NAME + ".state");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(data);
			stream.close();
		}

		private function serializeGameModel():String
		{
			var gameModel:GameModel = Model.getInstance(GameModel.NAME) as GameModel;
			var achievementsProxy:AchievementsProxy = Facade.getInstance(AppFacade.NAME).
					retrieveProxy(AchievementsProxy.NAME) as AchievementsProxy;

			var unitsList:Array = [];
			for (var i:int = 0, l:int = gameModel.units.length; i < l; i++)
			{
				unitsList.push(serializeUnit(gameModel.units[i]));
			}

			var achievementsList:Array = [];
			for (i = 0, l = achievementsProxy.achievements.length; i < l; i++)
			{
				var achievement:AchievementInfo = achievementsProxy.achievements[i];
				if (achievement.isReceived) achievementsList.push(serializeAchievement(achievement));
			}

			var dataObject:Object = {
				money: gameModel.money,
				tapsTotal: gameModel.tapsTotal,
				moneyTotal: gameModel.moneyTotal,
				tickCount: gameModel.tickCount,
				level: gameModel.level,
				skin: gameModel.currentSkin,
				units: unitsList,
				achievements: achievementsList,
				timestamp: new Date().time
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
