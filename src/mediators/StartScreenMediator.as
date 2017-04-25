package mediators
{
	import app.AppFacade;

	import gears.TriggerBroadcaster;

	import resources.locale.LocaleManager;

	import starling.events.Event;

	import view.StartScreen;

	import vo.MessageBoxData;

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
				startScreen.addEventListener("newGame", onNewGame);
			}
		}

		override public function onRemove():void
		{
			AppFacade(facade).gameModel.triggerBroadcaster.unsubscribe(onTrigger);

			var startScreen:StartScreen = getViewComponent() as StartScreen;
			if (startScreen)
			{
				startScreen.removeEventListener("continueGame", onStart);
				startScreen.removeEventListener("newGame", onNewGame);
			}
		}

		private function onStart(event:Event):void
		{
			sendNotification(Const.SWITCH_TO, Const.STATE_GAME);
		}

		private function onNewGame(event:Event):void
		{
			sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
					LocaleManager.getInstance().getString("common", "message.new.game"),
					onNewGameCallback, MessageBoxData.YES_BUTTON | MessageBoxData.NO_BUTTON));
		}

		private function onNewGameCallback(result:uint):void
		{
			if (result == MessageBoxData.YES_BUTTON)
			{
				sendNotification(Const.NEW_GAME);
				sendNotification(Const.SWITCH_TO, Const.STATE_GAME);
			}
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
