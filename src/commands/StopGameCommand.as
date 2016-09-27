package commands
{
	import models.GameModel;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	import starling.core.Starling;

	public class StopGameCommand implements ICommand
	{
		[Inject]
		public var gameModel:GameModel;

		public function execute():void
		{
			if (gameModel.isActive) {
				Starling.juggler.removeByID(gameModel.callbackId);
				gameModel.callbackId = 0;
			}
		}
	}
}
