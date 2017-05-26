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

		[Bindable(event="hasCurrentGameChanged")]
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
				startScreen.addEventListener("openVip", onVip);
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
				startScreen.removeEventListener("openVip", onVip);
			}
		}

		private function onStart(event:Event):void
		{
			sendNotification(Const.SWITCH_TO, Const.STATE_GAME);
		}

		private function onVip(event:Event):void
		{
			sendNotification(Const.SWITCH_TO, Const.STATE_VIP);
		}

		private function onNewGame(event:Event):void
		{
			if (hasCurrentGame)
			{
				sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
						LocaleManager.getInstance().getString("common", "message.new.game"),
						onNewGameCallback, MessageBoxData.YES_BUTTON | MessageBoxData.NO_BUTTON));
			}
			else
			{
				sendNotification(Const.NEW_GAME);
				sendNotification(Const.SWITCH_TO, Const.STATE_GAME);
			}
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
			if (trigger == TriggerBroadcaster.HAS_GAME_CHANGED)
			{
				dispatchEventWith("hasCurrentGameChanged");
			}
		}
	}
}
