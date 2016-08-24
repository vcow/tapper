package commands
{
	import app.AppFacade;

	import models.GameModel;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import vo.Pack;

	/**
	 * Команда на восстановление ранее купленного пака.
	 */
	public class RestorePackCommand extends SimpleCommand
	{
		private var _pack:Pack;

		override public function execute(notification:INotification):void
		{
			_pack = notification.getBody() as Pack;
			var gameModel:GameModel = AppFacade(facade).gameModel;

			_pack.isPurchased = true;
			switch (_pack.id)
			{
				case "qtap.portal":
					// Портал добавляет мультипликатор юнитов в дополнениях
					if (gameModel.addonModel.multiplier <= 0)
					{
						gameModel.addonModel.multiplier = 1;
						sendNotification(Const.UPDATE_MULTIPLIER, gameModel.addonModel.multiplier);
						sendNotification(Const.SAVE_ADDONS);
					}
					break;

				// TODO:
			}
		}
	}
}
