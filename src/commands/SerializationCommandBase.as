package commands
{
	import flash.utils.ByteArray;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * Базовый класс для команд, поддерживающих сериализацию. Содержит алгоритм создания хеша для поддержания
	 * целостности данных.
	 */
	public class SerializationCommandBase extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			throw Error("Abstract.");
		}

		protected static function getBytes(dataObject:Object):ByteArray
		{
			var res:ByteArray = new ByteArray();
			try
			{
				res.writeUTFBytes(Const.APP_VERSION);
				res.writeFloat(dataObject.money);
				res.writeFloat(dataObject.moneyTotal);
				res.writeUnsignedInt(dataObject.tapsTotal);
				res.writeUnsignedInt(dataObject.tickCount);
				res.writeUnsignedInt(dataObject.level);
				res.writeUTFBytes(dataObject.skin);
				res.writeUTFBytes(stringifyUnits(dataObject.units));
				res.writeUTFBytes(stringifyAchievements(dataObject.achievements));
				res.writeUTFBytes(Const.APP_NAME);
				res.writeFloat(dataObject.timestamp);
				res.position = 0;
			}
			catch (e:Error)
			{
				res.clear();
			}
			return res;
		}

		private static function stringifyUnits(units:Array):String
		{
			units.sortOn("unit");
			var res:String = "";
			for (var i:int = 0, l:int = units.length; i < l; i++) res += units[i].unit + ";";
			return res;
		}

		private static function stringifyAchievements(achievements:Array):String
		{
			achievements.sortOn("achievement");
			var res:String = "";
			for (var i:int = 0, l:int = achievements.length; i < l; i++) res += achievements[i].achievement + ";";
			return res;
		}
	}
}
