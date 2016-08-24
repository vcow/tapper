package resources
{
	import resources.skin.BackButtonStyleProvider;
	import resources.skin.CommonButtonStyleProvider;

	public class StylesLibrary
	{
		public static const commonButtonStyleProvider:CommonButtonStyleProvider = new CommonButtonStyleProvider();
		public static const backButtonStyleProvider:BackButtonStyleProvider = new BackButtonStyleProvider();

		public function StylesLibrary()
		{
			throw Error("StylesLibrary is a static class.");
		}
	}
}
