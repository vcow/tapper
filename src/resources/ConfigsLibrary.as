package resources
{
	public class ConfigsLibrary
	{
		[Embed(source="config/units.xml", mimeType="application/octet-stream")]
		private static const unitsConfig:Class;

		[Embed(source="config/actions.xml", mimeType="application/octet-stream")]
		private static const actionsConfig:Class;

		[Embed(source="config/levels.xml", mimeType="application/octet-stream")]
		private static const levelsConfig:Class;

		[Embed(source="config/achievements.xml", mimeType="application/octet-stream")]
		private static const achievementsConfig:Class;

		public static const units:XML = new XML(new unitsConfig());
		public static const actions:XML = new XML(new actionsConfig());
		public static const levels:XML = new XML(new levelsConfig());
		public static const achievements:XML = new XML(new achievementsConfig());

		public function ConfigsLibrary()
		{
			throw Error("ConfigsLibrary is a static class.");
		}
	}
}
