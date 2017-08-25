package net
{
	import com.freshplanet.ane.AirInAppPurchase.InAppPurchase;

	import starling.events.EventDispatcher;

	public class Purchase extends EventDispatcher
	{
		private static var _instance:Purchase;

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
		}

		public function get isSupported():Boolean
		{
			return InAppPurchase.isSupported;
		}
	}
}
