package mediators
{
	import events.SwitchScreenEvent;

	import robotlegs.starling.bundles.mvcs.Mediator;

	import screen.StartScreen;

	import starling.events.Event;

	public class StartScreenMediator extends Mediator
	{
		public function StartScreenMediator()
		{
			super();
		}

		override public function initialize():void
		{
			addViewListener(StartScreen.START, onStart);
		}

		private function onStart(event:Event):void
		{
			dispatch(new SwitchScreenEvent(SwitchScreenEvent.SWITCH_TO_GAME));
		}
	}
}
