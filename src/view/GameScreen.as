package view
{
	import feathers.controls.LayoutGroup;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;

	import models.SkinType;

	import starling.display.DisplayObject;

import view.wooden.GameScreenWooden;

public class GameScreen extends LayoutGroup implements IGameScreen
	{
		private var _view:IGameScreen;
		private var _money:Number;
		private var _unitsList:ListCollection;
		private var _levelDescription:String;
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

			switch (skin) {
				case SkinType.WOOD: _view = new GameScreenWooden(); break;
				case SkinType.BRONZE: _view = new GameScreenBronze(); break;
				default: return;
			}

			_view.money = _money;
			_view.unitsList = _unitsList;
			_view.levelDescription = _levelDescription;

			if (isInitialized) {
				removeChildren();
				addChild(DisplayObject(_view));
			}
		}

		public function set money(value:Number):void
		{
			if (value == _money) return;

			_money = value;
			_view.money = value;
		}

		public function set unitsList(value:ListCollection):void
		{
			if (value == _unitsList) return;

			_unitsList = value;
			_view.unitsList = value;
		}

		public function set levelDescription(value:String):void
		{
			if (value == _levelDescription) return;

			_levelDescription = value;
			_view.levelDescription = value;
		}
	}
}
