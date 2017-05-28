package {
	import feathers.core.FeathersControl;
	import feathers.core.PopUpManager;

	import flash.utils.Dictionary;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class WindowManager
	{
		private var _windows:Dictionary = new Dictionary(true);

		private static var _instance:WindowManager;

		public function WindowManager()
		{
			if (_instance) throw Error("WindowManager is a singleton, use getInstance.");
			PopUpManager.overlayFactory = overlayFactory;
			_instance = this;
		}

		public static function getInstance():WindowManager
		{
			if (!_instance) _instance = new WindowManager();
			return _instance;
		}

		public function openWindow(popup:DisplayObject, animateEffect:Boolean,
								   isModal:Boolean = true, dispose:Boolean = true):DisplayObject
		{
			var window:FeathersControl = popup as FeathersControl;
			if (!window) return null;

			window.addEventListener(Event.CLOSE, onWindowCloseHandler);
			_windows[window] = [animateEffect, dispose];

			PopUpManager.addPopUp(window, isModal, !animateEffect);

			if (animateEffect)
			{
				window.validate();
				window.touchable = false;
				window.x = Math.floor((Starling.current.stage.stageWidth - window.width) / 2.0);
				window.y = -window.height;
				var tween:Tween = new Tween(window, 0.4, Transitions.EASE_OUT);
				tween.animate("y", Math.floor((Starling.current.stage.stageHeight - window.height) / 2.0));
				tween.onCompleteArgs = [window];
				tween.onComplete = function (self:FeathersControl):void
				{
					self.touchable = true;
					PopUpManager.centerPopUp(self);
				};
				Starling.juggler.add(tween);
			}

			return window;
		}

		private function onWindowCloseHandler(event:Event):void
		{
			var window:FeathersControl = FeathersControl(event.currentTarget);
			window.removeEventListener(Event.CLOSE, onWindowCloseHandler);

			var animatedEffect:Boolean;
			var dispose:Boolean = true;
			if (_windows[window] != null)
			{
				animatedEffect = _windows[window][0];
				dispose = _windows[window][1];
				delete _windows[window];
			}

			if (window.parent == PopUpManager.root)
			{
				if (animatedEffect)
				{
					event.stopImmediatePropagation();

					Starling.juggler.removeTweens(window);
					var tween:Tween = new Tween(window, 0.4, Transitions.EASE_IN);
					tween.animate("y", Math.floor(Starling.current.stage.stageHeight + window.height));
					tween.onCompleteArgs = [window, event.data, dispose];
					tween.onComplete = function (self:FeathersControl, result:Object, dispose:Boolean):void
					{
						self.touchable = true;
						self.dispatchEventWith(Event.CLOSE, false, result);
						PopUpManager.removePopUp(self, dispose);
					};
					window.touchable = false;
					Starling.juggler.add(tween);

					var index:int = window.parent.getChildIndex(window);
					var overlay:WindowManagerOverlay = index > 0 ? window.parent.getChildAt(index - 1) as WindowManagerOverlay : null;
					if (overlay)
					{
						Starling.juggler.removeTweens(overlay);
						tween = new Tween(overlay, 0.3);
						tween.fadeTo(0);
						Starling.juggler.add(tween);
					}
				}
				else
				{
					PopUpManager.removePopUp(window, dispose);
				}
			}
		}

		private static function overlayFactory():DisplayObject
		{
			return new WindowManagerOverlay();
		}
	}
}


import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Quad;
import starling.events.Event;

class WindowManagerOverlay extends Quad
{
	public function WindowManagerOverlay()
	{
		super(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, 0x000000);

		alpha = 0;
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	private function onAddedToStage(event:Event):void
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		var tween:Tween = new Tween(this, 0.3);
		tween.fadeTo(0.5);
		Starling.juggler.add(tween);
	}
}