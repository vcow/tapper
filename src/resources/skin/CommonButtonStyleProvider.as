package resources.skin
{
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;

	import flash.geom.Rectangle;

	import resources.AtlasLibrary;
	import resources.FontLibrary;

	import starling.display.Image;
	import starling.textures.TextureAtlas;

	public class CommonButtonStyleProvider extends ButtonStyleProviderBase
	{
		override protected function onSkinButton(button:Button):void
		{
			var atlas:TextureAtlas = AtlasLibrary.getInstance().common;
			const rc:Rectangle = new flash.geom.Rectangle(10, 10, 40, 40);

			var img:Image = new Image(atlas.getTexture("common_bn_normal"));
			img.scale9Grid = rc;
			button.defaultSkin = img;
			img = new Image(atlas.getTexture("common_bn_hover"));
			img.scale9Grid = rc;
			button.hoverSkin = img;
			img = new Image(atlas.getTexture("common_bn_down"));
			img.scale9Grid = rc;
			button.downSkin = img;
			img = new Image(atlas.getTexture("common_bn_disabled"));
			img.scale9Grid = rc;
			button.disabledSkin = img;

			button.paddingLeft = 25;
			button.paddingRight = 25;
			button.defaultLabelProperties = {
				textFormat: new BitmapFontTextFormat(FontLibrary.getInstance().titleButton31)
			};
			button.disabledLabelProperties = {
				textFormat: new BitmapFontTextFormat(FontLibrary.getInstance().titleButton31),
				alpha: 0.3
			};
		}
	}
}
