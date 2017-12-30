package app
{
	import commands.ActionGodModeCommand;
	import commands.ActivateCommand;
	import commands.ApplyPackCommand;
	import commands.BuyPackCommand;
	import commands.BuyUnitCommand;
	import commands.DeactivateCommand;
	import commands.GameTapCommand;
	import commands.GameTickCommand;
	import commands.GetAchievementCommand;
	import commands.LevelUpCommand;
	import commands.NewGameCommand;
	import commands.OverflowCommand;
	import commands.RestorePackCommand;
	import commands.SetStateCommand;
	import commands.SaveAddonsCommand;
	import commands.SetSkinBronzeCommand;
	import commands.StartGameCommand;
	import commands.StopGameCommand;
	import commands.SwitchToStateCommand;
	import commands.UnitPurchasedCommand;
	import commands.UpdateActivityCommand;
	import commands.UpdateLevelCommand;
	import commands.UpdateMoneyCommand;
	import commands.UpdateMultiplierCommand;
	import commands.UpdateTapsCommand;

	import models.GameModel;

	import proxy.AchievementsProxy;

	import proxy.LevelsProxy;
	import proxy.PacksProxy;

	import proxy.UnitsProxy;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	/**
	 * Фассад приложения
	 */
	public class AppFacade extends Facade
	{
		public static const NAME:String = "appFacade";

		[Embed(source="config/units.xml", mimeType="application/octet-stream")]
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
			registerCommand(Const.BUY_PACK, BuyPackCommand);
			registerCommand(Const.RESTORE_PACK, RestorePackCommand);
			registerCommand(Const.APPLY_PACK, ApplyPackCommand);
			registerCommand(Const.ACHIEVE, GetAchievementCommand);
			registerCommand(Const.LEVEL_UP_ACTION, LevelUpCommand);
			registerCommand(Const.SET_SKIN_BRONZE_ACTION, SetSkinBronzeCommand);
			registerCommand(Const.POP, SetStateCommand);
			registerCommand(Const.SWITCH_TO, SwitchToStateCommand);
			registerCommand(Const.POP_TO_ROOT, SetStateCommand);
			registerCommand(Const.NEW_GAME, NewGameCommand);
			registerCommand(Const.UPDATE_LEVEL, UpdateLevelCommand);
			registerCommand(Const.UPDATE_MONEY, UpdateMoneyCommand);
			registerCommand(Const.UPDATE_TAPS, UpdateTapsCommand);
			registerCommand(Const.UNIT_PURCHASED, UnitPurchasedCommand);
			registerCommand(Const.UPDATE_ACTIVITY, UpdateActivityCommand);
			registerCommand(Const.OVERFLOW, OverflowCommand);
			registerCommand(Const.UPDATE_MULTIPLIER, UpdateMultiplierCommand);
			registerCommand(Const.SAVE_ADDONS, SaveAddonsCommand);
			registerCommand(Const.ACTION_GOD_MODE, ActionGodModeCommand);
		}

		override protected function initializeModel():void
		{
			super.initializeModel();

			var unitsProxy:UnitsProxy = new UnitsProxy();
			var levelsProxy:LevelsProxy = new LevelsProxy();
			var achievementsProxy:AchievementsProxy = new AchievementsProxy();
			var packsProxy:PacksProxy = new PacksProxy();

			registerProxy(unitsProxy);
			registerProxy(levelsProxy);
			registerProxy(achievementsProxy);
			registerProxy(packsProxy);

			unitsProxy.setData(XML(new unitsConfig()));
			levelsProxy.setData(XML(new levelsConfig()));
			achievementsProxy.setData(XML(new achievementsConfig()));

			sendNotification(Const.UPDATE_MONEY, gameModel.money);
			sendNotification(Const.UPDATE_TAPS, gameModel.tapsTotal);
		}
	}
}
