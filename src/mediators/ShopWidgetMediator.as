package mediators
{
	import app.AppFacade;

	import flash.utils.Dictionary;

	import models.GameModel;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import proxy.UnitsProxy;

	import starling.events.Event;

	import view.ShopWidgetBase;

	import vo.UnitInfo;

	/**
	 * Медиатор виджета Магазина для Кабинета (кнопка и сообщения о доступных юнитах).
	 */
	public class ShopWidgetMediator extends BindableMediator
	{
		private static var _interests:Array = [Const.UPDATE_MONEY];

		private var _availableUnits:Dictionary;
		private var _lastMoney:Number = 0;

		private var _data:UnitInfo;

		public function ShopWidgetMediator(mediatorName:String, viewComponent:Object)
		{
			super(mediatorName, viewComponent);
		}

		[Bindable(event="dataChanged")]
		public function get data():UnitInfo
		{
			return _data;
		}

		override public function listNotificationInterests():Array
		{
			return _interests;
		}

		override public function onRegister():void
		{
			var shopWidget:ShopWidgetBase = getViewComponent() as ShopWidgetBase;
			shopWidget.addEventListener("goToShop", onGoToShop);
			_lastMoney = Math.round(AppFacade(facade).gameModel.money);
		}

		override public function onRemove():void
		{
			var shopWidget:ShopWidgetBase = getViewComponent() as ShopWidgetBase;
			shopWidget.removeEventListener("goToShop", onGoToShop);
		}

		override public function setViewComponent(viewComponent:Object):void
		{
			if (viewComponent == viewComponent) return;

			if (viewComponent)
			{
				viewComponent.removeEventListener("goToShop", onGoToShop);
			}

			super.setViewComponent(viewComponent);
			if (viewComponent)
			{
				viewComponent.addEventListener("goToShop", onGoToShop);
			}
		}

		override public function handleNotification(notification:INotification):void
		{
			var shopWidget:ShopWidgetBase = getViewComponent() as ShopWidgetBase;
			var gameModel:GameModel = AppFacade(facade).gameModel;
			switch (notification.getName())
			{
				case Const.UPDATE_MONEY:
					updateMoney(shopWidget, gameModel);
					break;
			}
		}

		private function updateMoney(view:ShopWidgetBase, gameModel:GameModel):void
		{
			if (_lastMoney > gameModel.money) _availableUnits = null;
			_lastMoney = gameModel.money;

			var availableUnits:Dictionary = new Dictionary(true);
			var newAvailable:Array = [];

			var unitsProxy:UnitsProxy = facade.retrieveProxy(UnitsProxy.NAME) as UnitsProxy;
			for (var i:int = 0, l:int = unitsProxy.units.length; i < l; i++)
			{
				var unit:UnitInfo = unitsProxy.units[i];
				if (unit.price == 0) continue;

				if (unit.price <= _lastMoney)
				{
					availableUnits[unit] = true;
					if (!_availableUnits || !_availableUnits[unit]) newAvailable.push(unit);
				}
			}
			_availableUnits = availableUnits;

			if (newAvailable.length > 0)
			{
				newAvailable.sortOn("price", Array.NUMERIC);
				var newData:UnitInfo = newAvailable[newAvailable.length - 1];
				if (newData != _data)
				{
					_data = newData;
					dispatchEventWith("dataChanged");
				}
			}
		}

		private function onGoToShop(event:Event):void
		{
			sendNotification(Const.SWITCH_TO, Const.STATE_SHOP);
		}
	}
}
