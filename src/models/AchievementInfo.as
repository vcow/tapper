package models
{
	import events.AchievementEvent;

	import flash.events.IEventDispatcher;

	import gears.TriggerBroadcaster;

	import resources.locale.LocaleManager;

	import robotlegs.bender.framework.api.IInjector;

	public class AchievementInfo
	{
		private var _id:String;
		private var _title:String;
		private var _description:String;
		private var _rewards:Vector.<IReward>;
		private var _conditions:Vector.<ConditionBase>;
		private var _isMedal:Boolean;

		[Inject]
		public var triggerBroadcaster:TriggerBroadcaster;

		[Inject]
		public var eventDispatcher:IEventDispatcher;

		[Inject]
		public var gameModel:GameModel;

		[Inject]
		public var injector:IInjector;

		[PostConstruct]
		public function postConstruct():void
		{
			if (_conditions.length > 0) triggerBroadcaster.subscribe(onTrigger);
			for each (var reward:IReward in _rewards) injector.injectInto(reward);
		}

		private function onTrigger(trigger:String, value:*, ...args):void
		{
			var result:int = 0;
			for each (var condition:ConditionBase in _conditions) {
				if (trigger == TriggerBroadcaster.MONEY && condition is MoneyCondition) {
					if (condition.check(value)) result++;
				}
				else if (trigger == TriggerBroadcaster.TAP && condition is TapsCondition) {
					if (condition.check(value)) result++;
				}
				else if (trigger == TriggerBroadcaster.BUY && condition is UnitCondition) {
					var unit:UnitInfo = value as UnitInfo;
					if (unit) {
						if (UnitCondition(condition).unitId) {
							if (UnitCondition(condition).unitId == unit.id) {
								if (condition.check(gameModel.getUnitsCount(unit))) result++;
							}
						}
						else {
							if (condition.check(gameModel.units.length)) result++;
						}
					}
				}
			}
			if (result == _conditions.length) {
				triggerBroadcaster.unsubscribe(onTrigger);
				eventDispatcher.dispatchEvent(new AchievementEvent(AchievementEvent.ACHIEVE, this));
			}
		}

		public function AchievementInfo(src:XML)
		{
			var locale:LocaleManager = LocaleManager.getInstance();
			_id = src.@id;
			_title = locale.getString('achievements', src.@title) || src.@title;
			_description = locale.getString('achievements', src.@description) || src.@description;
			_isMedal = (String(src.@isMedal).toLowerCase() == "true");

			_rewards = new Vector.<IReward>();
			for each (var rewards:XML in src.rewards) {
				for each (var item:XML in rewards.children()) {
					switch (item.name().toString()) {
						case "action":
							_rewards.push(new ActionReward(item));
							break;
						case "p":
							_rewards.push(new ProfitReward(item));
							break;
						case "popup":
							_rewards.push(new PopUpReward(item));
							break;
						default:
							throw Error("Unsupported reward " + item.name());
					}
				}
			}

			_conditions = new Vector.<ConditionBase>();
			for each (var conditions:XML in src.conditions) {
				for each (item in conditions.children()) {
					switch (item.name().toString()) {
						case "money":
							_conditions.push(new MoneyCondition(item));
							break;
						case "taps":
							_conditions.push(new TapsCondition(item));
							break;
						case "unit":
							_conditions.push(new UnitCondition(item));
							break;
						default:
							throw Error("Unsupported condition " + item.name());
					}
				}
			}
		}

		public function get id():String
		{
			return _id;
		}

		public function get title():String
		{
			return _title;
		}

		public function get description():String
		{
			return _description;
		}

		public function get rewards():Vector.<IReward>
		{
			return _rewards;
		}

		public function get conditions():Vector.<ConditionBase>
		{
			return _conditions;
		}

		public function get isMedal():Boolean
		{
			return _isMedal;
		}
	}
}
