package resources.skin
{
	import feathers.controls.Button;
	import feathers.controls.ButtonState;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;

	import resources.AtlasLibrary;

	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.TextureAtlas;

	public class SettingsButtonStyleProvider extends ButtonStyleProviderBase
	{
		override protected function onSkinButton(button:Button):void
		{
			var atlas:TextureAtlas = AtlasLibrary.getInstance().manager.getTextureAtlas("common_1");

			button.defaultSkin = new Image(atlas.getTexture("settings_close_bn_normal"));
			button.downSkin = new Image(atlas.getTexture("settings_close_bn_down"));
			button.defaultLabelProperties = {
				textFormat: new BitmapFontTextFormat("wooden_title", 38, 0x544317)
			};

			button.addEventListener(FeathersEventType.STATE_CHANGE, stateChangeHandler);
		}

		protected static function stateChangeHandler(event:Event):void
		{
			var button:Button = Button(event.target);

			switch (button.currentState)
			{
				case ButtonState.DISABLED:
					button.useHandCursor = false;
					button.labelOffsetX = 0;
					button.labelOffsetY = 0;
					button.iconOffsetX = 0;
					button.iconOffsetY = 0;
					break;
				case ButtonState.DOWN:
					button.useHandCursor = true;
					button.labelOffsetX = 1;
					button.labelOffsetY = 1;
					button.iconOffsetX = 1;
					button.iconOffsetY = 1;
					break;
				default:
					button.useHandCursor = true;
					button.labelOffsetX = 0;
					button.labelOffsetY = 0;
					button.iconOffsetX = 0;
					button.iconOffsetY = 0;
			}
		}
	}
}
