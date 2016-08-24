package view
{
	import dragonBones.Armature;
	import dragonBones.animation.WorldClock;
	import dragonBones.starling.StarlingArmatureDisplay;
	import dragonBones.starling.StarlingFactory;
	import dragonBones.starling.StarlingTextureAtlasData;

	import feathers.controls.LayoutGroup;

	import resources.AnimationsLibrary;

	import resources.AtlasLibrary;

	import starling.core.Starling;

	import starling.display.Image;
	import starling.events.EnterFrameEvent;

	import starling.textures.TextureAtlas;

	public class LevelView extends LayoutGroup
	{
		private var _assetId:String;
		private var _godMode:int;

		private var _clock:WorldClock;
		private var _armature:Armature;

		private static var INVALIDATE_FLAG_LEVEL:String = "level";

		private static var _atlas:TextureAtlas;
		private static function get atlas():TextureAtlas
		{
			if (!_atlas)
			{
				_atlas = AtlasLibrary.getInstance().manager.getTextureAtlas("states");
			}
			return _atlas;
		}

		public function LevelView()
		{
			super();

			width = 443;
			height = 332;
			clipContent = true;
		}

		private function clockHandler(event:EnterFrameEvent):void
		{
			_clock.advanceTime(event.passedTime);
		}

		public function set assetId(value:String):void
		{
			if (value == _assetId) return;
			_assetId = value;
			invalidate(INVALIDATE_FLAG_LEVEL);
		}

		public function set godMode(value:int):void
		{
			if (value == _godMode) return;
			_godMode = value;
			invalidate(INVALIDATE_FLAG_LEVEL);
		}

		override protected function draw():void
		{
			if (isInvalid(INVALIDATE_FLAG_LEVEL))
			{
				removeChildren();
				if (_clock && _armature)
				{
					_clock.remove(_armature);
					_armature.dispose();
					_armature = null;
				}

				if (_assetId)
				{
					if (_godMode <= 0)
					{
						if (_clock)
						{
							Starling.current.stage.removeEventListener(EnterFrameEvent.ENTER_FRAME, clockHandler);
							_clock = null;
						}
						var icon:Image = new Image(atlas.getTexture(_assetId));
						addChild(icon);
					}
					else
					{
						if (!_clock)
						{
							_clock = new WorldClock();
							Starling.current.stage.addEventListener(EnterFrameEvent.ENTER_FRAME, clockHandler);
						}
						var factory:StarlingFactory = new StarlingFactory();
						factory.parseDragonBonesData(JSON.parse(new AnimationsLibrary[_assetId]));
						factory.addTextureAtlasData(StarlingTextureAtlasData.fromTextureAtlas(atlas), _assetId);
						_armature = factory.buildArmature("Armature", _assetId);
						if (_godMode == 1)
							_armature.animation.play("shine_1");
						else if (_godMode == 2)
							_armature.animation.play("shine_2");
						else
							_armature.animation.play("shine_3");
						_armature.display.x = width / 2;
						_armature.display.y = height / 2;
						_clock.add(_armature);
						addChild(StarlingArmatureDisplay(_armature.display));
					}
				}
			}
			super.draw();
		}

		override public function dispose():void
		{
			if (_clock)
			{
				Starling.current.stage.removeEventListener(EnterFrameEvent.ENTER_FRAME, clockHandler);
				if (_armature) _clock.remove(_armature);
			}
			super.dispose();
		}
	}
}
