package
{
	import feathers.utils.ScreenDensityScaleFactorManager;

	import flash.display.Stage;

	import starling.core.Starling;

	public class ScreenDensityScaleFactorManagerEx extends ScreenDensityScaleFactorManager
	{
		private var _destinationWidth:Number;
		private var _destinationHeight:Number;

		public function ScreenDensityScaleFactorManagerEx(starling:Starling, destinationWidth:Number,
														  destinationHeight:Number)
		{
			_destinationWidth = destinationWidth;
			_destinationHeight = destinationHeight;

			super(starling);
		}

		override protected function calculateScaleFactor():Number
		{
			var nativeStage:Stage = this._starling.nativeStage;
			if (nativeStage.stageWidth && _destinationWidth && nativeStage.stageHeight && _destinationHeight)
				return Math.min(nativeStage.stageWidth / _destinationWidth, nativeStage.stageHeight / _destinationHeight);
			return super.calculateScaleFactor();
		}
	}
}
