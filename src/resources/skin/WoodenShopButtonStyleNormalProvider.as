package resources.skin
{
	import feathers.controls.Button;

	import resources.AtlasLibrary;

	import starling.display.Image;

	import starling.textures.TextureAtlas;

	public class WoodenShopButtonStyleNormalProvider extends ButtonStyleProviderBase
	{
		override protected function onSkinButton(button:Button):void
		{
			var atlas:TextureAtlas = AtlasLibrary.getInstance().wooden;

			button.defaultSkin = new Image(atlas.getTexture("shop_bn_normal_up"));
			button.downSkin = new Image(atlas.getTexture("shop_bn_normal_down"));
		}
	}
}
