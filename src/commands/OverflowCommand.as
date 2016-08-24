package commands
{
	import app.AppFacade;

	import models.GameModel;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import resources.locale.LocaleManager;

	import vo.MessageBoxData;

	/**
	 * Команда реакции на переполнение счетчика денег.
	 */
	public class OverflowCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			if (gameModel.level >= 11)
			{
				sendNotification(Const.STOP_GAME);
				sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
						LocaleManager.getInstance().getString("common", "message.overflow"),
						onCloseMessage, Const.ON_OK));
			}
		}

		private function onCloseMessage(result:uint):void
		{
			sendNotification(Const.POP_TO_ROOT);
		}
	}
}
