package mediators
{
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	import starling.events.EventDispatcher;

	/**
	 * Базовый класс для медиаторов, содержащих Bindable поля для непосредственного использования
	 * в mxml верстке.
	 */
	public class BindableMediator extends EventDispatcher implements IMediator
	{
		public static const NAME:String = 'Mediator';

		protected const MULTITON_MSG:String = "multitonKey for this Notifier not yet initialized!";

		protected var multitonKey:String;
		protected var mediatorName:String;
		protected var viewComponent:Object;

		public function BindableMediator(mediatorName:String = null, viewComponent:Object = null)
		{
			this.mediatorName = (mediatorName != null) ? mediatorName : NAME;
			this.viewComponent = viewComponent;
		}

		public function getMediatorName():String
		{
			return mediatorName;
		}

		public function setViewComponent(viewComponent:Object):void
		{
			this.viewComponent = viewComponent;
		}

		public function getViewComponent():Object
		{
			return viewComponent;
		}

		public function listNotificationInterests():Array
		{
			return [];
		}

		public function handleNotification(notification:INotification):void
		{
		}

		public function onRegister():void
		{
		}

		public function onRemove():void
		{
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
