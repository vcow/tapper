package mediators
{
	import models.IPopUpData;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import view.MainScreen;

	public class MainScreenMediator extends BindableMediator
	{
		private static var _interests:Array = [Const.POP, Const.POP_TO_ROOT,
			Const.SWITCH_TO_GAME, Const.SWITCH_TO_SHOP, Const.SHOW];

		public function MainScreenMediator(mediatorName:String, viewComponent:Object)
		{
			super(mediatorName, viewComponent);
		}

		override public function listNotificationInterests():Array
		{
			return _interests;
		}

		override public function handleNotification(notification:INotification):void
		{
			var mainScreen:MainScreen = getViewComponent() as MainScreen;
			if (mainScreen)
			{
				switch (notification.getName())
				{
					case Const.POP:
						mainScreen.popScreen();
						break;
					case Const.POP_TO_ROOT:
						mainScreen.popToRootScreen();
						break;
					case Const.SWITCH_TO_GAME:
						mainScreen.pushScreen("gameScreenItem");
						break;
					case Const.SWITCH_TO_SHOP:
						mainScreen.pushScreen("shopScreenItem");
						break;
					case Const.SHOW:
						var data:IPopUpData = notification.getBody() as IPopUpData;
						mainScreen.showPopUp(data.title, data.description);
						break;
					default:
						throw Error("Not supported yet.");
				}
			}
		}
	}
}
