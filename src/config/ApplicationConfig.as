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

	import dto.AchievementEvent;
	import dto.ActionEvent;

	import dto.BuyUnitEvent;

	import dto.GameEvent;

	import dto.GameStateEvent;

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
			mediatorMap.map(MainScreen).toMediator(MainScreenMediator);
			mediatorMap.map(StartScreen).toMediator(StartScreenMediator);
			mediatorMap.map(GameScreen).toMediator(GameScreenMediator);
			mediatorMap.map(ShopScreen).toMediator(ShopScreenMediator);
			mediatorMap.map(ShopListItemRenderer).toMediator(ShopListItemMediator);
			mediatorMap.map(UnitListItemRenderer).toMediator(UnitListItemMediator);
			mediatorMap.map(ShopWidget).toMediator(ShopWidgetMediator);

		}
	}
}
