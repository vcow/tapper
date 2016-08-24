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

	import vo.TutorialData;

	/**
	 * Медиатор базового слоя главного окна игры (Кабинета).
	 */
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
				var tutorialData:TutorialData;
				switch (gameModel.currentSkin)
				{
					case SkinType.WOOD:
						if (!gameModel.tutorial.gameScreenWooden)
						{
							tutorialData = new TutorialData("gameScreenWooden");
							tutorialData.frames.push(new TutorialFrame(new flash.geom.Rectangle(14, 4, 106, 100),
									lm.getString("common", "tutor.game.wood.back"), TutorialFrame.RIGHT, 40));
							tutorialData.frames.push(new TutorialFrame(new flash.geom.Rectangle(22, 528, 390, 110),
									lm.getString("common", "tutor.game.wood.action"), TutorialFrame.TOP, 20));
							tutorialData.frames.push(new TutorialFrame(new flash.geom.Rectangle(423, 520, 124, 124),
									lm.getString("common", "tutor.game.wood.shop"), TutorialFrame.BOTTOM, 120));
						}
						break;
				}

				if (tutorialData)
				{
					var onShowTutorial:Function = function (event:Event):void
					{
						if (event)
							event.target.removeEventListener(FeathersEventType.CREATION_COMPLETE, onShowTutorial);
						sendNotification(Const.SHOW_TUTORIAL, tutorialData);
					};

					if (gameScreenLayer.isCreated)
						onShowTutorial(null);
					else
						gameScreenLayer.addEventListener(FeathersEventType.CREATION_COMPLETE, onShowTutorial);
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
