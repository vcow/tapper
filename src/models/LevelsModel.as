package models
{
	import org.puremvc.as3.multicore.core.Model;

	import resources.ConfigsLibrary;

	public class LevelsModel extends Model
	{
		public static const NAME:String = "levelsModel";

		private var _levels:Vector.<LevelInfo>;

		public function LevelsModel(key:String)
		{
			super(key);
		}

		override protected function initializeModel():void
		{
			_levels = new Vector.<LevelInfo>();
			var levels:XMLList = ConfigsLibrary.levels.level;
			for (var i:int = 0, l:int = levels.length(); i < l; i++) _levels.push(new LevelInfo(levels[i]));
		}

		public function get levels():Vector.<LevelInfo>
		{
			return _levels;
		}

		public function getLevelById(id:String):LevelInfo
		{
			for (var i:int = 0, l:int = _levels.length; i < l; i++) {
				if (_levels[i].id == id) return _levels[i];
			}
			return null;
		}
	}
}
