package commands
{
	import app.AppFacade;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import starling.core.Starling;

	/**
	 * Команда на остановку игры. Игра останавливается каждый раз при выходе из Кабинета, или если юзер
	 * не проявляет активность в течении 30 секунд.
	 */
	public class StopGameCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			if (AppFacade(facade).gameModel.isStarted)
			{
				Starling.juggler.removeByID(AppFacade(facade).gameModel.callbackId);
				AppFacade(facade).gameModel.callbackId = 0;
			}
		}
	}
}
