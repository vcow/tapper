package resources.skin
{
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;

	import resources.AtlasLibrary;
	import resources.FontLibrary;

	import starling.display.Image;

	import starling.textures.TextureAtlas;

	public class TapButton1StyleProvider extends ButtonStyleProviderBase
	{
		override protected function onSkinButton(button:Button):void
		{
			var atlas:TextureAtlas = AtlasLibrary.getInstance().common;

			button.defaultSkin = new Image(atlas.getTexture("tap_bn1_normal"));
			button.hoverSkin = new Image(atlas.getTexture("tap_bn1_hover"));
			button.downSkin = new Image(atlas.getTexture("tap_bn1_down"));
			button.disabledSkin = new Image(atlas.getTexture("tap_bn1_disabled"));

			button.defaultLabelProperties = {
				textFormat: new BitmapFontTextFormat(FontLibrary.getInstance().arial16)
			};
			button.disabledLabelProperties = {
				textFormat: new BitmapFontTextFormat(FontLibrary.getInstance().arial16),
				alpha: 0.3
			};
		}
	}
}
