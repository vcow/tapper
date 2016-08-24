package net
{
	import air.net.URLMonitor;

	import app.AppFacade;

	import com.pozirk.payment.android.InAppPurchase;
	import com.pozirk.payment.android.InAppPurchaseDetails;
	import com.pozirk.payment.android.InAppPurchaseEvent;
	import com.pozirk.payment.android.InAppSkuDetails;

	import flash.events.StatusEvent;

	import flash.net.URLRequest;
	import flash.system.Capabilities;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	import proxy.PacksProxy;

	import starling.events.EventDispatcher;

	import vo.Pack;

	[Event(name="status", type="starling.events.Event")]
	[Event(name="purchaseComplete", type="starling.events.Event")]
	[Event(name="purchaseFailed", type="starling.events.Event")]
	[Event(name="consumeComplete", type="starling.events.Event")]
	[Event(name="consumeFailed", type="starling.events.Event")]
	[Event(name="restoreComplete", type="starling.events.Event")]
	[Event(name="restoreFailed", type="starling.events.Event")]

	/**
	 * Соединение с магазином Google Play.
	 */
	public class Purchase extends EventDispatcher
	{
		private static var _instance:Purchase;

		private var _monitor:URLMonitor;
		private var _isMonitoring:Boolean;
		private var _connected:Boolean;

		private var _iap:InAppPurchase;
		private var _isSupported:Boolean;

		private var _purchasedPack:Pack;
		private var _consumedPack:Pack;

		private var _packsProxy:PacksProxy;

		private var _os:int = -1;

		private var _consumeAfterPurchaseFail:Boolean;

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

			if (isAndroid)
			{
				_iap = new InAppPurchase();

				_monitor = new URLMonitor(new URLRequest("https://www.google.com/"));
				_monitor.addEventListener(StatusEvent.STATUS, onStatusChanged);
			}
		}

		/**
		 * Старт мониторинга соединения с магазином.
		 */
		public function startMonitor():void
		{
			if (_isMonitoring) return;

			if (_monitor)
				_monitor.start();
		}

		/**
		 * Остановка мониторинга соединения с магазином.
		 */
		public function stopMonitor():void
		{
			if (!_isMonitoring || waitingForAnswer) return;

			if (_monitor)
				_monitor.stop();

			if (_connected)
			{
				_connected = false;
				dispatchEventWith("status", false, "unsupported");
			}
		}

		/**
		 * Платежная система ожидает ответ от сервера.
		 */
		public function get waitingForAnswer():Boolean
		{
			return _purchasedPack || _consumedPack;
		}

		private function get os():int
		{
			if (_os < 0)
			{
				_os = Capabilities.manufacturer.indexOf("Android") > -1 ? 1 :
						(Capabilities.manufacturer.indexOf("iOS") > -1 ? 2 : 0);
			}
			return _os;
		}

		/**
		 * Флаг указывает, что приложение запущено под Android.
		 */
		protected function get isAndroid():Boolean
		{
			return os == 1;
		}

		/**
		 * Флаг указывает, что приложение запущено под IOS.
		 */
		protected function get isIOS():Boolean
		{
			return os == 2;
		}

		/**
		 * Флаг указывает, что приложение запущено на одной из поддерживаемых мобильных платформ.
		 */
		protected function get isMobile():Boolean
		{
			return os != 0;
		}

		protected function get packsProxy():PacksProxy
		{
			if (!_packsProxy)
			{
				var facade:AppFacade = Facade.getInstance(AppFacade.NAME) as AppFacade;
				_packsProxy = PacksProxy(facade.retrieveProxy(PacksProxy.NAME));
			}
			return _packsProxy;
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

				restore(packsProxy.packs);
			}
		}

		/**
		 * Флаг указывает, что платежи в настоящее время поддерживаются / не поддерживаются.
		 */
		public function get isSupported():Boolean
		{
			return _connected && _isSupported || !isMobile;
		}

		/**
		 * Восстановить покупки.
		 * @param packs Список восстанавливаемых покупок.
		 */
		public function restore(packs:Vector.<Pack>):void
		{
			if (!isSupported) return;

			if (_connected && _isSupported)
			{
				var packsId:Array = [];
				for each (var p:Pack in packs)
					packsId.push(p.id);

				_iap.addEventListener(InAppPurchaseEvent.RESTORE_SUCCESS, onRestore);
				_iap.addEventListener(InAppPurchaseEvent.RESTORE_ERROR, onRestore);
				_iap.restore(packsId);
			}
			else
			{
				dispatchEventWith("restoreComplete");
			}
		}

		private function onRestore(event:InAppPurchaseEvent):void
		{
			_iap.removeEventListener(InAppPurchaseEvent.RESTORE_SUCCESS, onRestore);
			_iap.removeEventListener(InAppPurchaseEvent.RESTORE_ERROR, onRestore);

			if (event.type == InAppPurchaseEvent.RESTORE_SUCCESS)
			{
				var facade:AppFacade = Facade.getInstance(AppFacade.NAME) as AppFacade;
				for each (var p:Pack in packsProxy.packs)
				{
					var skuDetails:InAppSkuDetails = _iap.getSkuDetails(p.id);
					var purchaseDetails:InAppPurchaseDetails = _iap.getPurchaseDetails(p.id);

					if (skuDetails)
					{
						p.price = skuDetails._price;
						p.title = skuDetails._title;
						p.description = skuDetails._descr;
					}

					if (purchaseDetails)
					{
						facade.sendNotification(Const.RESTORE_PACK, p);
					}
				}

				dispatchEventWith("restoreComplete");
			}
			else
			{
				dispatchEventWith("restoreFailed");
			}
		}

		/**
		 * Купить пак с указанным идентификатором.
		 * @param pack покупаемый пак.
		 */
		public function purchase(pack:Pack):void
		{
			if (!isSupported || _purchasedPack) return;

			_purchasedPack = pack;

			if (_connected && _isSupported)
			{
				_iap.addEventListener(InAppPurchaseEvent.PURCHASE_SUCCESS, onPurchaseComplete);
				_iap.addEventListener(InAppPurchaseEvent.PURCHASE_ALREADY_OWNED, onPurchaseComplete);
				_iap.addEventListener(InAppPurchaseEvent.PURCHASE_ERROR, onPurchaseComplete);

				_iap.purchase(pack.id, InAppPurchaseDetails.TYPE_INAPP);
			}
			else
			{
				_purchasedPack.isPurchased = true;
				dispatchEventWith("purchaseComplete");
				_purchasedPack = null;
			}
		}

		private function onPurchaseComplete(event:InAppPurchaseEvent):void
		{
			_iap.removeEventListener(InAppPurchaseEvent.PURCHASE_SUCCESS, onPurchaseComplete);
			_iap.removeEventListener(InAppPurchaseEvent.PURCHASE_ALREADY_OWNED, onPurchaseComplete);
			_iap.removeEventListener(InAppPurchaseEvent.PURCHASE_ERROR, onPurchaseComplete);

			if (event.type == InAppPurchaseEvent.PURCHASE_SUCCESS)
			{
				_purchasedPack.isPurchased = true;
				dispatchEventWith("purchaseComplete");
			}
			else
			{
				if (event.type == InAppPurchaseEvent.PURCHASE_ALREADY_OWNED)
				{
					if (_purchasedPack.isConsumable)
					{
						consume(_purchasedPack);
						return;
					}
					else
					{
						var facade:AppFacade = Facade.getInstance(AppFacade.NAME) as AppFacade;
						facade.sendNotification(Const.RESTORE_PACK, _purchasedPack);
					}
				}
				else
				{
					// В любой непонятной ситуации пробуем законсюмить товар.
					if (_purchasedPack.isConsumable)
					{
						_consumeAfterPurchaseFail = true;
						consume(_purchasedPack);
						_purchasedPack = null;
						return;
					}
				}
				dispatchEventWith("purchaseFailed");
			}

			_purchasedPack = null;
		}

		/**
		 * Использовать купленный ранее пак.
		 * @param pack Используемый пак.
		 */
		public function consume(pack:Pack):void
		{
			if (!isSupported || _consumedPack) return;

			_consumedPack = pack;

			if (_connected && _isSupported)
			{
				_iap.addEventListener(InAppPurchaseEvent.CONSUME_SUCCESS, onConsumeComplete);
				_iap.addEventListener(InAppPurchaseEvent.CONSUME_ERROR, onConsumeComplete);

				_iap.consume(pack.id);
			}
			else
			{
				_consumedPack.isPurchased = false;
				dispatchEventWith("consumeComplete");
				_consumedPack = null;
			}
		}

		private function onConsumeComplete(event:InAppPurchaseEvent):void
		{
			_iap.addEventListener(InAppPurchaseEvent.CONSUME_SUCCESS, onConsumeComplete);
			_iap.addEventListener(InAppPurchaseEvent.CONSUME_ERROR, onConsumeComplete);

			_consumedPack.isPurchased &&= event.type != InAppPurchaseEvent.CONSUME_SUCCESS;
			_consumedPack = null;

			if (event.type == InAppPurchaseEvent.CONSUME_SUCCESS)
			{
				if (_purchasedPack)
				{
					var pack:Pack = _purchasedPack;
					_purchasedPack = null;
					purchase(pack);
				}

				dispatchEventWith(_consumeAfterPurchaseFail ? "purchaseFailed" : "consumeComplete");
			}
			else
			{
				dispatchEventWith(_consumeAfterPurchaseFail ? "purchaseFailed" : "consumeFailed");
			}
			_consumeAfterPurchaseFail = false;
		}
	}
}
