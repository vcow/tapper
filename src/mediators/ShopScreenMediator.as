package mediators
{
	import events.SwitchScreenEvent;

	import robotlegs.starling.bundles.mvcs.Mediator;

	import view.GameScreen;

	import starling.events.Event;

	public class ShopScreenMediator extends Mediator
	{
		public function ShopScreenMediator()
		{
			super();
		}

		override public function initialize():void
		{
			addViewListener(GameScreen.BACK, onBack);
		}

		private function onBack(event:Event):void
		{
			dispatch(new SwitchScreenEvent(SwitchScreenEvent.POP));
		}
	}
}
