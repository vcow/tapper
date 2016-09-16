package config
{
	import commands.ActivateCommand;
	import commands.BuyUnitCommand;
	import commands.DeactivateCommand;
	import commands.GameTapCommand;
	import commands.GameTickCommand;
	import commands.GetAchievementCommand;
	import commands.LevelUpCommand;
	import commands.SetSkinBronzeCommand;
	import commands.StartGameCommand;
	import commands.StopGameCommand;

	import events.AchievementEvent;
	import events.ActionEvent;

	import events.BuyUnitEvent;

	import events.GameEvent;

	import events.GameStateEvent;

	import gears.TriggerBroadcaster;

	import mediators.MainScreenMediator;
	import mediators.GameScreenMediator;
	import mediators.ShopListItemMediator;
	import mediators.ShopScreenMediator;
	import mediators.ShopWidgetMediator;
	import mediators.StartScreenMediator;
	import mediators.UnitListItemMediator;

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
	import view.ShopWidget;

	import view.StartScreen;
	import view.UnitListItemRenderer;

	public class ApplicationConfig implements IConfig
	{
		public static const APP_NAME:String = "simjew";
		public static const APP_VERSION:String = "1.0.0.0";

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
			mediatorMap.map(UnitListItemRenderer).toMediator(UnitListItemMediator);
			mediatorMap.map(ShopWidget).toMediator(ShopWidgetMediator);

			eventCommandMap.map(GameStateEvent.START_GAME, GameStateEvent).toCommand(StartGameCommand);
			eventCommandMap.map(GameStateEvent.STOP_GAME, GameStateEvent).toCommand(StopGameCommand);
			eventCommandMap.map(GameEvent.TICK, GameEvent).toCommand(GameTickCommand);
			eventCommandMap.map(GameEvent.TAP, GameEvent).toCommand(GameTapCommand);
			eventCommandMap.map(GameEvent.ACTIVATE, GameEvent).toCommand(ActivateCommand);
			eventCommandMap.map(GameEvent.DEACTIVATE, GameEvent).toCommand(DeactivateCommand);
			eventCommandMap.map(BuyUnitEvent.BUY, BuyUnitEvent).toCommand(BuyUnitCommand);
			eventCommandMap.map(AchievementEvent.ACHIEVE, AchievementEvent).toCommand(GetAchievementCommand);
			eventCommandMap.map(ActionEvent.LEVEL_UP, ActionEvent).toCommand(LevelUpCommand);
			eventCommandMap.map(ActionEvent.SET_SKIN_BRONZE, ActionEvent).toCommand(SetSkinBronzeCommand);
		}
	}
}
