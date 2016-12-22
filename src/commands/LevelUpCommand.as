package commands
{
	import app.AppFacade;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class LevelUpCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var level:int = int(notification.getBody());
			AppFacade(facade).gameModel.level = level ? level : AppFacade(facade).gameModel.level + 1;
			sendNotification(Const.UPDATE_LEVEL);
		}
	}
}
