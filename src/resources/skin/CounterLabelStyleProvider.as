package resources.skin
{
	import feathers.controls.Label;
	import feathers.text.BitmapFontTextFormat;

	import resources.FontLibrary;

	public class CounterLabelStyleProvider extends LabelStyleProviderBase
	{
		override protected function onSkinLabel(label:Label):void
		{
			label.textRendererProperties = {
				wordWrap: true,
				textFormat: new BitmapFontTextFormat(FontLibrary.getInstance().arial26, NaN, 0x000000)
			};
		}
	}
}
