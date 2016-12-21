package commands
{
	import models.GameModel;

	import models.SkinType;

	import org.puremvc.as3.multicore.core.Model;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class SetSkinBronzeCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var gameModel:GameModel = Model.getInstance(GameModel.NAME) as GameModel;
			if (gameModel.currentSkin != SkinType.BRONZE)
			{
				gameModel.currentSkin = SkinType.BRONZE;
				sendNotification(Const.SWITCH_TO_GAME);
			}
		}
	}
}
