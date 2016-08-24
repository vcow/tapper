package resources.skin
{
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;

	import flash.geom.Rectangle;

	import resources.AtlasLibrary;

	import starling.display.Image;
	import starling.textures.TextureAtlas;

	public class BuyPackButtonStyleProvider extends ButtonStyleProviderBase
	{
		override protected function onSkinButton(button:Button):void
		{
			var atlas:TextureAtlas = AtlasLibrary.getInstance().manager.getTextureAtlas("common_1");
			const rc:Rectangle = new flash.geom.Rectangle(34, 0, 173, 60);

			var image:Image = new Image(atlas.getTexture("vip_details_buy_bn_normal"));
			image.scale9Grid = rc;
			button.defaultSkin = image;
			image = new Image(atlas.getTexture("vip_details_buy_bn_down"));
			image.scale9Grid = rc;
			button.downSkin = image;
			button.paddingLeft = button.paddingRight = 24;
			button.paddingTop = 2;
			button.maxHeight = 60;

			var textFormat:BitmapFontTextFormat = new BitmapFontTextFormat("currency", 28, 0x544317);
			textFormat.letterSpacing = -0.5;
			button.defaultLabelProperties = {
				textFormat: textFormat
			};
		}
	}
}
