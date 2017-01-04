package view
{
	import app.AppFacade;

	import feathers.controls.LayoutGroup;

	import mediators.GameScreenMediator;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	[Event(name="back", type="starling.events.Event")]
	[Event(name="shop", type="starling.events.Event")]
	[Event(name="tap", type="starling.events.Event")]

	public class GameScreen extends LayoutGroup
	{
		public static const BACK:String = "back";
		public static const SHOP:String = "shop";
		public static const TAP:String = "tap";

		public static const MEDIATOR_NAME:String = "gameScreenMediator";

		[Bindable]
		protected var _mediator:GameScreenMediator;

		public function GameScreen()
		{
			super();
		}

		override protected function initialize():void
		{
			super.initialize();

			var facade:AppFacade = Facade.getInstance(AppFacade.NAME) as AppFacade;
			if (facade.hasMediator(MEDIATOR_NAME))
			{
				_mediator = facade.retrieveMediator(MEDIATOR_NAME) as GameScreenMediator;
				facade.removeMediator(MEDIATOR_NAME);
				_mediator.setViewComponent(this);
			}
			else
			{
				_mediator = new GameScreenMediator(MEDIATOR_NAME, this);
			}
			facade.registerMediator(_mediator);
		}

		override public function dispose():void
		{
			if (_mediator)
			{
				var facade:AppFacade = Facade.getInstance(AppFacade.NAME) as AppFacade;
				facade.removeMediator(_mediator.getMediatorName());
			}
			super.dispose();
		}
	}
}
