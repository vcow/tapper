package mediators
{
	import events.SwitchScreenEvent;

	import robotlegs.starling.bundles.mvcs.Mediator;

	public class AppMediator extends Mediator
	{
		[Inject]
		public var view:Main;

		public function AppMediator()
		{
			super();
		}

		override public function initialize():void
		{
			addContextListener(SwitchScreenEvent.SWITCH_TO_GAME, onSwitch, SwitchScreenEvent);
		}

		private function onSwitch(event:SwitchScreenEvent):void
		{
			switch (event.type) {
				case SwitchScreenEvent.POP:
					view.popScreen();
					break;
				case SwitchScreenEvent.POP_TO_ROOT:
					view.popToRootScreen();
					break;
				case SwitchScreenEvent.SWITCH_TO_GAME:
					view.pushScreen("gameScreenItem");
					break;
			}
		}
	}
}
