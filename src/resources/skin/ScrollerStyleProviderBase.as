package resources.skin
{
	import feathers.controls.Scroller;
	import feathers.core.IFeathersControl;
	import feathers.skins.FunctionStyleProvider;
	import feathers.skins.IStyleProvider;

	public class ScrollerStyleProviderBase implements IStyleProvider
	{
		protected var _styleProvider:IStyleProvider;

		public function ScrollerStyleProviderBase()
		{
			_styleProvider = new FunctionStyleProvider(onSkinScroller);
		}

		public function applyStyles(target:IFeathersControl):void
		{
			_styleProvider.applyStyles(target);
		}

		protected function onSkinScroller(scroller:Scroller):void
		{
			throw Error("Override this.");
		}
	}
}
