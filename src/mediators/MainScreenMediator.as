package mediators
{
	import models.IPopUpData;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	import view.MainScreen;

	public class MainScreenMediator extends Mediator
	{
		private static var _interests:Array = [Const.POP, Const.POP_TO_ROOT,
			Const.SWITCH_TO_GAME, Const.SWITCH_TO_SHOP, Const.SHOW];

		private var _view:MainScreen;

		public function MainScreenMediator(mediatorName:String, viewComponent:Object)
		{
			super(mediatorName, viewComponent);
		}

		override public function setViewComponent(viewComponent:Object):void
		{
			super.setViewComponent(viewComponent);
			_view = viewComponent as MainScreen;
		}

		override public function listNotificationInterests():Array
		{
			return _interests;
		}

		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case Const.POP:
					_view.popScreen();
					break;
				case Const.POP_TO_ROOT:
					_view.popToRootScreen();
					break;
				case Const.SWITCH_TO_GAME:
					_view.pushScreen("gameScreenItem");
					break;
				case Const.SWITCH_TO_SHOP:
					_view.pushScreen("shopScreenItem");
					break;
				case Const.SHOW:
					var data:IPopUpData = notification.getBody() as IPopUpData;
					_view.showPopUp(data.title, data.description);
					break;
				default:
					throw Error("Not supported yet.");
			}
		}
	}
}
