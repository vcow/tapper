package view
{
	import feathers.controls.LayoutGroup;

	import flash.display.BitmapData;
	import flash.display.Sprite;

	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;

	public class PreloaderProgress extends LayoutGroup
	{
		public static const PROGRESS_WIDTH:Number = 300.0;
		public static const PROGRESS_HEIGHT:Number = 16.0;

		private var _progress:Number = 0;
		private var _progressView:LayoutGroup;

		private var _backgroundTexture:Texture;

		public function PreloaderProgress()
		{
			super();

			this.touchable = false;
			this.backgroundSkin = new Image(backgroundTexture);

			_progressView = new LayoutGroup();
			_progressView.clipContent = true;
			_progressView.width = 1;
			_progressView.height = PROGRESS_HEIGHT;
			_progressView.includeInLayout = false;

			var bar:Quad = new Quad(PROGRESS_WIDTH - 8, PROGRESS_HEIGHT - 8, 0xfafafa);
			bar.x = 4;
			bar.y = 4;
			_progressView.addChild(bar);

			addChild(_progressView);
		}

		public function set progress(value:Number):void
		{
			if (value == _progress) return;
			_progress = value;
			_progressView.width = PROGRESS_WIDTH * _progress;
		}

		public function get progress():Number
		{
			return _progress;
		}

		protected function get backgroundTexture():Texture
		{
			if (!_backgroundTexture)
			{
				var canvas:Sprite = new Sprite();
				canvas.graphics.beginFill(0xfafafa);
				canvas.graphics.drawRect(0, 0, PROGRESS_WIDTH, PROGRESS_HEIGHT);
				canvas.graphics.endFill();
				canvas.graphics.beginFill(0x424242);
				canvas.graphics.drawRect(2, 2, PROGRESS_WIDTH - 4, PROGRESS_HEIGHT - 4);
				canvas.graphics.endFill();
				var source:BitmapData = new BitmapData(PROGRESS_WIDTH, PROGRESS_HEIGHT, true, 0x00000000);
				source.draw(canvas);
				canvas = null;

				_backgroundTexture = Texture.fromBitmapData(source);
				_backgroundTexture.root.onRestore = function():void
				{
					try {
						_backgroundTexture.root.uploadBitmapData(source);
					}
					catch (e:Error) {
					}
				};
			}
			return _backgroundTexture;
		}

		override public function dispose():void
		{
			if (_backgroundTexture)
			{
				_backgroundTexture.root.onRestore = null;
				_backgroundTexture.dispose();
				_backgroundTexture = null;
			}

			super.dispose();
		}
	}
}
