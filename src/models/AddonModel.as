package models
{
	public class AddonModel
	{
		public var multiplier:int = 1;
		public const rooms:Vector.<String> = new Vector.<String>();

		public function AddonModel()
		{
			rooms.push(SkinType.WOOD);
		}
	}
}
