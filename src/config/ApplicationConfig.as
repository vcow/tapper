package config
{
	import commands.BuyUnitCommand;
	import commands.GameTapCommand;
	import commands.GameTickCommand;
	import commands.GetAchievmentCommand;
	import commands.StartGameCommand;
	import commands.StopGameCommand;

	import events.AchievementEvent;

	import events.BuyUnitEvent;

	import events.GameEvent;

	import events.GameStateEvent;

	import gears.TriggerBroadcaster;

	import mediators.MainScreenMediator;
	import mediators.GameScreenMediator;
	import mediators.ShopListItemMediator;
	import mediators.ShopScreenMediator;
	import mediators.StartScreenMediator;

	import models.AchievementsModel;

	import models.GameModel;
	import models.LevelsModel;
	import models.UnitsModel;

	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;

	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.starling.extensions.mediatorMap.api.IMediatorMap;

	import view.MainScreen;

	import view.GameScreen;
	import view.ShopListItemRenderer;
	import view.ShopScreen;

	import view.StartScreen;

	public class ApplicationConfig implements IConfig
	{
		[Inject]
		public var injector:IInjector;

		[Inject]
		public var mediatorMap:IMediatorMap;

		[Inject]
		public var eventCommandMap:IEventCommandMap;

		public function ApplicationConfig()
		{
		}

		public function configure():void
		{
			injector.map(UnitsModel).toSingleton(UnitsModel);
			injector.map(GameModel).toSingleton(GameModel);
			injector.map(LevelsModel).toSingleton(LevelsModel);
			injector.map(AchievementsModel).toSingleton(AchievementsModel);
			injector.map(TriggerBroadcaster).toSingleton(TriggerBroadcaster);

			mediatorMap.map(MainScreen).toMediator(MainScreenMediator);
			mediatorMap.map(StartScreen).toMediator(StartScreenMediator);
			mediatorMap.map(GameScreen).toMediator(GameScreenMediator);
			mediatorMap.map(ShopScreen).toMediator(ShopScreenMediator);
			mediatorMap.map(ShopListItemRenderer).toMediator(ShopListItemMediator);

			eventCommandMap.map(GameStateEvent.START_GAME, GameStateEvent).toCommand(StartGameCommand);
			eventCommandMap.map(GameStateEvent.STOP_GAME, GameStateEvent).toCommand(StopGameCommand);
			eventCommandMap.map(GameEvent.TICK, GameEvent).toCommand(GameTickCommand);
			eventCommandMap.map(GameEvent.TAP, GameEvent).toCommand(GameTapCommand);
			eventCommandMap.map(BuyUnitEvent.BUY, BuyUnitEvent).toCommand(BuyUnitCommand);
			eventCommandMap.map(AchievementEvent.ACHIEVE, AchievementEvent).toCommand(GetAchievmentCommand);
		}
	}
}
