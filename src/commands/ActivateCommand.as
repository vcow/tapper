package commands
{
import com.adobe.crypto.MD5;

import config.ApplicationConfig;

import events.UIEvent;

import flash.events.IEventDispatcher;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import models.AchievementInfo;
import models.Unit;
import models.UnitsModel;

import robotlegs.bender.framework.api.IInjector;

public class ActivateCommand extends SerializationCommandBase
{
	[Inject]
	public var injector:IInjector;

	[Inject]
	public var unitsModel:UnitsModel;

	[Inject]
	public var eventDispatcher:IEventDispatcher;

	override public function execute():void
	{
		var file:File = File.applicationStorageDirectory;
		file = file.resolvePath(ApplicationConfig.APP_NAME + ".state");
		if (file.exists && !file.isDirectory) {
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			deserializeGameModel(stream.readUTFBytes(stream.bytesAvailable));
			stream.close();
		}
	}

	private function deserializeGameModel(data:String):void
	{
		try {
			var dataObject:Object = JSON.parse(data as String);
		}
		catch (e:Error) {
			trace("Wrong data format.");
			return;
		}

		if (!dataObject.hasOwnProperty("hash")) return;

		var hash:String = dataObject.hash;
		delete dataObject["hash"];
		if (MD5.hashBytes(getBytes(dataObject)) != hash) {
			trace("Wrong signature.");
			return;
		}

		var achievementMap:Object = {};
		for each (listData in dataObject.achievements) {
			achievementMap[listData.achievement] = listData.received;
		}
		for (var i:int = 0, l:int = achievementsModel.achievements.length; i < l; i++) {
			var achievement:AchievementInfo = achievementsModel.achievements[i];
			achievement.receive(achievementMap[achievement.id]);
		}

		gameModel.money = dataObject.money;
		gameModel.tapsTotal = dataObject.tapsTotal;
		gameModel.moneyTotal = dataObject.moneyTotal;
		gameModel.tickCount = dataObject.tickCount;
		gameModel.level = dataObject.level;

		gameModel.units.splice(0, gameModel.units.length);
		for each (var listData:Object in dataObject.units) {
			var unit:Unit = new Unit(null, NaN, false);
			injector.injectInto(unit);
			deserializeUnit(unit, listData);
			gameModel.units.push(unit);
		}
		gameModel.sortUnitsByPrice();

		eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_LEVEL));
		eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_MONEY));
		eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_UNITS_LIST));
	}

	private function deserializeUnit(unit:Unit, dataObject:Object):void
	{
		unit.info = unitsModel.getUnitById(dataObject.unit);
		unit.taps = dataObject.taps;
		unit.ticks = dataObject.ticks;
		unit.buyPrice = dataObject.buyPrice;
		unit.active = dataObject.active;
	}
}
}
