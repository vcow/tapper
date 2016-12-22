package resources
{
	import resources.skin.AvailablePriceLabelStyleProvider;
	import resources.skin.BackButtonStyleProvider;
	import resources.skin.ButtonStyleProviderBase;
	import resources.skin.CommonButtonStyleProvider;
	import resources.skin.CounterLabelStyleProvider;
	import resources.skin.LabelStyleProviderBase;
	import resources.skin.LevelDescriptionStyleProvider;
	import resources.skin.MoneyLabelStyleProvider;
	import resources.skin.PopupDescriptionStyleProvider;
	import resources.skin.PopupTitleStyleProvider;
	import resources.skin.ScrollerStyleProviderBase;
	import resources.skin.WoodenScrollerStyleProvider;
	import resources.skin.WoodenShopButtonStyleHighlightedProvider;
	import resources.skin.WoodenShopButtonStyleNormalProvider;
	import resources.skin.ShopItemDescriptionLabelStyleProvider;
	import resources.skin.ShopItemTitleLabelStyleProvider;
	import resources.skin.ShopScrollerStyleProvider;
	import resources.skin.UnavailablePriceLabelStyleProvider;

	public class StylesLibrary
	{
		public static const commonButtonStyleProvider:ButtonStyleProviderBase = new CommonButtonStyleProvider();
		public static const backButtonStyleProvider:ButtonStyleProviderBase = new BackButtonStyleProvider();

		public static const woodenShopButtonStyleNormalProvider:ButtonStyleProviderBase = new WoodenShopButtonStyleNormalProvider();
		public static const woodenShopButtonStyleHighlightedProvider:ButtonStyleProviderBase = new WoodenShopButtonStyleHighlightedProvider();

		public static const moneyLabelStyleProvider:LabelStyleProviderBase = new MoneyLabelStyleProvider();
		public static const popupTitleStyleProvider:LabelStyleProviderBase = new PopupTitleStyleProvider();
		public static const popupDescriptionStyleProvider:LabelStyleProviderBase = new PopupDescriptionStyleProvider();
		public static const levelDescriptionStyleProvider:LabelStyleProviderBase = new LevelDescriptionStyleProvider();
		public static const shopItemTitleLabelStyleProvider:LabelStyleProviderBase = new ShopItemTitleLabelStyleProvider();
		public static const shopItemDescriptionLabelStyleProvider:LabelStyleProviderBase = new ShopItemDescriptionLabelStyleProvider();
		public static const availablePriceLabelStyleProvider:LabelStyleProviderBase = new AvailablePriceLabelStyleProvider();
		public static const unavailablePriceLabelStyleProvider:LabelStyleProviderBase = new UnavailablePriceLabelStyleProvider();
		public static const counterLabelStyleProvider:LabelStyleProviderBase = new CounterLabelStyleProvider();

		public static const shopScrollerStyleProvider:ScrollerStyleProviderBase = new ShopScrollerStyleProvider();
		public static const woodenScrollerStyleProvider:ScrollerStyleProviderBase = new WoodenScrollerStyleProvider();

		public function StylesLibrary()
		{
			throw Error("StylesLibrary is a static class.");
		}
	}
}
