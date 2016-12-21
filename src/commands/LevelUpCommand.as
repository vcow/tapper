package commands
{
	import models.GameModel;

	import org.puremvc.as3.multicore.core.Model;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class LevelUpCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var gameModel:GameModel = Model.getInstance(GameModel.NAME) as GameModel;
			var level:int = int(notification.getBody());
			gameModel.level = level ? level : gameModel.level + 1;
			sendNotification(Const.UPDATE_LEVEL);
		}
	}
}
