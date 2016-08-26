package resources
{
	public class ConfigsLibrary
	{
		[Embed(source="config/units.xml", mimeType="application/octet-stream")]
		private static const unitsConfig:Class;

		[Embed(source="config/actions.xml", mimeType="application/octet-stream")]
		private static const actionsConfig:Class;

		public static const units:XML = new XML(new unitsConfig());
		public static const actions:XML = new XML(new actionsConfig());

		public function ConfigsLibrary()
		{
			throw Error("ConfigsLibrary is a static class.");
		}
	}
}
