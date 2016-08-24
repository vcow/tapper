package mediators
{
	import app.AppFacade;

	import models.GameModel;

	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	import starling.events.Event;

	import view.TutorialView;

	/**
	 * Медиатор туториала.
	 */
	public class TutorialMediator extends Mediator
	{
		public function TutorialMediator(mediatorName:String = null, viewComponent:Object = null)
		{
			super(mediatorName, viewComponent);
		}

		override public function onRegister():void
		{
			var tutorialView:TutorialView = getViewComponent() as TutorialView;
			if (tutorialView)
			{
				tutorialView.addEventListener(Event.COMPLETE, onTutorialComplete);
			}
		}

		override public function onRemove():void
		{
			var tutorialView:TutorialView = getViewComponent() as TutorialView;
			if (tutorialView)
			{
				tutorialView.removeEventListener(Event.COMPLETE, onTutorialComplete);
			}
		}

		private function onTutorialComplete(event:Event):void
		{
			if (event.data is String)
			{
				var gameModel:GameModel = AppFacade(facade).gameModel;
				gameModel.tutorial[event.data] = 1;
			}
		}
	}
}
