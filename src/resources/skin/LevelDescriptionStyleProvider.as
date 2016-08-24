package resources.skin
{
	import feathers.controls.Label;
	import feathers.text.BitmapFontTextFormat;

	import flash.text.TextFormatAlign;

	public class LevelDescriptionStyleProvider extends LabelStyleProviderBase
	{
		override protected function onSkinLabel(label:Label):void
		{
			label.textRendererProperties = {
				wordWrap: true,
				textFormat: new BitmapFontTextFormat("title_button_31", NaN,
					0xffffff, TextFormatAlign.CENTER)
			};
		}
	}
}
