package mediators
{
	import events.PopUpEvent;
	import events.SwitchScreenEvent;

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
			addContextListener(PopUpEvent.SHOW, onShowPopup, PopUpEvent);
		}

		private function onShowPopup(event:PopUpEvent):void
		{
			MainScreen(view).showPopUp(event.title, event.description);
		}

		private function onSwitch(event:SwitchScreenEvent):void
		{
			switch (event.type) {
				case SwitchScreenEvent.POP:
					MainScreen(view).popScreen();
					break;
				case SwitchScreenEvent.POP_TO_ROOT:
					MainScreen(view).popToRootScreen();
					break;
				case SwitchScreenEvent.SWITCH_TO_GAME:
					MainScreen(view).pushScreen("gameScreenItem");
					break;
				case SwitchScreenEvent.SWITCH_TO_SHOP:
					MainScreen(view).pushScreen("shopScreenItem");
					break;
			}
		}
	}
}
