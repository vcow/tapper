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
				shopScreen.addEventListener(ShopScreen.BACK, onBack);
				shopScreen.addEventListener(ShopScreen.BUY_UNIT, onBuyUnit);

				var gameModel:GameModel = AppFacade(facade).gameModel;

				_money = Math.round(gameModel.money);
				dispatchEventWith("moneyChanged");

				var unitsProxy:UnitsProxy = facade.retrieveProxy(UnitsProxy.NAME) as UnitsProxy;
				_unitsList = new ListCollection(unitsProxy.units);
				dispatchEventWith("unitsListChanged");
			}
		}

		override public function onRemove():void
		{
			var shopScreen:ShopScreen = getViewComponent() as ShopScreen;
			if (shopScreen)
			{
				shopScreen.removeEventListener(ShopScreen.BACK, onBack);
				shopScreen.removeEventListener(ShopScreen.BUY_UNIT, onBuyUnit);
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
			var unit:UnitInfo = event.data as UnitInfo;
			if (unit)
			{
				var gameModel:GameModel = AppFacade(facade).gameModel;
				if (unit.price <= gameModel.money)
				{
					sendNotification(Const.BUY, unit);
				}
			}
		}

		private function onBack(event:Event):void
		{
			sendNotification(Const.POP);
		}
	}
}
