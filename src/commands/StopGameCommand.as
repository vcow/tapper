package commands
{
	import models.GameModel;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class StopGameCommand implements ICommand
	{
		[Inject]
		public var gameModel:GameModel;

		public function execute():void
		{
			gameModel.isActive = false;
		}
	}
}
