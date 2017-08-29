package net
{
	import air.net.URLMonitor;

	import com.pozirk.payment.android.InAppPurchase;
	import com.pozirk.payment.android.InAppPurchaseEvent;

	import flash.events.StatusEvent;

	import flash.net.URLRequest;

	import starling.events.EventDispatcher;

	[Event(name="status", type="starling.events.Event")]

	public class Purchase extends EventDispatcher
	{
		private static var _instance:Purchase;

		private var _monitor:URLMonitor;
		private var _connected:Boolean;

		private var _iap:InAppPurchase;
		private var _isSupported:Boolean;

		public static function getInstance():Purchase
		{
			if (!_instance)
			{
				_instance = new Purchase();
			}
			return _instance
		}

		public function Purchase()
		{
			super();
			if (_instance) throw Error("InAppPurchase is a singleton, use getInstance.");
			_iap = new InAppPurchase();

			_monitor = new URLMonitor(new URLRequest("https://www.google.com/"));
			_monitor.addEventListener(StatusEvent.STATUS, onStatusChanged);
		}

		public function startMonitor():void
		{
			_monitor.start();
		}

		public function stopMonitor():void
		{
			_monitor.stop();
			if (_connected)
			{
				_connected = false;
				dispatchEventWith("status", false, "unsupported");
			}
		}

		private function onStatusChanged(event:StatusEvent):void
		{
			var connected:Boolean = event.code == "Service.available";
			if (connected != _connected)
			{
				_connected = connected;
				if (_isSupported)
				{
					dispatchEventWith("status", false, _connected ? "supported" : "unsupported");
				}
				else if (_connected)
				{
					_iap.addEventListener(InAppPurchaseEvent.INIT_SUCCESS, onInit);
					_iap.addEventListener(InAppPurchaseEvent.INIT_ERROR, onInit);
					_iap.init("MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAggSBUGA7iHO361Ewv3Bzlb6sMd7W59LIcJOco7J+Ps013AtMEZJZtmf/jl5KbGsAgHQMWNxN9d07p8V7grjGID50KRd4ara8/c/AV8MIWZkIam/3QNwuTEecv8xrmjDu/mOp7Ljz9165QazG2rd4bWwV2zKhGLjabGw8CHBIouP/gY+bYR0QaalhUH4D1F2FkON3bwoipxsRr8346uhcIBtSa1XyO0q1Bvn44wcP2XchexaIszslHsuhWt9NJYD9DLFZJJwx6zJcFwxKkyBPDvzstUmoUMNXQgoFpMQ9wmvZ95LL5MlTh6P9haPE+uhHacE3/7P6T7WkJEY4CAv0+QIDAQAB",
							"com.android.vending.billing.InAppBillingService.BIND", "com.android.vending");
				}
			}
		}

		private function onInit(event:InAppPurchaseEvent):void
		{
			_iap.removeEventListener(InAppPurchaseEvent.INIT_SUCCESS, onInit);
			_iap.removeEventListener(InAppPurchaseEvent.INIT_ERROR, onInit);

			var isSupported:Boolean = event.type == InAppPurchaseEvent.INIT_SUCCESS;
			if (isSupported != _isSupported)
			{
				_isSupported = isSupported;
				if (_connected)
					dispatchEventWith("status", false, _isSupported ? "supported" : "unsupported");
			}
		}

		public function get isSupported():Boolean
		{
			return _connected && _isSupported;
		}
	}
}
