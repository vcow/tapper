package mediators
{
	import events.UnitEvent;

	import models.Unit;

	import robotlegs.starling.bundles.mvcs.Mediator;

	import starling.events.Event;

	import view.UnitListItemRenderer;

	public class UnitListItemMediator extends Mediator
	{
		private var _viewIsApplied:Boolean;

		[Inject]
		public var view:UnitListItemRenderer;

		public function UnitListItemMediator()
		{
			super();
		}

		override public function initialize():void
		{
			if (UnitListItemRenderer(view).data as Unit) applyView();
			else  addViewListener("dataChange", applyView);
		}

		private function applyView(event:Event = null):void
		{
			if (_viewIsApplied) return;

			var unit:Unit = UnitListItemRenderer(view).data as Unit;
			if (unit) {
				_viewIsApplied = true;
				if (event) removeViewListener("dataChange", applyView);
				if (unit.info.perClickProfit && unit.info.perClickProfit.maxCount ||
						unit.info.perSecondProfit && unit.info.perSecondProfit.maxCount) {
					addViewListener("dataChange", onDataChange);
					addContextListener(UnitEvent.COUNT_CHANGED, onCountChanged);
					onCountChanged();
				}
			}
		}

		override public function postDestroy():void
		{
		}

		private function onDataChange(event:Event):void
		{
			onCountChanged();
		}

		private function onCountChanged(event:UnitEvent = null):void
		{
			var unit:Unit = UnitListItemRenderer(view).data as Unit;
			if (unit) {
				if (event) {
					if (event.unit !== unit) return;
					var count:int = event.count;
				}
				else {
					if (unit.info.perClickProfit && unit.info.perClickProfit.maxCount) {
						count = unit.info.perClickProfit.maxCount - unit.taps;
					}
					else if (unit.info.perSecondProfit && unit.info.perSecondProfit.maxCount) {
						count = unit.info.perSecondProfit.maxCount - unit.ticks;
					}
					else {
						throw Error("There is no counters in this unit.");
					}
				}

				UnitListItemRenderer(view).counter = count.toString();

				if (count <= 0 && _viewIsApplied) {
					removeViewListener("dataChange", onDataChange);
					removeContextListener(UnitEvent.COUNT_CHANGED, onCountChanged);
				}
			}
		}
	}
}
