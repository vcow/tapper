package resources.skin
{
	import feathers.controls.Button;
	import feathers.core.IFeathersControl;
	import feathers.skins.FunctionStyleProvider;
	import feathers.skins.IStyleProvider;

	public class ButtonStyleProviderBase implements IStyleProvider
	{
		protected var _styleProvider:IStyleProvider;

		public function ButtonStyleProviderBase()
		{
			_styleProvider = new FunctionStyleProvider(onSkinButton);
		}

		public function applyStyles(target:IFeathersControl):void
		{
			_styleProvider.applyStyles(target);
		}

		protected function onSkinButton(button:Button):void
		{
			throw Error("Override this.");
		}
	}
}
