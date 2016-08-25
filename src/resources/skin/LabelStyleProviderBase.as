package resources.skin
{
	import feathers.controls.Label;
	import feathers.core.IFeathersControl;
	import feathers.skins.FunctionStyleProvider;
	import feathers.skins.IStyleProvider;

	public class LabelStyleProviderBase implements IStyleProvider
	{
		protected var _styleProvider:IStyleProvider;

		public function LabelStyleProviderBase()
		{
			_styleProvider = new FunctionStyleProvider(onSkinLabel);
		}

		public function applyStyles(target:IFeathersControl):void
		{
			_styleProvider.applyStyles(target);
		}

		protected function onSkinLabel(label:Label):void
		{
			throw Error("Override this.");
		}
	}
}
