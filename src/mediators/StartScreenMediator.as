package mediators
{
	import app.AppFacade;

	import gears.TriggerBroadcaster;

	import starling.events.Event;

	import view.StartScreen;

	public class StartScreenMediator extends BindableMediator
	{
		public function StartScreenMediator(mediatorName:String, viewComponent:Object)
		{
			super(mediatorName, viewComponent);
		}

		[Bindable(event="gameStateChanged")]
		public function get hasCurrentGame():Boolean
		{
			return AppFacade(facade).gameModel.hasCurrentGame;
		}

		override public function onRegister():void
		{
			AppFacade(facade).gameModel.triggerBroadcaster.subscribe(onTrigger);

			var startScreen:StartScreen = getViewComponent() as StartScreen;
			if (startScreen)
			{
				startScreen.addEventListener("continueGame", onStart);
			}
		}

		override public function onRemove():void
		{
			AppFacade(facade).gameModel.triggerBroadcaster.unsubscribe(onTrigger);

			var startScreen:StartScreen = getViewComponent() as StartScreen;
			if (startScreen)
			{
				startScreen.removeEventListener("continueGame", onStart);
			}
		}

		private function onStart(event:Event):void
		{
			sendNotification(Const.SWITCH_TO, Const.STATE_GAME);
		}

		private function onTrigger(trigger:String, value:*, ...args):void
		{
			if (trigger == TriggerBroadcaster.GAME_STATE)
			{
				dispatchEventWith("gameStateChanged");
			}
		}
	}
}
