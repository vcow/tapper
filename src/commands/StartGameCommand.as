package commands
{
	import models.GameModel;

	import org.puremvc.as3.multicore.core.Model;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import starling.core.Starling;

	public class StartGameCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var gameModel:GameModel = Model.getInstance(GameModel.NAME) as GameModel;

			if (!gameModel.isActive)
				gameModel.callbackId = Starling.juggler.repeatCall(onTick, 1.0);
		}

		private function onTick():void
		{
			sendNotification(Const.TICK);
		}
	}
}
