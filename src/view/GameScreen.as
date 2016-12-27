package view
{
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;

	import models.SkinType;

	import starling.display.DisplayObject;

	import view.wooden.GameScreenWooden;

	public class GameScreen extends LayoutGroup
	{
		private var _view:DisplayObject;
		private var _currentSkin:String;

		public static const BACK:String = "back";
		public static const SHOP:String = "shop";
		public static const TAP:String = "tap";

		public function GameScreen()
		{
			super();

			layout = new AnchorLayout();

			_view = new GameScreenWooden();
			_currentSkin = SkinType.WOOD;
		}

		override protected function initialize():void
		{
			super.initialize();
			addChild(DisplayObject(_view));
		}

		public function setSkin(skin:String):void
		{
			if (skin == _currentSkin) return;

			switch (skin)
			{
				case SkinType.WOOD:
					_view = new GameScreenWooden();
					break;
				case SkinType.BRONZE:
					_view = new GameScreenBronze();
					break;
				default:
					return;
			}

			if (isInitialized)
			{
				removeChildren(0, -1, true);
				addChild(DisplayObject(_view));
			}
		}
	}
}
