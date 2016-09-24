package resources.skin
{
	import feathers.controls.Button;

	import resources.AtlasLibrary;

	import starling.display.Image;

	import starling.textures.TextureAtlas;

	public class WoodenShopButtonStyleHighlightedProvider extends ButtonStyleProviderBase
	{
		override protected function onSkinButton(button:Button):void
		{
			var atlas:TextureAtlas = AtlasLibrary.getInstance().wooden;

			button.defaultSkin = new Image(atlas.getTexture("shop_bn_highlight_up"));
			button.downSkin = new Image(atlas.getTexture("shop_bn_highlight_down"));
		}
	}
}
