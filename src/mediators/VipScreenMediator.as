package mediators
{
	import app.AppFacade;

	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;

	import flash.geom.Point;

	import flash.geom.Rectangle;

	import models.GameModel;

	import net.Purchase;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import proxy.PacksProxy;

	import resources.locale.LocaleManager;

	import starling.events.Event;

	import view.TutorialFrame;

	import view.VipScreen;

	import vo.MessageBoxData;
	import vo.Pack;
	import vo.TutorialData;

	/**
	 * Медиатор окна магазина приложения (VIP зона).
	 */
	public class VipScreenMediator extends BindableMediator
	{
		private static var _interests:Array = [Const.UPDATE_PACKS_LIST];

		public function VipScreenMediator(mediatorName:String = null, viewComponent:Object = null)
		{
			super(mediatorName, viewComponent);
		}

		override public function listNotificationInterests():Array
		{
			return _interests;
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

				var gameModel:GameModel = AppFacade(facade).gameModel;
				if (!gameModel.tutorial.vipScreen)
				{
					var lm:LocaleManager = LocaleManager.getInstance();
					var tutorialData:TutorialData = new TutorialData("vipScreen");
					tutorialData.frames.push(new TutorialFrame(new flash.geom.Rectangle(63, 41, 80, 80),
							lm.getString("common", "tutor.vip.back"), TutorialFrame.RIGHT, 78, new Point(10, 0)));
					tutorialData.frames.push(new TutorialFrame(new flash.geom.Rectangle(87, 220, 394, 680),
							lm.getString("common", "tutor.vip.list"), TutorialFrame.TOP, 10, new Point(0, 5)));

					var onShowTutorial:Function = function (event:Event):void
					{
						if (event)
							event.target.removeEventListener(FeathersEventType.CREATION_COMPLETE, onShowTutorial);
						sendNotification(Const.SHOW_TUTORIAL, tutorialData);
					};

					if (vipScreen.isCreated)
						onShowTutorial(null);
					else
						vipScreen.addEventListener(FeathersEventType.CREATION_COMPLETE, onShowTutorial);
				}
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

		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case Const.UPDATE_PACKS_LIST:
					dispatchEventWith("packsListChanged");
					break;
			}
		}

		private function onBack(event:Event):void
		{
			sendNotification(Const.POP);
		}

		private function onBuyPack(event:Event):void
		{
			var pack:Pack = event.data as Pack;
			if (pack && !Purchase.getInstance().waitingForAnswer)
			{
				sendNotification(Const.BUY_PACK, pack);
			}
		}

		[Bindable(event="packsListChanged")]
		/**
		 * Список доступных для покупки товаров.
		 */
		public function get packList():ListCollection
		{
			var packsProxy:PacksProxy = PacksProxy(facade.retrieveProxy(PacksProxy.NAME));
			var packList:ListCollection = new ListCollection();
			for (var i:int = 0, l:int = packsProxy.packs.length; i < l; i++)
			{
				var pack:Pack = packsProxy.packs[i];
				if (!pack.isConsumable && pack.isPurchased) continue;
				packList.addItem(pack);
			}
			return packList;
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
			dispatchEventWith("shopAvailableChanged");
		}

		[Bindable(event="shopAvailableChanged")]
		/**
		 * Флаг магазин доступен / недоступен
		 */
		public function get shopAvailable():Boolean
		{
			return Purchase.getInstance().isSupported;
		}
	}
}
