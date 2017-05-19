package commands
{
	import app.AppFacade;

	import models.GameModel;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class SwitchToStateCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			switch (notification.getBody() as String)
			{
				case Const.STATE_GAME:
					if (!gameModel.isStarted)
						sendNotification(Const.START_GAME);
					break;
				case Const.STATE_START:
				case Const.STATE_SHOP:
					if (gameModel.isStarted)
						sendNotification(Const.STOP_GAME);
					break;
				default:
					throw Error("Unsupported state " + notification.getBody() + ".");
			}
		}
	}
}
