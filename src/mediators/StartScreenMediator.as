package mediators
{
	import app.AppFacade;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import resources.locale.LocaleManager;

	import starling.events.Event;

	import view.StartScreen;

	import vo.MessageBoxData;

	/**
	 * Медиатор стартового окна.
	 */
	public class StartScreenMediator extends BindableMediator
	{
		private static var _interests:Array = [Const.UPDATE_CURRENT_GAME];

		public function StartScreenMediator(mediatorName:String, viewComponent:Object)
		{
			super(mediatorName, viewComponent);
		}

		[Bindable(event="hasCurrentGameChanged")]
		/**
		 * Флаг указвыает наличие / отсутствие текущей игры (возможность / невозможность продолжить игру).
		 */
		public function get hasCurrentGame():Boolean
		{
			return AppFacade(facade).gameModel.hasCurrentGame;
		}

		override public function listNotificationInterests():Array
		{
			return _interests;
		}

		override public function onRegister():void
		{
			var startScreen:StartScreen = getViewComponent() as StartScreen;
			if (startScreen)
			{
				startScreen.addEventListener("continueGame", onStart);
				startScreen.addEventListener("newGame", onNewGame);
				startScreen.addEventListener("openVip", onVip);
				startScreen.addEventListener("openPantheon", onPantheon);
			}
		}

		override public function onRemove():void
		{
			var startScreen:StartScreen = getViewComponent() as StartScreen;
			if (startScreen)
			{
				startScreen.removeEventListener("continueGame", onStart);
				startScreen.removeEventListener("newGame", onNewGame);
				startScreen.removeEventListener("openVip", onVip);
				startScreen.removeEventListener("openPantheon", onPantheon);
			}
		}

		override public function setViewComponent(viewComponent:Object):void
		{
			if (viewComponent == viewComponent) return;

			if (viewComponent)
			{
				viewComponent.removeEventListener("continueGame", onStart);
				viewComponent.removeEventListener("newGame", onNewGame);
				viewComponent.removeEventListener("openVip", onVip);
				viewComponent.removeEventListener("openPantheon", onPantheon);
			}

			super.setViewComponent(viewComponent);
			if (viewComponent)
			{
				viewComponent.addEventListener("continueGame", onStart);
				viewComponent.addEventListener("newGame", onNewGame);
				viewComponent.addEventListener("openVip", onVip);
				viewComponent.addEventListener("openPantheon", onPantheon);
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

		private function onPantheon(event:Event):void
		{
			sendNotification(Const.SWITCH_TO, Const.STATE_PANTHEON);
		}

		private function onNewGame(event:Event):void
		{
			if (hasCurrentGame)
			{
				sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
						LocaleManager.getInstance().getString("common", "message.new.game"),
						onNewGameCallback, Const.ON_YES | Const.ON_NO));
			}
			else
			{
				sendNotification(Const.NEW_GAME);
				sendNotification(Const.SWITCH_TO, Const.STATE_GAME);
			}
		}

		private function onNewGameCallback(result:uint):void
		{
			if (result == Const.ON_YES)
			{
				sendNotification(Const.NEW_GAME);
				sendNotification(Const.SWITCH_TO, Const.STATE_GAME);
			}
		}

		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case Const.UPDATE_CURRENT_GAME:
					dispatchEventWith("hasCurrentGameChanged");
					break;
			}
		}
	}
}
