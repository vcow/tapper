package mediators
{
	import app.AppFacade;

	import feathers.motion.Fade;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import starling.events.Event;

	import view.MainScreen;
	import view.messagebox.MessageBoxPopUp;

	import vo.MessageBoxData;
	import vo.TutorialData;

	/**
	 * Медиатор главного окна приложения.
	 */
	public class MainScreenMediator extends BindableMediator
	{
		private static var _interests:Array = [Const.SWITCH_TO, Const.SHOW_MESSAGE, Const.SHOW_TUTORIAL];

		public function MainScreenMediator(mediatorName:String, viewComponent:Object)
		{
			super(mediatorName, viewComponent);
		}

		override public function listNotificationInterests():Array
		{
			return _interests;
		}

		override public function onRegister():void
		{
			var mainScreen:MainScreen = getViewComponent() as MainScreen;
			if (mainScreen)
			{
				switchToState(AppFacade(facade).gameModel.currentState);
			}
		}

		override public function handleNotification(notification:INotification):void
		{
			var mainScreen:MainScreen = getViewComponent() as MainScreen;
			if (mainScreen)
			{
				switch (notification.getName())
				{
					case Const.SWITCH_TO:
						var newState:String = notification.getBody() as String;
						if (newState != AppFacade(facade).gameModel.currentState)
						{
							switchToState(newState);
						}
						break;
					case Const.SHOW_MESSAGE:
						var messageBox:MessageBoxPopUp = new MessageBoxPopUp();
						messageBox.data = notification.getBody() as MessageBoxData;
						WindowManager.getInstance().openWindow(messageBox, true);
						break;
					case Const.SHOW_TUTORIAL:
						mainScreen.tutorialScreen.showScreen(notification.getBody() as TutorialData);
						break;
					default:
						throw Error("Not supported yet.");
				}
			}
		}

		private function switchToState(newState:String):void
		{
			var mainScreen:MainScreen = getViewComponent() as MainScreen;
			var screenId:String;
			switch (newState)
			{
				case Const.STATE_START:
					screenId = "startScreenItem";
					break;
				case Const.STATE_GAME:
					screenId = "gameScreenItem";
					break;
				case Const.STATE_SHOP:
					screenId = "shopScreenItem";
					break;
				case Const.STATE_VIP:
					screenId = "vipScreenItem";
					break;
				case Const.STATE_PANTHEON:
					screenId = "pantheonScreenItem";
					break;
				default:
					throw Error("Unsupported state " + newState + ".");
			}

			if (mainScreen.screenNavigator.hasScreen(screenId))
			{
				mainScreen.screenNavigator.showScreen(screenId, Fade.createCrossfadeTransition(0.3));
				AppFacade(facade).gameModel.currentState = newState;
			}
			else
			{
				mainScreen.screenNavigator.addEventListener(Event.CHANGE, function (event:Event):void
				{
					if (mainScreen.screenNavigator.activeScreenID == screenId)
					{
						mainScreen.screenNavigator.removeEventListener(Event.CHANGE, arguments.callee);
						AppFacade(facade).gameModel.currentState = newState;
					}
				});
			}
		}
	}
}
