package mediators
{
	import events.UIEvent;

	import models.GameModel;

	import models.UnitInfo;

	import robotlegs.starling.bundles.mvcs.Mediator;

	import starling.events.Event;

	import view.ShopListItemRenderer;

	public class ShopListItemMediator extends Mediator
	{
		[Inject]
		public var view:ShopListItemRenderer;

		[Inject]
		public var gameModel:GameModel;

		public function ShopListItemMediator()
		{
			super();
		}

		override public function initialize():void
		{
			addViewListener("dataChange", onDataChange);
			addContextListener(UIEvent.UPDATE_MONEY, onUpdateMoney);
			onUpdateMoney();
		}

		private function onDataChange(event:Event):void
		{
			onUpdateMoney();
		}

		private function onUpdateMoney(Event:UIEvent = null):void
		{
			var data:UnitInfo = ShopListItemRenderer(view).data as UnitInfo;
			if (data) {
				ShopListItemRenderer(view).available = (data.price <= gameModel.money);
			}
		}
	}
}
