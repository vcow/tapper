package mediators
{
	import events.SwitchScreenEvent;

	import feathers.controls.StackScreenNavigator;

	import robotlegs.starling.bundles.mvcs.Mediator;

	import view.MainScreen;

	public class MainScreenMediator extends Mediator
	{
		[Inject]
		public var view:MainScreen;

		public function MainScreenMediator()
		{
			super();
		}

		override public function initialize():void
		{
			addContextListener(SwitchScreenEvent.POP, onSwitch, SwitchScreenEvent);
			addContextListener(SwitchScreenEvent.POP_TO_ROOT, onSwitch, SwitchScreenEvent);
			addContextListener(SwitchScreenEvent.SWITCH_TO_GAME, onSwitch, SwitchScreenEvent);
			addContextListener(SwitchScreenEvent.SWITCH_TO_SHOP, onSwitch, SwitchScreenEvent);
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
				case SwitchScreenEvent.SWITCH_TO_SHOP:
					StackScreenNavigator(view).pushScreen("shopScreenItem");
					break;
			}
		}
	}
}
