package commands
{
	import app.AppFacade;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import starling.core.Starling;

	public class StartGameCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			if (!AppFacade(facade).gameModel.isActive)
				AppFacade(facade).gameModel.callbackId = Starling.juggler.repeatCall(onTick, 1.0);
		}

		private function onTick():void
		{
			sendNotification(Const.TICK);
		}
	}
}
