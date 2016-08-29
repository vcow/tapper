package resources.skin
{
	import feathers.controls.Label;
	import feathers.text.BitmapFontTextFormat;

	import flash.text.TextFormatAlign;

	import resources.FontLibrary;

	import starling.display.Quad;

	public class PopupTitleStyleProvider extends LabelStyleProviderBase
	{
		override protected function onSkinLabel(label:Label):void
		{
			label.textRendererProperties = {
				wordWrap: true,
				textFormat: new BitmapFontTextFormat(FontLibrary.getInstance().arial30)
			};
		}
	}
}
