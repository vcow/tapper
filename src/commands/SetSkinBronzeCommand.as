package commands
{
	import app.AppFacade;

	import models.SkinType;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * Команда на активацию Бронзового Кабинета.
	 */
	public class SetSkinBronzeCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			if (AppFacade(facade).gameModel.currentSkin != SkinType.BRONZE)
			{
				AppFacade(facade).gameModel.currentSkin = SkinType.BRONZE;
				sendNotification(Const.SWITCH_TO, Const.STATE_GAME);
			}
		}
	}
}
