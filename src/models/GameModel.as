package models
{
	import flash.utils.Dictionary;

	import org.puremvc.as3.multicore.core.Model;

	import vo.Unit;

	/**
	 * Состояние игры.
	 */
	public class GameModel extends Model
	{
		private var _callbackId:uint;
		private var _money:Number = 0;
		private var _units:Vector.<Unit> = new Vector.<Unit>();
		private var _unitsById:Dictionary = new Dictionary();
		private var _unitsByIndex:Dictionary = new Dictionary();
		private var _topUnitIndex:int;

		public var startBonus:Number = 0;		/// Стартовый бонус.

		public var pantheonUserName:String;		/// Имя игрока в пантеоне.
		public var godModeOff:Boolean;			/// Флаг режим Бога включен / выключен.
		public var tickCount:uint;				/// Текущее количество тиков таймера.
		public var level:uint;					/// Текущий уровень игрока.
		public var currentSkin:String;			/// Текущий тип Кабинета.
		public var currentState:String;			/// Текущее состояние игры.
		public var hasCurrentGame:Boolean;		/// Флаг наличия / отсутствия текущей игры (возможность / невозможность продолжить игру).
		public var isActive:Boolean;			/// Текущее состояния активности игры.
		public var tapsTotal:uint;				/// Текущее общее количество кликов по кнопке "Действовать".

		public var lastActivityTimestamp:int;	/// Время последней активности игрока (нажатия "Действовать").

		public var tutorial:Object = {};		/// Мапа, в которой в качестве ключа выступает экран, для которого отработал туториал.

		private static const LIMIT:Number = 999999999999.0;

		public const addonModel:AddonModel = new AddonModel();	/// Дополнительные параметры.

		public function GameModel(key:String)
		{
			super(key);
		}

		override protected function initializeModel():void
		{
			pantheonUserName = "";
			currentSkin = SkinType.WOOD;
			currentState = Const.STATE_START;
		}

		/**
		 * Идентификатор коллбека для посекундного таймера игры.
		 * @param value Идентификатор.
		 */
		public function set callbackId(value:uint):void
		{
			if (value == _callbackId) throw Error("Wrong callback Id.");
			_callbackId = value;
		}

		/**
		 * Идентификатор коллбека для посекундного таймера игры.
		 */
		public function get callbackId():uint
		{
			return _callbackId;
		}

		/**
		 * Возвращает текущее значение режима Бога.
		 * @return Возвращает текущее значение режима Бога. Если режим Бога отключен, значение отрицательное.
		 */
		public function getGodMode():int
		{
			return godModeOff ? addonModel.godMode * -1 : addonModel.godMode;
		}

		/**
		 * Возвращает текущее количество денег.
		 */
		public function get money():Number
		{
			return _money;
		}

		/**
		 * Задает текущее количество денег.
		 * @param value Новое количество денег.
		 * @return Если текущее количество изменилось, возвращает <code>true</code>.
		 */
		public function setMoney(value:Number):Boolean
		{
			if (value > LIMIT)
			{
				if (_money < LIMIT)
				{
					_money = LIMIT;
					return true;
				}
				return false;
			}
			_money = value;
			return true;
		}

		/**
		 * Флаг игра запущена / приостановлена.
		 */
		public function get isStarted():Boolean
		{
			return _callbackId != 0;
		}

		/**
		 * Индекс текущего топового юнита.
		 */
		public function get topUnitIndex():int
		{
			return _topUnitIndex;
		}

		/**
		 * Возвращает количество юнитов по идентификатору.
		 * @param id Идентификатор юнита.
		 * @return Возвращает количество юнитов с заданным идентификатором.
		 */
		public function getUnitsCount(id:String):int
		{
			var byIdList:Vector.<Unit> = _unitsById[id];
			return byIdList ? byIdList.length : 0;
		}

		/**
		 * Возвращает количество юнитов по индексу.
		 * @param index Индекс юнита.
		 * @return Возвращает количество юнитов с заданным индексом.
		 */
		public function getUnitsCountByIndex(index:int):int
		{
			var byIndexList:Vector.<Unit> = _unitsByIndex[index];
			return byIndexList ? byIndexList.length : 0;
		}

		/**
		 * Очистить список юнитов.
		 */
		public function clearUnits():void
		{
			_topUnitIndex = 0;
			_units.length = 0;
			for each (var unitsList:Vector.<Unit> in _unitsById) unitsList.length = 0;
			for each (unitsList in _unitsByIndex) unitsList.length = 0;
		}

		/**
		 * Текущий список юнитов.
		 * @return Возвращает список всех юнитов.
		 */
		public function getUnits():Vector.<Unit>
		{
			return _units;
		}

		/**
		 * Текущий список активных юнитов.
		 * @return Возвращает список только активных юнитов.
		 */
		public function getActiveUnits():Vector.<Unit>
		{
			var res:Vector.<Unit> = new Vector.<Unit>();
			for (var i:int = 0, l:int = _units.length; i < l; i++)
			{
				var unit:Unit = _units[i];
				if (unit.active) res.push(unit);
			}
			return res;
		}

		/**
		 * Заменяет тэг в строке текущим соответствующим значением.
		 * @param src Исходная строка.
		 * @return Возвращает строку с подставленными значениями.
		 */
		public function applyEnvVariables(src:String):String
		{
			if (src)
			{
				var match:Array = src.match(/%[^\s]+%/g);
				while (match.length > 0)
				{
					var tag:String = match.shift();
					var index:int = src.search(tag);
					switch (tag)
					{
						case "%LEVEL%":
							src = src.substr(0, index) + level + src.substr(index + tag.length);
							break;
					}
				}
			}
			return src;
		}

		/**
		 * Добавить юнит в список юнитов.
		 * @param unit Добавляемый юнит.
		 */
		public function addUnit(unit:Unit):void
		{
			_units.push(unit);

			var unitsList:Vector.<Unit> = _unitsById[unit.info.id];
			if (!unitsList) _unitsById[unit.info.id] = unitsList = new Vector.<Unit>();
			unitsList.push(unit);

			unitsList = _unitsByIndex[unit.info.index];
			if (!unitsList) _unitsByIndex[unit.info.index] = unitsList = new Vector.<Unit>();
			unitsList.push(unit);

			if (unit.info.index > _topUnitIndex) _topUnitIndex = unit.info.index;
		}

		/**
		 * Сортировать юниты по цене (от меньшего к большему).
		 */
		public function sortUnitsByPrice():void
		{
			_units.sort(sortByPrice);
			for each (var byIdList:Vector.<Unit> in _unitsById) byIdList.sort(sortByPrice);
		}

		/**
		 * Сортировать юниты по индексу (от меньшего к большему).
		 */
		public function sortUnitsByIndex():void
		{
			_units.sort(sortByIndex);
			for each (var byIdList:Vector.<Unit> in _unitsById) byIdList.sort(sortByIndex);
		}

		private static function sortByIndex(a:Unit, b:Unit):int
		{
			if (a.info.index > 0 && b.info.index <= 0) return 1;
			else if (a.info.index <= 0 && b.info.index > 0) return -1;
			else if (a.info.index < b.info.index) return 1;
			else if (a.info.index > b.info.index) return -1;
			return 0;
		}

		private static function sortByPrice(a:Unit, b:Unit):int
		{
			if (a.buyPrice < b.buyPrice) return 1;
			else if (a.buyPrice > b.buyPrice) return -1;
			return 0;
		}
	}
}
