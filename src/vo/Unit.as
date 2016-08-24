package vo
{
	import resources.AtlasLibrary;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Unit extends BindableNotifier
	{
		private var _info:UnitInfo;
		private var _taps:uint;
		private var _ticks:uint;
		private var _buyPrice:Number;
		private var _active:Boolean;

		private var _tapsLeft:int = -1;
		private var _ticksLeft:int = -1;
		private var _count:int = -1;

		private var _icon:Texture;

		public function Unit(info:UnitInfo, buyPrice:Number, active:Boolean)
		{
			super();

			this.info = info;
			this.buyPrice = buyPrice;
			this.active = active;
		}

		private static var _atlas:TextureAtlas;
		private static function get atlas():TextureAtlas
		{
			if (!_atlas)
			{
				_atlas = AtlasLibrary.getInstance().manager.getTextureAtlas("units_small");
			}
			return _atlas;
		}

		[Bindable(event="iconChanged")]
		public function get icon():Texture
		{
			if (!_icon && _info) _icon = atlas.getTexture(_info.id);
			return _icon;
		}

		[Bindable(event="countChanged")]
		public function get count():int
		{
			return _count;
		}

		public function get info():UnitInfo
		{
			return _info;
		}

		public function set info(value:UnitInfo):void
		{
			if (value == _info) return;
			_info = value;

			if (_info)
			{
				if (_info.perClickProfit && _info.perClickProfit.maxCount) _tapsLeft = _info.perClickProfit.maxCount;
				if (_info.perSecondProfit && _info.perSecondProfit.maxCount) _ticksLeft = _info.perSecondProfit.maxCount;
			}

			_icon = null;
			dispatchEventWith("iconChanged");
		}

		public function get buyPrice():Number
		{
			return _buyPrice;
		}

		public function set buyPrice(value:Number):void
		{
			_buyPrice = value;
		}

		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			if (value == _active) return;
			_active = value;
			checkCount();
		}

		public function tap():void
		{
			_taps++;
			if (_active && _info.perClickProfit && _info.perClickProfit.maxCount)
			{
				if (_taps >= _info.perClickProfit.maxCount)
				{
					_tapsLeft = 0;
					this.active = false;
					sendNotification(Const.UPDATE_UNITS_LIST);
				}
				else
				{
					_tapsLeft = _info.perClickProfit.maxCount - _taps;
					checkCount();
				}
			}
		}

		public function tick():void
		{
			_ticks++;
			if (_active && _info.perSecondProfit && _info.perSecondProfit.maxCount)
			{
				if (_ticks >= _info.perSecondProfit.maxCount)
				{
					_ticksLeft = 0;
					this.active = false;
					sendNotification(Const.UPDATE_UNITS_LIST);
				}
				else
				{
					_ticksLeft = _info.perSecondProfit.maxCount - _ticks;
					checkCount();
				}
			}
		}

		public function get taps():uint
		{
			return _taps;
		}

		public function set taps(value:uint):void
		{
			if (value == _taps) return;
			_taps = value;
			if (_info.perClickProfit && _info.perClickProfit.maxCount)
			{
				if (_taps >= _info.perClickProfit.maxCount)
					_tapsLeft = 0;
				else
					_tapsLeft = _info.perClickProfit.maxCount - _taps;
				checkCount();
			}
		}

		public function get ticks():uint
		{
			return _ticks;
		}

		public function set ticks(value:uint):void
		{
			if (value == _ticks) return;
			_ticks = value;
			if (_info.perSecondProfit && _info.perSecondProfit.maxCount)
			{
				if (_ticks >= _info.perSecondProfit.maxCount)
					_ticksLeft = 0;
				else
					_ticksLeft = _info.perSecondProfit.maxCount - _ticks;
				checkCount();
			}
		}

		private function checkCount():void
		{
			var count:int = -1;
			if (_ticksLeft >= 0 && _tapsLeft >= 0)
				count = Math.min(_ticksLeft, _tapsLeft);
			else if (_tapsLeft >= 0)
				count = _tapsLeft;
			else if (_ticksLeft >= 0)
				count = _ticksLeft;

			if (count != _count)
			{
				_count = count;
				dispatchEventWith("countChanged");
			}
		}
	}
}
