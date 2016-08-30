package mediators
{
	import events.GameEvent;
	import events.GameStateEvent;
	import events.SwitchScreenEvent;
	import events.UIEvent;

	import feathers.data.ListCollection;

	import models.AchievementsModel;

	import models.GameModel;

	import robotlegs.starling.bundles.mvcs.Mediator;

	import view.GameScreen;

	import starling.events.Event;

	public class GameScreenMediator extends Mediator
	{
		[Inject]
		public var gameModel:GameModel;

		[Inject]
		public var view:GameScreen;

		[Inject]
		public var achievementsModel:AchievementsModel;

		public function GameScreenMediator()
		{
			super();
		}

		override public function initialize():void
		{
			addViewListener(GameScreen.BACK, onBack);
			addViewListener(GameScreen.SHOP, onShop);
			addViewListener(GameScreen.TAP, onTap);

			addContextListener(UIEvent.UPDATE_MONEY, onUpdateMoney);
			addContextListener(UIEvent.UPDATE_UNITS_LIST, onUpdateUnitsList);

			onUpdateMoney();
			onUpdateUnitsList();

			dispatch(new GameStateEvent(GameStateEvent.START_GAME));
		}

		private function onUpdateMoney(Event:UIEvent = null):void
		{
			GameScreen(view).money = gameModel.money;
		}

		private function onUpdateUnitsList(Event:UIEvent = null):void
		{
			GameScreen(view).unitsList = new ListCollection(gameModel.activeUnits);
		}

		private function onShop(event:Event):void
		{
			dispatch(new SwitchScreenEvent(SwitchScreenEvent.SWITCH_TO_SHOP));
		}

		private function onTap(event:Event):void
		{
			dispatch(new GameEvent(GameEvent.TAP));
		}

		private function onBack(event:Event):void
		{
			dispatch(new SwitchScreenEvent(SwitchScreenEvent.POP));
		}

		override public function destroy():void
		{
			dispatch(new GameStateEvent(GameStateEvent.STOP_GAME));
		}
	}
}
