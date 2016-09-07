package commands
{
import events.ActionEvent;
import events.UIEvent;

	import flash.events.IEventDispatcher;

	import models.GameModel;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class LevelUpCommand implements ICommand
	{
		[Inject]
		public var event:ActionEvent;

		[Inject]
		public var gameModel:GameModel;

		[Inject]
		public var eventDispatcher:IEventDispatcher;

		public function execute():void
		{
			var level:int;
			if (event.data) level = int(event.data);

			gameModel.level = level ? level : gameModel.level + 1;
			eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_LEVEL));
		}
	}
}
