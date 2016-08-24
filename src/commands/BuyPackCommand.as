package commands
{
	import app.AppFacade;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import models.GameModel;

	import net.Purchase;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import resources.locale.LocaleManager;

	import starling.events.Event;

	import vo.MessageBoxData;
	import vo.Pack;

	/**
	 * Команда на покупку пака в магазине.
	 */
	public class BuyPackCommand extends SimpleCommand
	{
		private static var _waitForBillingAction:BuyPackCommand;
		private var _pack:Pack;

		private var _waitForActiveTimer:Timer;

		override public function execute(notification:INotification):void
		{
			if (_waitForBillingAction)
			{
				sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
						LocaleManager.getInstance().getString("common", "message.wait.for.billing"), null, Const.ON_OK));
				return;
			}

			_pack = notification.getBody() as Pack;
			if (_pack.isConsumable && _pack.isPurchased)
			{
				applyPack();
				return;
			}

			var purchase:Purchase = Purchase.getInstance();
			if (purchase.isSupported)
			{
				_waitForBillingAction = this;
				purchase.addEventListener("purchaseComplete", onPurchaseComplete);
				purchase.addEventListener("purchaseFailed", onPurchaseFailed);

				purchase.purchase(_pack);
			}
		}

		private function onPurchaseComplete(event:Event):void
		{
			_waitForBillingAction = null;
			event.target.removeEventListener("purchaseComplete", onPurchaseComplete);
			event.target.removeEventListener("purchaseFailed", onPurchaseFailed);

			applyPack();
		}

		private function onPurchaseFailed(event:Event):void
		{
			_waitForBillingAction = null;
			event.target.removeEventListener("purchaseComplete", onPurchaseComplete);
			event.target.removeEventListener("purchaseFailed", onPurchaseFailed);

			sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
					LocaleManager.getInstance().getString("common", "message.purchase.failed"), null, Const.ON_OK));
		}

		/**
		 * Пак успешно куплен.
		 */
		private function applyPack():void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			if (!gameModel.isActive)
			{
				WaitForActive();
				return;
			}

			if (_pack.isConsumable)
			{
				_pack.isPurchased = false;
				consumePack();
			}

			sendNotification(Const.APPLY_PACK, _pack);
			sendNotification(Const.UPDATE_PACKS_LIST);

			switch (_pack.id)
			{
				case "qtap.silver_fish":
				case "qtap.golden_fish":
				case "qtap.silver_fish.pack":
				case "qtap.golden_fish.pack":
					sendNotification(Const.SWITCH_TO, Const.STATE_GAME);
					break;
			}
		}

		private function consumePack():void
		{
			_waitForBillingAction = this;

			var purchase:Purchase = Purchase.getInstance();
			if (purchase.isSupported)
			{
				purchase.addEventListener("restoreComplete", onRestoreComplete);
				purchase.addEventListener("restoreFailed", onRestoreComplete);

				purchase.restore(new <Pack>[_pack]);
			}
			else
			{
				purchase.addEventListener("status", onPurchaseStatusChanged);
			}
		}

		private function onRestoreComplete(event:Event):void
		{
			var purchase:Purchase = Purchase.getInstance();

			purchase.removeEventListener("restoreComplete", onRestoreComplete);
			purchase.removeEventListener("restoreFailed", onRestoreComplete);

			if (event.type == "restoreComplete")
			{
				purchase.addEventListener("consumeComplete", onConsumeComplete);
				purchase.addEventListener("consumeFailed", onConsumeComplete);

				purchase.consume(_pack);
			}
			else
			{
				trace("-- Failed to restore pack", _pack.id);
			}
		}

		private function onPurchaseStatusChanged(event:Event):void
		{
			event.target.removeEventListener("status", onPurchaseStatusChanged);
			consumePack();
		}

		private function onConsumeComplete(event:Event):void
		{
			var purchase:Purchase = Purchase(event.target);

			_waitForBillingAction = null;
			purchase.removeEventListener("consumeComplete", onConsumeComplete);
			purchase.removeEventListener("consumeFailed", onConsumeComplete);

			if (event.type == "consumeFailed")
			{
				trace("-- Failed to consume pack", _pack.id);
			}
		}

		private function WaitForActive():void
		{
			if (_waitForActiveTimer) return;

			_waitForActiveTimer = new Timer(30);
			_waitForActiveTimer.addEventListener(TimerEvent.TIMER, onWaitForActiveTimer);
			_waitForActiveTimer.start();
		}

		private function onWaitForActiveTimer(event:TimerEvent):void
		{
			if (!AppFacade(facade).gameModel.isActive) return;

			_waitForActiveTimer.removeEventListener(TimerEvent.TIMER, onWaitForActiveTimer);
			_waitForActiveTimer.stop();
			_waitForActiveTimer = null;

			applyPack();
		}
	}
}
