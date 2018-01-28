package resources.skin
{
	import feathers.controls.Button;

	import resources.AtlasLibrary;

	import starling.display.Image;

	import starling.textures.TextureAtlas;

	public class WoodenShopButtonStyleHighlightedProvider extends ButtonStyleProviderBase
	{

		private static var _atlas:TextureAtlas;
		private static function get atlas():TextureAtlas
		{
			if (!_atlas)
			{
				_atlas = AtlasLibrary.getInstance().manager.getTextureAtlas("wooden");
			}
			return _atlas;
		}
		override protected function onSkinButton(button:Button):void
		{
			button.defaultSkin = new Image(atlas.getTexture("wooden_shop_bn_highlight_up"));
			button.downSkin = new Image(atlas.getTexture("wooden_shop_bn_highlight_down"));
		}
	}
}
