package commands
{
	import events.UIEvent;

	import flash.events.IEventDispatcher;

	import models.GameModel;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class LevelUpCommand implements ICommand
	{
		[Inject]
		public var gameModel:GameModel;

		[Inject]
		public var eventDispatcher:IEventDispatcher;

		public function execute():void
		{
			gameModel.level++;
			eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_LEVEL));
		}
	}
}
