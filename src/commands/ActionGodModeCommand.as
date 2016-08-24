package commands
{
	import app.AppFacade;

	import models.GameModel;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * Команда на включение режима Бога. Допускает три уровня визуализации.
	 */
	public class ActionGodModeCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			if (gameModel.addonModel.godMode < 3)
			{
				gameModel.addonModel.godMode += 1;
				sendNotification(Const.SAVE_ADDONS);
				sendNotification(Const.UPDATE_GOD_MODE, gameModel.addonModel.godMode);
			}
		}
	}
}
