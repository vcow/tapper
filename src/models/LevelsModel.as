package models
{
	import resources.ConfigsLibrary;

	public class LevelsModel
	{
		private var _levels:Vector.<LevelInfo>;

		public function LevelsModel()
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
