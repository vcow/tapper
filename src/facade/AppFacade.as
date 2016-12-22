package facade
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

	import proxy.AchievementsProxy;

	import proxy.LevelsProxy;

	import proxy.UnitsProxy;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class AppFacade extends Facade
	{
		public static const NAME:String = "APP_FACADE";

		[Embed(source="config/units.xml", mimeType="application/octet-stream")]
		private static const unitsConfig:Class;

		[Embed(source="config/levels.xml", mimeType="application/octet-stream")]
		private static const levelsConfig:Class;

		[Embed(source="config/achievements.xml", mimeType="application/octet-stream")]
		private static const achievementsConfig:Class;

		public function AppFacade(key:String)
		{
			super(key);
		}

		override protected function initializeController():void
		{
			super.initializeController();

			registerCommand(Const.ACTIVATE, ActivateCommand);
			registerCommand(Const.DEACTIVATE, DeactivateCommand);
			registerCommand(Const.TICK, GameTickCommand);
			registerCommand(Const.TAP, GameTapCommand);
			registerCommand(Const.START_GAME, StartGameCommand);
			registerCommand(Const.STOP_GAME, StopGameCommand);
			registerCommand(Const.BUY, BuyUnitCommand);
			registerCommand(Const.ACHIEVE, GetAchievementCommand);
			registerCommand(Const.LEVEL_UP, LevelUpCommand);
			registerCommand(Const.SET_SKIN_BRONZE, SetSkinBronzeCommand);
		}

		override protected function initializeModel():void
		{
			super.initializeModel();

			registerProxy(new UnitsProxy(XML(new unitsConfig())));
			registerProxy(new LevelsProxy(XML(new levelsConfig())));
			registerProxy(new AchievementsProxy(XML(new achievementsConfig())));
		}

		override protected function initializeView():void
		{
			super.initializeView();

			// register mediators
		}
	}
}
