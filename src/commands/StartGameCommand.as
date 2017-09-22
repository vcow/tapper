package commands
{
	import app.AppFacade;

	import flash.utils.getTimer;

	import models.GameModel;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import resources.locale.LocaleManager;

	import starling.core.Starling;

	import vo.MessageBoxData;

	/**
	 * Команда на старт игры. Старт игры происходит только при входе в Кабинет. Здесь же запускается таймер для
	 * подсчета профита за секунду. В таймер встроена защита, останавливающая игру, если юзер не проявляет
	 * активность дольше 30 секунд.
	 */
	public class StartGameCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			if (!gameModel.isStarted)
			{
				gameModel.callbackId = Starling.juggler.repeatCall(onTick, 1.0);
			}

			if (!gameModel.hasCurrentGame)
			{
				gameModel.hasCurrentGame = true;
				sendNotification(Const.UPDATE_CURRENT_GAME, true);
			}

			gameModel.lastActivityTimestamp = getTimer();
		}

		private function onTick():void
		{
			if (getTimer() - AppFacade(facade).gameModel.lastActivityTimestamp >= 30000)
			{
				sendNotification(Const.STOP_GAME);
				sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
						LocaleManager.getInstance().getString("common", "message.sleep"), onContinue, Const.ON_YES));
			}
			else
			{
				sendNotification(Const.TICK);
			}
		}

		private function onContinue(result:uint):void
		{
			sendNotification(Const.START_GAME);
		}
	}
}
