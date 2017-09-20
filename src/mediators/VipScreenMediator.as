package mediators
{
	import app.AppFacade;

	import feathers.data.ListCollection;

	import net.Purchase;

	import proxy.PacksProxy;

	import resources.locale.LocaleManager;

	import starling.events.Event;

	import view.VipScreen;

	import vo.MessageBoxData;

	import vo.Pack;

	/**
	 * Медиатор окна магазина приложения (VIP зона).
	 */
	public class VipScreenMediator extends BindableMediator
	{
		private var _packList:ListCollection;

		public function VipScreenMediator(mediatorName:String = null, viewComponent:Object = null)
		{
			super(mediatorName, viewComponent);
		}

		override public function onRegister():void
		{
			Purchase.getInstance().addEventListener("status", onPurchaseStatusChanged);

			var vipScreen:VipScreen = getViewComponent() as VipScreen;
			if (vipScreen)
			{
				vipScreen.addEventListener("back", onBack);
				vipScreen.addEventListener("buyPack", onBuyPack);

				vipScreen.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				if (vipScreen.stage) onAddedToStage(null);

//				var gameModel:GameModel = AppFacade(facade).gameModel;
//
//				_money = Math.round(gameModel.money);
//				dispatchEventWith("moneyChanged");
//
//				var unitsProxy:UnitsProxy = facade.retrieveProxy(UnitsProxy.NAME) as UnitsProxy;
//				_unitsList = new ListCollection(unitsProxy.units);
//				dispatchEventWith("unitsListChanged");
			}
		}

		override public function onRemove():void
		{
			Purchase.getInstance().removeEventListener("status", onPurchaseStatusChanged);

			var vipScreen:VipScreen = getViewComponent() as VipScreen;
			if (vipScreen)
			{
				vipScreen.removeEventListener("back", onBack);
				vipScreen.removeEventListener("buyPack", onBuyPack);

				vipScreen.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}

		override public function setViewComponent(viewComponent:Object):void
		{
			if (viewComponent == viewComponent) return;

			if (viewComponent)
			{
				viewComponent.removeEventListener("back", onBack);
				viewComponent.removeEventListener("buyPack", onBuyPack);
			}

			super.setViewComponent(viewComponent);
			if (viewComponent)
			{
				viewComponent.addEventListener("back", onBack);
				viewComponent.addEventListener("buyPack", onBuyPack);
			}
		}

		private function onBack(event:Event):void
		{
			sendNotification(Const.POP);
		}

		private function onBuyPack(event:Event):void
		{
			var pack:Pack = event.data as Pack;
			if (pack)
			{
				sendNotification(Const.BUY_PACK, pack);
			}
		}

		public function get packList():ListCollection
		{
			if (!_packList)
			{
				var packsProxy:PacksProxy = PacksProxy(facade.retrieveProxy(PacksProxy.NAME));
				_packList = new ListCollection(packsProxy.packs);
			}
			return _packList;
		}

		private function onAddedToStage(event:Event):void
		{
			if (!shopAvailable)
			{
				sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
						LocaleManager.getInstance().getString("common", "message.purchase.error"),
						onMessageClose, Const.ON_OK));
			}
		}

		private function onMessageClose(result:uint):void
		{
			sendNotification(Const.POP);
		}

		private function onPurchaseStatusChanged(event:Event):void
		{
			dispatchEventWith("shopAvailable");
		}

		[Bindable(event="shopAvailable")]
		/**
		 * Флаг магазин доступен / недоступен
		 */
		public function get shopAvailable():Boolean
		{
			return Purchase.getInstance().isSupported;
		}
	}
}
