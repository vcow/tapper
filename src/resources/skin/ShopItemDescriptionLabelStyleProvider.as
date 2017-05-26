package resources.skin
{
	import feathers.controls.Label;
	import feathers.text.BitmapFontTextFormat;

	public class ShopItemDescriptionLabelStyleProvider extends LabelStyleProviderBase
	{
		override protected function onSkinLabel(label:Label):void
		{
			label.textRendererProperties = {
				textFormat: new BitmapFontTextFormat("shop_message")
			};
		}
	}
}
