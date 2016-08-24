package resources.skin
{
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.controls.ScrollBar;
	import feathers.controls.ScrollPolicy;
	import feathers.controls.Scroller;

	import flash.geom.Rectangle;

	import resources.AtlasLibrary;

	import starling.display.Image;
	import starling.textures.TextureAtlas;

	public class WoodenScrollerStyleProvider extends ScrollerStyleProviderBase
	{
		override protected function onSkinScroller(scroller:Scroller):void
		{
			scroller.verticalScrollPolicy = ScrollPolicy.ON;
			scroller.horizontalScrollPolicy = ScrollPolicy.OFF;

			scroller.verticalScrollBarFactory = scrollBarFactory;
		}

		private static var _atlas:TextureAtlas;
		private static function get atlas():TextureAtlas
		{
			if (!_atlas)
			{
				_atlas = AtlasLibrary.getInstance().manager.getTextureAtlas("wooden");
			}
			return _atlas;
		}

		private static function scrollBarFactory():ScrollBar
		{
			var scrollBar:ScrollBar = new DirectThumbScrollBar();
			scrollBar.thumbFactory = thumbFactory;
			scrollBar.maximumTrackFactory = trackFactory;
			scrollBar.minimumTrackFactory = trackFactory;
			return scrollBar;
		}

		private static function trackFactory():BasicButton
		{
			var track:BasicButton = new BasicButton();
			var img:Image = new Image(atlas.getTexture("wooden_bar"));
			img.scale9Grid = new flash.geom.Rectangle(0, 28, 28, 270);
			track.defaultSkin = img;
			return track;
		}

		private static function thumbFactory():Button
		{
			var thumb:Button = new Button();
			thumb.defaultSkin = new Image(atlas.getTexture("wooden_thumb"));
			return thumb;
		}
	}
}
