package mediators
{
	import app.AppFacade;

	import feathers.motion.Fade;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import view.MainScreen;
	import view.TutorialFrame;
	import view.messagebox.MessageBoxPopUp;

	import vo.MessageBoxData;

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
						mainScreen.tutorialScreen.showScreen(notification.getBody() as Vector.<TutorialFrame>);
						break;
					default:
						throw Error("Not supported yet.");
				}
			}
		}

		private function switchToState(newState:String):void
		{
			var mainScreen:MainScreen = getViewComponent() as MainScreen;
			switch (newState)
			{
				case Const.STATE_START:
					mainScreen.screenNavigator.showScreen("startScreenItem", Fade.createCrossfadeTransition(0.3));
					break;
				case Const.STATE_GAME:
					mainScreen.screenNavigator.showScreen("gameScreenItem", Fade.createCrossfadeTransition(0.3));
					break;
				case Const.STATE_SHOP:
					mainScreen.screenNavigator.showScreen("shopScreenItem", Fade.createCrossfadeTransition(0.3));
					break;
				case Const.STATE_VIP:
					mainScreen.screenNavigator.showScreen("vipScreenItem", Fade.createCrossfadeTransition(0.3));
					break;
				default:
					throw Error("Unsupported state " + newState + ".");
			}
			AppFacade(facade).gameModel.currentState = newState;
		}
	}
}
