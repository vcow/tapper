package mediators
{
	import events.GameStateEvent;
	import events.SwitchScreenEvent;

	import robotlegs.starling.bundles.mvcs.Mediator;

	import screen.GameScreen;

	import starling.events.Event;

	public class GameScreenMediator extends Mediator
	{
		public function GameScreenMediator()
		{
			super();
		}

		override public function initialize():void
		{
			addViewListener(GameScreen.BACK, onBack);

			dispatch(new GameStateEvent(GameStateEvent.START_GAME));
		}

		private function onBack(event:Event):void
		{
			dispatch(new SwitchScreenEvent(SwitchScreenEvent.POP));
		}

		override public function destroy():void
		{
			dispatch(new GameStateEvent(GameStateEvent.STOP_GAME));
		}
	}
}
