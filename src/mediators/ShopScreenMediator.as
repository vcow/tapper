package mediators
{
	import events.SwitchScreenEvent;

	import models.GameModel;

	import robotlegs.starling.bundles.mvcs.Mediator;

	import starling.events.Event;

	import view.ShopScreen;

	public class ShopScreenMediator extends Mediator
	{
		[Inject]
		public var gameModel:GameModel;

		[Inject]
		public var view:ShopScreen;

		public function ShopScreenMediator()
		{
			super();
		}

		override public function initialize():void
		{
			addViewListener(ShopScreen.BACK, onBack);

			ShopScreen(view).money = gameModel.money;
		}

		private function onBack(event:Event):void
		{
			dispatch(new SwitchScreenEvent(SwitchScreenEvent.POP));
		}
	}
}
