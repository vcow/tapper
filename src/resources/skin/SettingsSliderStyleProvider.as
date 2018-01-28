package resources.skin
{
	import feathers.controls.BasicButton;
	import feathers.controls.LayoutGroup;
	import feathers.controls.Slider;

	import resources.AtlasLibrary;

	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;

	import starling.textures.TextureAtlas;

	public class SettingsSliderStyleProvider extends SliderStyleProviderBase
	{
		private static var _atlas:TextureAtlas;
		private static function get atlas():TextureAtlas
		{
			if (!_atlas)
			{
				_atlas = AtlasLibrary.getInstance().manager.getTextureAtlas("common_1");
			}
			return _atlas;
		}

		override protected function onSkinSlider(slider:Slider):void
		{
			slider.minimumPadding = 28;
			slider.maximumPadding = 28;
			slider.thumbFactory = thumbFactory;

			var bar:LayoutGroup = new LayoutGroup();
			var back:Image = new Image(atlas.getTexture("settings_scroller_back"));
			bar.width = back.width;
			bar.height = back.height;
			bar.addChild(back);
			var track:LayoutGroup = new LayoutGroup();
			track.clipContent = true;
			var trackView:Image = new Image(atlas.getTexture("settings_scroller_bar"));
			track.width = back.width * (slider.value / (slider.maximum - slider.minimum));
			track.height = back.height;
			track.addChild(trackView);
			bar.addChild(track);

 			slider.minimumTrackFactory = function ():BasicButton
			{
				var track:BasicButton = new BasicButton();
				track.defaultSkin = bar;
				return track;
			};
			slider.addEventListener(Event.CHANGE, function (event:Event):void
			{
				track.width = slider.minimumPadding +
						(back.width - (slider.minimumPadding + slider.maximumPadding)) *
						(slider.value / (slider.maximum - slider.minimum));
			});
		}

		private static function thumbFactory():BasicButton
		{
			var track:BasicButton = new BasicButton();
			var skin:Quad = new Quad(30, 86, 0x000000);
			skin.alpha = 0;
			track.defaultSkin = skin;
			return track;
		}
	}
}
