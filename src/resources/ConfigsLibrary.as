package resources
{
	public class ConfigsLibrary
	{
		[Embed(source="config/units.xml", mimeType="application/octet-stream")]
		private static const unitsConfig:Class;

		public static const units:XML = new XML(new unitsConfig());

		public function ConfigsLibrary()
		{
			throw Error("ConfigsLibrary is a static class.");
		}
	}
}
