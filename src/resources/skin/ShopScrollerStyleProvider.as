package resources.skin
{
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScrollBar;
	import feathers.controls.ScrollPolicy;
	import feathers.controls.Scroller;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

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
			scrollBar.paddingTop = scrollBar.paddingBottom = 3;
			return scrollBar;
		}

		private static var _atlas:TextureAtlas;
		private static function get atlas():TextureAtlas
		{
			if (!_atlas)
			{
				_atlas = AtlasLibrary.getInstance().manager.getTextureAtlas("common_1");
			}
			return _atlas;
		}

		private static function trackFactory():BasicButton
		{
			var track:BasicButton = new BasicButton();
			var img:Image = new Image(atlas.getTexture("shop_scroll_bar"));
			img.scale9Grid = new flash.geom.Rectangle(0, 5, 9, 7);
			track.defaultSkin = img;
			return track;
		}

		private static function thumbFactory():Button
		{
			var skin:LayoutGroup = new LayoutGroup();
			skin.layout = new AnchorLayout();

			var partImg:Image = new Image(atlas.getTexture("shop_scroll_thumb"));
			partImg.scale9Grid = new flash.geom.Rectangle(0, 16, 9, 6);
			skin.backgroundSkin = partImg;

			partImg = new Image(atlas.getTexture("shop_scroll_thumb_center"));
			var part:LayoutGroup = new LayoutGroup();
			part.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			part.backgroundSkin = partImg;
			skin.addChild(part);

			var thumb:Button = new Button();
			thumb.defaultSkin = skin;
			return thumb;
		}
	}
}
