package resources.skin
{
	import feathers.controls.Button;
	import feathers.controls.ButtonState;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalAlign;
	import feathers.text.BitmapFontTextFormat;

	import resources.AtlasLibrary;

	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.TextureAtlas;

	public class CommonButtonStyleProvider extends ButtonStyleProviderBase
	{
		private static var _atlas:TextureAtlas;
		private static function get atlas():TextureAtlas
		{
			if (!_atlas)
			{
				_atlas = AtlasLibrary.getInstance().manager.getTextureAtlas("title");
			}
			return _atlas;
		}

		override protected function onSkinButton(button:Button):void
		{
			button.defaultSkin = new Image(atlas.getTexture("menu_bn_normal"));
			button.downSkin = new Image(atlas.getTexture("menu_bn_down"));
			button.disabledSkin = new Image(atlas.getTexture("menu_bn_disabled"));

			button.verticalAlign = VerticalAlign.TOP;
			button.paddingTop = 10;

			button.defaultLabelProperties = {
				textFormat: new BitmapFontTextFormat("title_button_31"),
				alpha: 1.0
			};
			button.disabledLabelProperties = {
				textFormat: new BitmapFontTextFormat("title_button_31"),
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
