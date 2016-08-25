package mediators
{
	import events.SwitchScreenEvent;

	import models.UnitsModel;

	import robotlegs.starling.bundles.mvcs.Mediator;

	import view.StartScreen;

	import starling.events.Event;

	public class StartScreenMediator extends Mediator
	{
		[Inject]
		public var units:UnitsModel;

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
