package resources.skin
{
	import feathers.controls.Button;

	import resources.AtlasLibrary;

	import starling.display.Image;

	import starling.textures.TextureAtlas;

	public class SettingsButtonStyleProvider extends ButtonStyleProviderBase
	{
		override protected function onSkinButton(button:Button):void
		{
			var atlas:TextureAtlas = AtlasLibrary.getInstance().title;
			button.defaultSkin = new Image(atlas.getTexture("settings_normal"));
			button.downSkin = new Image(atlas.getTexture("settings_down"));
		}
	}
}
