package resources.skin
{
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;

	import flash.geom.Rectangle;

	import resources.AtlasLibrary;
	import resources.FontLibrary;

	import starling.display.Image;
	import starling.textures.TextureAtlas;

	public class MessageBoxButtonStyleProvider extends ButtonStyleProviderBase
	{
		override protected function onSkinButton(button:Button):void
		{
			var atlas:TextureAtlas = AtlasLibrary.getInstance().manager.getTextureAtlas("messagebox");
			const rc:Rectangle = new flash.geom.Rectangle(20, 0, 104, 54);

			var image:Image = new Image(atlas.getTexture("button_normal"));
			image.scale9Grid = rc;
			button.defaultSkin = image;
			image = new Image(atlas.getTexture("button_normal_down"));
			image.scale9Grid = rc;
			button.downSkin = image;

			button.defaultLabelProperties = {
				textFormat: new BitmapFontTextFormat(FontLibrary.getInstance().messageBoxButton)
			};
		}
	}
}
