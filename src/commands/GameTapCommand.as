package commands
{
	import app.AppFacade;

	import flash.media.Sound;

	import flash.utils.getTimer;

	import models.GameModel;
	import models.ProfitInfo;

	import resources.AtlasLibrary;

	import starling.utils.AssetManager;

	import vo.Unit;

	import org.puremvc.as3.multicore.interfaces.INotification;

	/**
	 * Команда нажатия на кнопку "Действовать". Рассчитывает профит, воспроизводит с определенной вероятностью
	 * звук прадающей монетки.
	 */
	public class GameTapCommand extends CalcProfitCommandBase
	{

		private static var _click1:Sound;
		private static function get click1():Sound
		{
			if (!_click1)
			{
				_click1 = AtlasLibrary.getInstance().manager.getSound("click1");
			}
			return _click1;
		}

		private static var _coinSounds:Vector.<Sound>;
		private static function get coinSounds():Vector.<Sound>
		{
			if (!_coinSounds)
			{
				var manager:AssetManager = AtlasLibrary.getInstance().manager;
				_coinSounds = new Vector.<Sound>();
				for (var i:int = 1; i <= 6; i++) _coinSounds.push(manager.getSound("coin" + i));
			}
			return _coinSounds;
		}

		private static var _lastCoinSound:int;
		private static var _soundCtr:int;
		private static var _coinDelay:int = 500;

		override public function execute(notification:INotification):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			if (!gameModel.isStarted)
				sendNotification(Const.START_GAME);
			else
				gameModel.lastActivityTimestamp = getTimer();

			gameModel.tapsTotal++;
			sendNotification(Const.UPDATE_TAPS, gameModel.tapsTotal);

			var profitList:Vector.<ProfitInfo> = new Vector.<ProfitInfo>();
			var units:Vector.<Unit> = gameModel.getUnits();
			for (var i:int = 0, l:int = units.length; i < l; i++)
			{
				var unit:Unit = units[i];
				if (unit.active)
				{
					unit.tap();
					if (unit.info.perClickProfit) profitList.push(unit.info.perClickProfit);
				}
			}

			if (calcProfitList(profitList, 1))
			{
				sendNotification(Const.UPDATE_MONEY, gameModel.money);

				if (gameModel.lastActivityTimestamp - _lastCoinSound >= _coinDelay)
				{
					_lastCoinSound = gameModel.lastActivityTimestamp;
					if (_soundCtr > 15) _soundCtr = Math.random() * _coinSounds.length;
					SoundManager.getInstance().playSound(coinSounds[_soundCtr++ % coinSounds.length]);
					_coinDelay = 300 + Math.random() * 1000;
				}
				else
				{
					SoundManager.getInstance().playSound(click1);
				}
			}
		}
	}
}
