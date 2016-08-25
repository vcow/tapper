package resources.skin
{
	import feathers.controls.Button;

	import resources.AtlasLibrary;

	import starling.display.Image;

	import starling.textures.TextureAtlas;

	public class ShopButtonStyleProvider extends ButtonStyleProviderBase
	{
		override protected function onSkinButton(button:Button):void
		{
			var atlas:TextureAtlas = AtlasLibrary.getInstance().common;

			button.defaultSkin = new Image(atlas.getTexture("shop_normal"));
			button.hoverSkin = new Image(atlas.getTexture("shop_hover"));
			button.downSkin = new Image(atlas.getTexture("shop_down"));
			button.disabledSkin = new Image(atlas.getTexture("shop_disabled"));
		}
	}
}
