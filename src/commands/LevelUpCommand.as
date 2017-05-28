package commands
{
	import app.AppFacade;

	import models.GameModel;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class LevelUpCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			var level:int = int(notification.getBody()) || (gameModel.level + 1);
			if (level != gameModel.level)
			{
				gameModel.level = level;
				sendNotification(Const.UPDATE_LEVEL);
			}
		}
	}
}
