package models
{
	import flash.utils.ByteArray;

	public class AddonModel
	{
		private static const VERSION:uint = 2;
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
			result.writeUnsignedInt(VERSION);
			var flags:uint = 0;
			flags |= godMode & 0x03;
			flags |= (multiplier & 0xff) << 2;
			result.writeUnsignedInt(flags);
			flags = 0;
			for each (var room:String in rooms)
			{
				switch (room)
				{
					case SkinType.WOOD: flags |= 0x01; break;
					case SkinType.BRONZE: flags |= 0x02; break;
					case SkinType.SILVER: flags |= 0x04; break;
					case SkinType.GOLD: flags |= 0x08; break;
				}
			}
			result.writeUnsignedInt(flags);
			result.position = 0;
			return result;
		}

		public function deserialize(data:ByteArray):void
		{
			data.position = 0;
			if (data.readUnsignedInt() != VERSION)
			{
				reset();
				trace ("Wrong add-on data version.");
			}
			else
			{
				var flags:uint = data.readUnsignedInt();
				godMode = flags & 0x03;
				multiplier = (flags >> 2) & 0xff;
				rooms.length = 0;
				flags = data.readUnsignedInt();
				if ((flags & 0x01) != 0) rooms.push(SkinType.WOOD);
				if ((flags & 0x02) != 0) rooms.push(SkinType.BRONZE);
				if ((flags & 0x04) != 0) rooms.push(SkinType.SILVER);
				if ((flags & 0x08) != 0) rooms.push(SkinType.GOLD);
			}
		}
	}
}
