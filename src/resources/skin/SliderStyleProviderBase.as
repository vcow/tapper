package resources.skin
{
	import feathers.controls.Slider;
	import feathers.core.IFeathersControl;
	import feathers.skins.FunctionStyleProvider;
	import feathers.skins.IStyleProvider;

	public class SliderStyleProviderBase implements IStyleProvider
	{
		protected var _styleProvider:IStyleProvider;

		public function SliderStyleProviderBase()
		{
			_styleProvider = new FunctionStyleProvider(onSkinSlider);
		}

		public function applyStyles(target:IFeathersControl):void
		{
			_styleProvider.applyStyles(target);
		}

		protected function onSkinSlider(slider:Slider):void
		{
			throw Error("Override this.");
		}
	}
}
