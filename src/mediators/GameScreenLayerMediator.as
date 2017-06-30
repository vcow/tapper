package mediators
{
	import app.AppFacade;

	import feathers.events.FeathersEventType;

	import flash.geom.Rectangle;

	import models.GameModel;
	import models.SkinType;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	import resources.locale.LocaleManager;

	import starling.events.Event;

	import view.GameScreen;
	import view.TutorialFrame;

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

				var lm:LocaleManager = LocaleManager.getInstance();
				var tutorialFrames:Vector.<TutorialFrame> = new Vector.<TutorialFrame>();
				switch (gameModel.currentSkin)
				{
					case SkinType.WOOD:
						tutorialFrames.push(new TutorialFrame(new flash.geom.Rectangle(14, 4, 106, 100),
								lm.getString("common", "tutor.game.wood.back"), TutorialFrame.RIGHT, 40));
						tutorialFrames.push(new TutorialFrame(new flash.geom.Rectangle(22, 528, 390, 110),
								lm.getString("common", "tutor.game.wood.action"), TutorialFrame.TOP, 20));
						tutorialFrames.push(new TutorialFrame(new flash.geom.Rectangle(423, 520, 124, 124),
								lm.getString("common", "tutor.game.wood.shop"), TutorialFrame.BOTTOM, 120));
						break;
				}
				if (gameScreenLayer.isCreated)
				{
					sendNotification(Const.SHOW_TUTORIAL, tutorialFrames);
				}
				else
				{
					gameScreenLayer.addEventListener(FeathersEventType.CREATION_COMPLETE, function (event:Event):void
					{
						gameScreenLayer.removeEventListener(FeathersEventType.CREATION_COMPLETE, arguments.callee);
						sendNotification(Const.SHOW_TUTORIAL, tutorialFrames);
					});
				}
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
