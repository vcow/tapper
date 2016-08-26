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

	public class ShopScrollerStyleProvider extends ScrollerStyleProviderBase
	{
		override protected function onSkinScroller(scroller:Scroller):void
		{
			scroller.verticalScrollPolicy = ScrollPolicy.ON;
			scroller.horizontalScrollPolicy = ScrollPolicy.OFF;

			scroller.verticalScrollBarFactory = scrollBarFactory;
		}

		private static function scrollBarFactory():ScrollBar
		{
			var scrollBar:ScrollBar = new ScrollBar();
			scrollBar.thumbFactory = thumbFactory;
			scrollBar.maximumTrackFactory = trackFactory;
			scrollBar.minimumTrackFactory = trackFactory;
			return scrollBar;
		}

		private static function trackFactory():BasicButton
		{
			var track:BasicButton = new BasicButton();
			var img:Image = new Image(AtlasLibrary.getInstance().common.getTexture("scroll_bar"));
			img.scale9Grid = new flash.geom.Rectangle(0, 3, 7, 1);
			track.defaultSkin = img;
			return track;
		}

		private static function thumbFactory():Button
		{
			const rc:Rectangle = new flash.geom.Rectangle(0, 3, 7, 2);
			var atlas:TextureAtlas = AtlasLibrary.getInstance().common;
			var thumb:Button = new Button();
			var img:Image = new Image(atlas.getTexture("scroll_button_normal"));
			img.scale9Grid = rc;
			thumb.defaultSkin = img;
			img = new Image(atlas.getTexture("scroll_button_hover"));
			img.scale9Grid = rc;
			thumb.hoverSkin = img;
			img = new Image(atlas.getTexture("scroll_button_down"));
			img.scale9Grid = rc;
			thumb.downSkin = img;
			img = new Image(atlas.getTexture("scroll_button_disabled"));
			img.scale9Grid = rc;
			thumb.disabledSkin = img;
			return thumb;
		}
	}
}
