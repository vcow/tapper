package commands
{
	import app.AppFacade;

	import models.GameModel;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import resources.AtlasLibrary;

	/**
	 * Вспомогательная команда на переключение состояния. Воспроизводит музыкальную тему, соответствующую
	 * состоянию игры.
	 */
	public class PrepareToStateCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			var atlasLibrary:AtlasLibrary = AtlasLibrary.getInstance();
			var soundManager:SoundManager = SoundManager.getInstance();
			switch (notification.getBody() as String)
			{
				case Const.STATE_GAME:
					soundManager.playMusic(atlasLibrary.manager.getSound("main"));
					if (!gameModel.isStarted)
						sendNotification(Const.START_GAME);
					break;
				case Const.STATE_START:
					soundManager.playMusic(atlasLibrary.manager.getSound("title"));
					if (gameModel.isStarted)
						sendNotification(Const.STOP_GAME);
					break;
				case Const.STATE_SHOP:
				case Const.STATE_VIP:
					soundManager.playMusic(atlasLibrary.manager.getSound("shop"));
					if (gameModel.isStarted)
						sendNotification(Const.STOP_GAME);
					break;
				case Const.STATE_PANTHEON:
					soundManager.playMusic(atlasLibrary.manager.getSound("champions"));
					if (gameModel.isStarted)
						sendNotification(Const.STOP_GAME);
					break;
				default:
					throw Error("Unsupported state " + notification.getBody() + ".");
			}
		}
	}
}
