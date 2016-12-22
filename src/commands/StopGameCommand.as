package commands
{
	import app.AppFacade;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import starling.core.Starling;

	public class StopGameCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			if (AppFacade(facade).gameModel.isActive)
			{
				Starling.juggler.removeByID(AppFacade(facade).gameModel.callbackId);
				AppFacade(facade).gameModel.callbackId = 0;
			}
		}
	}
}
