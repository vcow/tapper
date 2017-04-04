package resources.skin
{
	import feathers.controls.Label;
	import feathers.text.BitmapFontTextFormat;

	import flash.text.TextFormatAlign;

	import resources.FontLibrary;

	import starling.display.Quad;

	public class UnavailablePriceLabelStyleProvider extends LabelStyleProviderBase
	{
		override protected function onSkinLabel(label:Label):void
		{
			label.backgroundSkin = new Quad(20, 20, 0x8c2500);
			label.textRendererProperties = {
				wordWrap: true,
				textFormat: new BitmapFontTextFormat(FontLibrary.getInstance().titleButton31, NaN,
						0xffcece, TextFormatAlign.CENTER)
			};

			label.paddingLeft = 10;
			label.paddingRight = 10;
		}
	}
}
