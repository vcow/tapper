package commands
{
	import events.GameEvent;

	import flash.events.IEventDispatcher;

	import models.GameModel;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	import starling.core.Starling;

	public class StartGameCommand implements ICommand
	{
		[Inject]
		public var gameModel:GameModel;

		[Inject]
		public var eventDispatcher:IEventDispatcher;

		public function execute():void
		{
			if (!gameModel.isActive) {
				gameModel.callbackId = Starling.current.juggler.repeatCall(onTick, 1.0);
			}
		}

		private function onTick():void
		{
			eventDispatcher.dispatchEvent(new GameEvent(GameEvent.TICK));
		}
	}
}
