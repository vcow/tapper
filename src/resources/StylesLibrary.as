package resources
{
	import resources.skin.BackButtonStyleProvider;
	import resources.skin.ButtonStyleProviderBase;
	import resources.skin.CommonButtonStyleProvider;
	import resources.skin.LabelStyleProviderBase;
	import resources.skin.MoneyLabelStyleProvider;
	import resources.skin.ShopButtonStyleProvider;
	import resources.skin.TapButton1StyleProvider;

	public class StylesLibrary
	{
		public static const commonButtonStyleProvider:ButtonStyleProviderBase = new CommonButtonStyleProvider();
		public static const backButtonStyleProvider:ButtonStyleProviderBase = new BackButtonStyleProvider();
		public static const shopButtonStyleProvider:ButtonStyleProviderBase = new ShopButtonStyleProvider();
		public static const tapButton1StyleProvider:ButtonStyleProviderBase = new TapButton1StyleProvider();

		public static const moneyLabelStyleProvider:LabelStyleProviderBase = new MoneyLabelStyleProvider();

		public function StylesLibrary()
		{
			throw Error("StylesLibrary is a static class.");
		}
	}
}
