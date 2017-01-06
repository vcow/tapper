package vo
{
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.interfaces.INotifier;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	import starling.events.EventDispatcher;

	public class BindableNotifier extends EventDispatcher implements INotifier
	{
		protected var multitonKey:String;
		protected const MULTITON_MSG:String = "multitonKey for this Notifier not yet initialized!";

		public function BindableNotifier()
		{
			super();
		}

		public function sendNotification(notificationName:String, body:Object = null, type:String = null):void
		{
			if (facade != null)
				facade.sendNotification(notificationName, body, type);
		}

		public function initializeNotifier(key:String):void
		{
			multitonKey = key;
		}

		protected function get facade():IFacade
		{
			if (multitonKey == null) throw Error(MULTITON_MSG);
			return Facade.getInstance(multitonKey);
		}
	}
}
