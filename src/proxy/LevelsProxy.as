package proxy
{
	import models.*;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	/**
	 * Прокси для уровней.
	 */
	public class LevelsProxy extends Proxy
	{
		public static const NAME:String = "levelsProxy";

		private var _levels:Vector.<LevelInfo>;

		public function LevelsProxy(data:Object = null)
		{
			super(NAME, data);
		}

		override public function setData(data:Object):void
		{
			super.setData(data);

			_levels = new Vector.<LevelInfo>();
			var src:XML = data as XML;
			if (src)
			{
				var levels:XMLList = src.level;
				for (var i:int = 0, l:int = levels.length(); i < l; i++)
					_levels.push(new LevelInfo(levels[i]));
			}

			_levels.sort(function (a:LevelInfo, b:LevelInfo):int
			{
				if (a.id > b.id) return 1;
				if (a.id < b.id) return -1;
				return 0;
			});
		}

		/**
		 * Список уровней.
		 */
		public function get levels():Vector.<LevelInfo>
		{
			return _levels;
		}

		/**
		 * Получить уровень по индексу.
		 * @param index Индекс уровня.
		 * @return Возвращает уровень с указанным индексом, или <code>null</code>, если такой не найден.
		 */
		public function getLevel(index:int):LevelInfo
		{
			for (var i:int = 0, l:int = _levels.length; i < l; i++)
			{
				if (_levels[i].id == index)
					return _levels[i];
			}
			return null;
		}

		/**
		 * Получить уровень по идентификатору.
		 * @param id Идентификатор уровня.
		 * @return Возвращает уровень с указанным идентификатором, или <code>null</code>, если такой не найден.
		 */
		public function getLevelById(id:String):LevelInfo
		{
			for (var i:int = 0, l:int = _levels.length; i < l; i++)
			{
				if (_levels[i].assetId == id)
					return _levels[i];
			}
			return null;
		}
	}
}
