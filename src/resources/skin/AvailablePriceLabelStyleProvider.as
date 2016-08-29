package resources.skin
{
	import feathers.controls.Label;
	import feathers.text.BitmapFontTextFormat;

	import flash.text.TextFormatAlign;

	import resources.FontLibrary;

	import starling.display.Quad;

	public class AvailablePriceLabelStyleProvider extends LabelStyleProviderBase
	{
		override protected function onSkinLabel(label:Label):void
		{
			label.backgroundSkin = new Quad(20, 20, 0x3f6b33);
			label.textRendererProperties = {
				wordWrap: true,
				textFormat: new BitmapFontTextFormat(FontLibrary.getInstance().arial26, NaN,
						0xffffff, TextFormatAlign.CENTER)
			};

			label.paddingLeft = 10;
			label.paddingRight = 10;
		}
	}
}
