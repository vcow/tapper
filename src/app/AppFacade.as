package app
{
	import commands.ActivateCommand;
	import commands.BuyUnitCommand;
	import commands.DeactivateCommand;
	import commands.GameTapCommand;
	import commands.GameTickCommand;
	import commands.GetAchievementCommand;
	import commands.LevelUpCommand;
	import commands.NewGameCommand;
	import commands.PopCommand;
	import commands.SetSkinBronzeCommand;
	import commands.StartGameCommand;
	import commands.StopGameCommand;
	import commands.SwitchToCommand;

	import models.GameModel;

	import proxy.AchievementsProxy;

	import proxy.LevelsProxy;

	import proxy.UnitsProxy;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class AppFacade extends Facade
	{
		public static const NAME:String = "appFacade";

		[Embed(source="config/units_prod.xml", mimeType="application/octet-stream")]
		private static const unitsConfig:Class;

		[Embed(source="config/levels.xml", mimeType="application/octet-stream")]
		private static const levelsConfig:Class;

		[Embed(source="config/achievements.xml", mimeType="application/octet-stream")]
		private static const achievementsConfig:Class;

		private var _gameModel:GameModel;

		public function AppFacade(key:String)
		{
			super(key);
		}

		override protected function initializeFacade():void
		{
			_gameModel = new GameModel(multitonKey);
			super.initializeFacade();
		}

		public function get gameModel():GameModel
		{
			return _gameModel;
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
			registerCommand(Const.POP, PopCommand);
			registerCommand(Const.SWITCH_TO, SwitchToCommand);
			registerCommand(Const.POP_TO_ROOT, PopCommand);
			registerCommand(Const.NEW_GAME, NewGameCommand);
		}

		override protected function initializeModel():void
		{
			super.initializeModel();

			var unitsProxy:UnitsProxy = new UnitsProxy();
			var levelsProxy:LevelsProxy = new LevelsProxy();
			var achievementsProxy:AchievementsProxy = new AchievementsProxy();

			registerProxy(unitsProxy);
			registerProxy(levelsProxy);
			registerProxy(achievementsProxy);

			unitsProxy.setData(XML(new unitsConfig()));
			levelsProxy.setData(XML(new levelsConfig()));
			achievementsProxy.setData(XML(new achievementsConfig()));
		}
	}
}
