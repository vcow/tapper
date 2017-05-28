package mediators
{
	import app.AppFacade;

	import models.GameModel;
	import models.SkinType;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	import view.GameScreen;

	public class GameScreenLayerMediator extends Mediator
	{
		private static var _interests:Array = [Const.SET_SKIN_BRONZE_ACTION];

		public function GameScreenLayerMediator(mediatorName:String, viewComponent:Object)
		{
			super(mediatorName, viewComponent);
		}

		override public function listNotificationInterests():Array
		{
			return _interests;
		}

		override public function onRegister():void
		{
			var gameScreenLayer:GameScreen = getViewComponent() as GameScreen;
			if (gameScreenLayer)
			{
				var gameModel:GameModel = AppFacade(facade).gameModel;

				gameScreenLayer.setSkin(gameModel.currentSkin);
			}
		}

		override public function handleNotification(notification:INotification):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			switch (notification.getName())
			{
				case Const.SET_SKIN_BRONZE_ACTION:
					var gameScreenLayer:GameScreen = getViewComponent() as GameScreen;
					gameScreenLayer.setSkin(SkinType.BRONZE);
					break;
			}
		}
	}
}
