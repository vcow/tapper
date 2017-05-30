package mediators
{
	import app.AppFacade;

	import feathers.data.ListCollection;

	import models.GameModel;
	import vo.UnitInfo;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import proxy.UnitsProxy;

	import starling.events.Event;

	import view.ShopScreen;

	public class ShopScreenMediator extends BindableMediator
	{
		private static var _interests:Array = [Const.UPDATE_MONEY];

		private var _money:Number = 0;
		private var _unitsList:ListCollection;

		public function ShopScreenMediator(mediatorName:String, viewComponent:Object)
		{
			super(mediatorName, viewComponent);
		}

		override public function listNotificationInterests():Array
		{
			return _interests;
		}

		override public function onRegister():void
		{
			var shopScreen:ShopScreen = getViewComponent() as ShopScreen;
			if (shopScreen)
			{
				shopScreen.addEventListener("back", onBack);
				shopScreen.addEventListener("buyUnit", onBuyUnit);

				var gameModel:GameModel = AppFacade(facade).gameModel;

				_money = Math.round(gameModel.money);
				dispatchEventWith("moneyChanged");

				var unitsProxy:UnitsProxy = facade.retrieveProxy(UnitsProxy.NAME) as UnitsProxy;
				var unitsList:Vector.<UnitInfo> = new Vector.<UnitInfo>();
				for (var i:int = 0, l:int = unitsProxy.units.length; i < l; i++)
				{
					var unitInfo:UnitInfo = unitsProxy.units[i];
					if (unitInfo.price == 0) continue;
					unitsList.push(unitInfo);
				}
				_unitsList = new ListCollection(unitsList);
				dispatchEventWith("unitsListChanged");
			}
		}

		override public function onRemove():void
		{
			var shopScreen:ShopScreen = getViewComponent() as ShopScreen;
			if (shopScreen)
			{
				shopScreen.removeEventListener("back", onBack);
				shopScreen.removeEventListener("buyUnit", onBuyUnit);
			}
		}

		override public function setViewComponent(viewComponent:Object):void
		{
			if (viewComponent == viewComponent) return;

			if (viewComponent)
			{
				viewComponent.removeEventListener("back", onBack);
				viewComponent.removeEventListener("buyUnit", onBuyUnit);
			}

			super.setViewComponent(viewComponent);
			if (viewComponent)
			{
				viewComponent.addEventListener("back", onBack);
				viewComponent.addEventListener("buyUnit", onBuyUnit);
			}
		}

		override public function handleNotification(notification:INotification):void
		{
			var shopScreen:ShopScreen = getViewComponent() as ShopScreen;
			var gameModel:GameModel = AppFacade(facade).gameModel;
			switch (notification.getName())
			{
				case Const.UPDATE_MONEY:
					_money = Math.round(gameModel.money);
					dispatchEventWith("moneyChanged");
					break;
			}
		}

		[Bindable(event="moneyChanged")]
		public function get money():Number
		{
			return _money;
		}

		[Bindable(event="unitsListChanged")]
		public function get unitsList():ListCollection
		{
			return _unitsList;
		}

		private function onBuyUnit(event:Event):void
		{
			var unitInfo:UnitInfo = event.data as UnitInfo;
			if (unitInfo)
			{
				var gameModel:GameModel = AppFacade(facade).gameModel;
				if (unitInfo.price <= gameModel.money)
				{
					sendNotification(Const.BUY, unitInfo);
				}
			}
		}

		private function onBack(event:Event):void
		{
			sendNotification(Const.POP);
		}
	}
}
