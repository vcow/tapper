package mediators
{
	import events.SwitchScreenEvent;

	import feathers.controls.StackScreenNavigator;

	import robotlegs.starling.bundles.mvcs.Mediator;

	import view.Application;

	public class ApplicationMediator extends Mediator
	{
		[Inject]
		public var view:Application;

		public function ApplicationMediator()
		{
			super();
		}

		override public function initialize():void
		{
			addContextListener(SwitchScreenEvent.POP, onSwitch, SwitchScreenEvent);
			addContextListener(SwitchScreenEvent.POP_TO_ROOT, onSwitch, SwitchScreenEvent);
			addContextListener(SwitchScreenEvent.SWITCH_TO_GAME, onSwitch, SwitchScreenEvent);
		}

		private function onSwitch(event:SwitchScreenEvent):void
		{
			switch (event.type) {
				case SwitchScreenEvent.POP:
					StackScreenNavigator(view).popScreen();
					break;
				case SwitchScreenEvent.POP_TO_ROOT:
					StackScreenNavigator(view).popToRootScreen();
					break;
				case SwitchScreenEvent.SWITCH_TO_GAME:
					StackScreenNavigator(view).pushScreen("gameScreenItem");
					break;
			}
		}
	}
}
