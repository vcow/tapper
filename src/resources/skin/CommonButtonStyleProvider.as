package resources.skin
{
	import feathers.controls.Button;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;

	import flash.geom.Rectangle;

	import resources.AtlasLibrary;
	import resources.FontLibrary;

	import starling.display.ButtonState;

	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.TextureAtlas;

	public class CommonButtonStyleProvider extends ButtonStyleProviderBase
	{
		override protected function onSkinButton(button:Button):void
		{
			var atlas:TextureAtlas = AtlasLibrary.getInstance().title;
			const rc:Rectangle = new flash.geom.Rectangle(10, 10, 40, 40);

			button.defaultSkin = new Image(atlas.getTexture("menu_bn_normal"));
			button.downSkin = new Image(atlas.getTexture("menu_bn_down"));
			button.disabledSkin = new Image(atlas.getTexture("menu_bn_disabled"));

			button.defaultLabelProperties = {
				textFormat: new BitmapFontTextFormat(FontLibrary.getInstance().arial30)
			};
			button.disabledLabelProperties = {
				textFormat: new BitmapFontTextFormat(FontLibrary.getInstance().arial30),
				alpha: 0.3
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
					button.alpha = 0.8;
					break;
				case ButtonState.DOWN:
					button.useHandCursor = true;
					button.labelOffsetX = 1;
					button.labelOffsetY = 1;
					button.iconOffsetX = 1;
					button.iconOffsetY = 1;
					button.alpha = 1.0;
					break;
				default:
					button.useHandCursor = true;
					button.labelOffsetX = 0;
					button.labelOffsetY = 0;
					button.iconOffsetX = 0;
					button.iconOffsetY = 0;
					button.alpha = 1.0;
			}
		}
	}
}
