package commands
{
import config.ApplicationConfig;

import flash.utils.ByteArray;

import models.AchievementsModel;
import models.GameModel;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class SerializationCommandBase implements ICommand
{
	[Inject]
	public var gameModel:GameModel;

	[Inject]
	public var achievementsModel:AchievementsModel;

	public function execute():void
	{
		throw Error("Override in child.");
	}

	protected static function getBytes(dataObject:Object):ByteArray
	{
		var res:ByteArray = new ByteArray();
		res.writeUTFBytes(ApplicationConfig.APP_VERSION);
		res.writeFloat(dataObject.money);
		res.writeFloat(dataObject.moneyTotal);
		res.writeUnsignedInt(dataObject.tapsTotal);
		res.writeUnsignedInt(dataObject.tickCount);
		res.writeUnsignedInt(dataObject.level);
		res.writeUTFBytes(stringifyUnits(dataObject.units));
		res.writeUTFBytes(stringifyAchievements(dataObject.achievements));
		res.writeUTFBytes(ApplicationConfig.APP_NAME);
		res.writeFloat(dataObject.timestamp);
		res.position = 0;
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
