package commands
{
	import app.AppFacade;

	import flash.filesystem.File;
	import flash.media.Sound;

	import models.GameModel;
	import models.LevelInfo;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import proxy.LevelsProxy;

	import resources.AtlasLibrary;

	import starling.utils.AssetManager;

	/**
	 * Команда на смену уровня игрока.
	 */
	public class LevelUpCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			var level:int = int(notification.getBody()) || (gameModel.level + 1);
			if (level > gameModel.level)
			{
				gameModel.level = level;
				sendNotification(Const.UPDATE_LEVEL);
				if (SoundManager.getInstance().muteSound) return;

				var levelInfo:LevelInfo = LevelsProxy(facade.retrieveProxy(LevelsProxy.NAME)).getLevel(level);
				var file:File = File.applicationDirectory.resolvePath("sound" + File.separator + levelInfo.assetId + ".mp3");
				if (file.exists)
				{
					var assetManager:AssetManager = AtlasLibrary.getInstance().manager;
					assetManager.enqueueWithName(file, levelInfo.assetId);
					assetManager.loadQueue(function (ratio:Number):void
					{
						if (ratio >= 1.0)
						{
							var sound:Sound = assetManager.getSound(levelInfo.assetId);
							if (sound) sendNotification(Const.PLAY_GAME_SOUND, sound);
						}
					});
				}
			}
		}
	}
}
