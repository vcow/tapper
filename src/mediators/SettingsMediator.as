package mediators
{
	import feathers.data.ListCollection;

	import view.SettingsPopup;

	public class SettingsMediator extends BindableMediator
	{
		private var _packList:ListCollection;

		public function SettingsMediator(mediatorName:String = null, viewComponent:Object = null)
		{
			super(mediatorName, viewComponent);
		}

		override public function onRegister():void
		{
			var settingsPopup:SettingsPopup = getViewComponent() as SettingsPopup;
			if (settingsPopup)
			{
//				settingsPopup.addEventListener("back", onBack);
//				settingsPopup.addEventListener("buyPack", onBuyPack);
			}
		}

		override public function onRemove():void
		{
			var settingsPopup:SettingsPopup = getViewComponent() as SettingsPopup;
			if (settingsPopup)
			{
//				settingsPopup.removeEventListener("back", onBack);
//				settingsPopup.removeEventListener("buyPack", onBuyPack);
			}
		}

		override public function setViewComponent(viewComponent:Object):void
		{
			if (viewComponent == viewComponent) return;

			if (viewComponent)
			{

			}

			super.setViewComponent(viewComponent);
			if (viewComponent)
			{

			}
		}
	}
}
