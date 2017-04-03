package resources.skin
{
	import feathers.controls.Label;
	import feathers.text.BitmapFontTextFormat;

	import resources.FontLibrary;

	public class ShopItemTitleLabelStyleProvider extends LabelStyleProviderBase
	{
		override protected function onSkinLabel(label:Label):void
		{
			label.textRendererProperties = {
				textFormat: new BitmapFontTextFormat(FontLibrary.getInstance().titleButton31)
			};
		}
	}
}
