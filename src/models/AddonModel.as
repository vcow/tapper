package models
{
	import flash.utils.ByteArray;

	public class AddonModel
	{
		public var multiplier:int;
		public var godMode:int;
		public const rooms:Vector.<String> = new Vector.<String>();

		public function AddonModel()
		{
			reset();
		}

		public function reset():void
		{
			multiplier = 1;
			godMode = 0;
			rooms.length = 0;
			rooms.push(SkinType.WOOD);
		}

		public function serialize():ByteArray
		{
			var result:ByteArray = new ByteArray();
			var flags:uint = 0;
			flags |= godMode & 0x03;
			flags |= (multiplier & 0xff) << 2;
			result.writeUnsignedInt(flags);
			for each (var room:String in rooms)
			{
				switch (room)
				{
					case SkinType.WOOD: result.writeUTFBytes("w"); break;
					case SkinType.BRONZE: result.writeUTFBytes("b"); break;
					case SkinType.SILVER: result.writeUTFBytes("s"); break;
					case SkinType.GOLD: result.writeUTFBytes("g"); break;
				}
			}
			result.position = 0;
			return result;
		}

		public function deserialize(data:ByteArray):void
		{
			data.position = 0;
			var flags:uint = data.readUnsignedInt();
			godMode = flags & 0x03;
			multiplier = (flags >> 2) & 0xff;
			rooms.length = 0;
			while(data.bytesAvailable)
			{
				switch (data.readUTFBytes(1))
				{
					case "w": rooms.push(SkinType.WOOD); break;
					case "b": rooms.push(SkinType.BRONZE); break;
					case "s": rooms.push(SkinType.SILVER); break;
					case "g": rooms.push(SkinType.GOLD); break;
				}
			}
		}
	}
}
