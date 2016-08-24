package resources.skin
{
	import feathers.controls.Label;
	import feathers.text.BitmapFontTextFormat;

	import flash.text.TextFormatAlign;

	import starling.display.Quad;

	public class MoneyLabelStyleProvider extends LabelStyleProviderBase
	{
		override protected function onSkinLabel(label:Label):void
		{
			label.backgroundSkin = new Quad(20, 20, 0x000000);
			label.textRendererProperties = {
				wordWrap: true,
				textFormat: new BitmapFontTextFormat("title_button_31", 26,
						0xffffff, TextFormatAlign.CENTER)
			};

			label.paddingLeft = 15;
			label.paddingRight = 15;
		}
	}
}
