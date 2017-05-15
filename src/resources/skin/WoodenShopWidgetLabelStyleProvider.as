package resources.skin
{
	import feathers.controls.Label;
	import feathers.text.BitmapFontTextFormat;

	import flash.text.TextFormatAlign;

	import resources.FontLibrary;

	public class WoodenShopWidgetLabelStyleProvider extends LabelStyleProviderBase
	{
		override protected function onSkinLabel(label:Label):void
		{
			label.textRendererProperties = {
				wordWrap: true,
				textFormat: new BitmapFontTextFormat(FontLibrary.getInstance().russo, NaN,
					0xffffff, TextFormatAlign.CENTER)
			};
		}
	}
}
