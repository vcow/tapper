package vo
{
	import app.AppFacade;

	import models.*;

	import org.puremvc.as3.multicore.patterns.observer.Notifier;

	import resources.locale.LocaleManager;

	public class AchievementInfo extends Notifier
	{
		private var _src:XML;

		private var _id:String;
		private var _title:String;
		private var _description:String;
		private var _rewards:Vector.<IReward>;
		private var _conditions:Vector.<ConditionBase>;
		private var _isMedal:Boolean;
		private var _receivedTime:Number;

		public function AchievementInfo(src:XML)
		{
			super();
			_src = src;
		}

		override public function initializeNotifier(key:String):void
		{
			super.initializeNotifier(key);

			var locale:LocaleManager = LocaleManager.getInstance();
			_id = _src.@id;
			_title = locale.getString('achievements', _src.@title) || _src.@title;
			_description = locale.getString('achievements', _src.@description) || _src.@description;
			_isMedal = (String(_src.@isMedal).toLowerCase() == "true");

			_rewards = new Vector.<IReward>();
			for each (var rewards:XML in _src.rewards)
			{
				for each (var item:XML in rewards.children())
				{
					switch (item.name().toString())
					{
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
			for each (var conditions:XML in _src.conditions)
			{
				for each (item in conditions.children())
				{
					switch (item.name().toString())
					{
						case "money":
							_conditions.push(new MoneyCondition(item));
							break;
						case "taps":
							_conditions.push(new TapsCondition(item));
							break;
						case "unit":
							_conditions.push(new UnitCondition(item));
							break;
						case "level":
							_conditions.push(new LevelCondition(item));
							break;
						case "top":
							_conditions.push(new TopCondition(item));
							break;
						default:
							throw Error("Unsupported condition " + item.name());
					}
				}
			}
		}

		public function checkForAward():Boolean
		{
			if (isReceived) return false;

			var result:int = 0;
			var gameModel:GameModel = AppFacade(facade).gameModel;
			for each (var condition:ConditionBase in _conditions)
			{
				if (condition is LevelCondition)
				{
					if (condition.check(gameModel.level)) ++result;
				}
				else if (condition is MoneyCondition)
				{
					if (condition.check(gameModel.money)) ++result;
				}
				else if (condition is TapsCondition)
				{
					if (condition.check(gameModel.tapsTotal)) ++result;
				}
				else if (condition is UnitCondition)
				{
					var unitCondition:UnitCondition = UnitCondition(condition);
					if (unitCondition.unitId)
					{
						if (unitCondition.check(gameModel.getUnitsCount(unitCondition.unitId))) ++result;
					}
					else
					{
						if (unitCondition.check(gameModel.getUnits().length)) ++result;
					}
				}
				else if (condition is TopCondition)
				{
					if (condition.check(gameModel.topUnitIndex)) ++result;
				}
			}
			return result == _conditions.length;
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

		public function get receivedTime():Number
		{
			return _receivedTime;
		}

		public function get isReceived():Boolean
		{
			return !isNaN(_receivedTime);
		}

		public function receive(timestamp:Number):void
		{
			if (isNaN(timestamp) || timestamp < 0)
			{
				_receivedTime = NaN;
				if (_conditions.length > 0)
				{
					for each (var condition:ConditionBase in _conditions) condition.reset();
				}
			}
			else
			{
				_receivedTime = timestamp;
			}
		}
	}
}
