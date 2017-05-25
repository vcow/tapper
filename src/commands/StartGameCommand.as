package commands
{
	import app.AppFacade;

	import models.GameModel;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import starling.core.Starling;

	public class StartGameCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			if (!AppFacade(facade).gameModel.isStarted)
				AppFacade(facade).gameModel.callbackId = Starling.juggler.repeatCall(onTick, 1.0);

			var gameModel:GameModel = AppFacade(facade).gameModel;
			if (!gameModel.hasCurrentGame)
			{
				gameModel.hasCurrentGame = true;
			}
		}

		private function onTick():void
		{
			sendNotification(Const.TICK);
		}
	}
}
