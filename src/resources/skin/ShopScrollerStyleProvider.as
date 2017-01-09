package resources.skin
{
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScrollBar;
	import feathers.controls.ScrollPolicy;
	import feathers.controls.Scroller;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;

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

		private static function trackFactory():BasicButton
		{
			var track:BasicButton = new BasicButton();
			var img:Image = new Image(AtlasLibrary.getInstance().shop.getTexture("scroll_bar"));
			img.scale9Grid = new flash.geom.Rectangle(0, 5, 9, 7);
			track.defaultSkin = img;
			return track;
		}

		private static function thumbFactory():Button
		{
			var atlas:TextureAtlas = AtlasLibrary.getInstance().shop;
			var skin:LayoutGroup = new LayoutGroup();
			skin.layout = new VerticalLayout();

			var partImg:Image = new Image(atlas.getTexture("scroll_thumb_top"));
			partImg.scale9Grid = new flash.geom.Rectangle(0, 15, 9, 4);
			var part:LayoutGroup = new LayoutGroup();
			part.layoutData = new VerticalLayoutData(NaN, 50);
			part.backgroundSkin = partImg;
			skin.addChild(part);

			partImg = new Image(atlas.getTexture("scroll_thumb_center"));
			part = new LayoutGroup();
			part.layoutData = new VerticalLayoutData();
			part.backgroundSkin = partImg;
			skin.addChild(part);

			partImg = new Image(atlas.getTexture("scroll_thumb_bottom"));
			partImg.scale9Grid = new flash.geom.Rectangle(0, 2, 9, 4);
			part = new LayoutGroup();
			part.layoutData = new VerticalLayoutData(NaN, 50);
			part.backgroundSkin = partImg;
			skin.addChild(part);

			var thumb:Button = new Button();
			thumb.defaultSkin = skin;
			return thumb;
		}
	}
}
