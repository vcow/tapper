package view
{
	import app.AppFacade;

	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;

	import mediators.GameScreenLayerMediator;

	import models.SkinType;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	import starling.display.DisplayObject;

	import view.bronze.GameScreenBronze;

	import view.wooden.GameScreenWooden;

	public class GameScreen extends LayoutGroup
	{
		private var _view:GameScreenViewBase;
		private var _currentSkin:String;

		protected var _mediator:GameScreenLayerMediator;

		public static const MEDIATOR_NAME:String = "gameScreenLayerMediator";

		public function GameScreen()
		{
			super();

			layout = new AnchorLayout();

			_view = new GameScreenWooden();
			_currentSkin = SkinType.WOOD;
		}

		override protected function initialize():void
		{
			super.initialize();

			var facade:AppFacade = Facade.getInstance(AppFacade.NAME) as AppFacade;
			if (facade.hasMediator(MEDIATOR_NAME))
			{
				_mediator = facade.retrieveMediator(MEDIATOR_NAME) as GameScreenLayerMediator;
				_mediator.setViewComponent(this);
			}
			else
			{
				var mediator:GameScreenLayerMediator = new GameScreenLayerMediator(MEDIATOR_NAME, this);
				facade.registerMediator(mediator);
				_mediator = mediator;
			}

			addChild(DisplayObject(_view));
		}

		override public function dispose():void
		{
			if (_mediator)
			{
				var facade:AppFacade = Facade.getInstance(AppFacade.NAME) as AppFacade;
				facade.removeMediator(_mediator.getMediatorName());
				_mediator = null;
			}
			super.dispose();
		}

		public function setSkin(skin:String):void
		{
			if (skin == _currentSkin) return;

			switch (skin)
			{
				case SkinType.WOOD:
					_view = new GameScreenWooden();
					break;
				case SkinType.BRONZE:
					_view = new GameScreenBronze();
					break;
				default:
					return;
			}

			if (isInitialized)
			{
				removeChildren(0, -1, true);
				addChild(DisplayObject(_view));
			}
		}
	}
}
