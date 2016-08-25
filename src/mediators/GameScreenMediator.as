package mediators
{
	import events.GameEvent;
	import events.GameStateEvent;
	import events.SwitchScreenEvent;

	import robotlegs.starling.bundles.mvcs.Mediator;

	import view.GameScreen;

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
			addViewListener(GameScreen.SHOP, onShop);
			addViewListener(GameScreen.TAP, onTap);

			dispatch(new GameStateEvent(GameStateEvent.START_GAME));
		}

		private function onShop(event:Event):void
		{
			dispatch(new SwitchScreenEvent(SwitchScreenEvent.SWITCH_TO_SHOP));
		}

		private function onTap(event:Event):void
		{
			dispatch(new GameEvent(GameEvent.TAP));
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
