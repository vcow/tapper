package resources
{
	/**
	 * Библиотека DragonBones анимаций.
	 */
	public class AnimationsLibrary
	{
		[Embed(source="animations/schoolar_ske.json", mimeType="application/octet-stream")]
		public static const schoolar:Class;

		[Embed(source="animations/student_ske.json", mimeType="application/octet-stream")]
		public static const student:Class;

		[Embed(source="animations/carriage_ske.json", mimeType="application/octet-stream")]
		public static const carriage:Class;

		[Embed(source="animations/monarch_ske.json", mimeType="application/octet-stream")]
		public static const monarch:Class;

		[Embed(source="animations/president_ske.json", mimeType="application/octet-stream")]
		public static const president:Class;

		[Embed(source="animations/pope_ske.json", mimeType="application/octet-stream")]
		public static const pope:Class;

		[Embed(source="animations/zog_ske.json", mimeType="application/octet-stream")]
		public static const zog:Class;

		[Embed(source="animations/lucifer_ske.json", mimeType="application/octet-stream")]
		public static const lucifer:Class;

		[Embed(source="animations/vader_ske.json", mimeType="application/octet-stream")]
		public static const vader:Class;

		[Embed(source="animations/palpatin_ske.json", mimeType="application/octet-stream")]
		public static const palpatin:Class;

		[Embed(source="animations/ubermensch_ske.json", mimeType="application/octet-stream")]
		public static const ubermensch:Class;

		[Embed(source="animations/god_ske.json", mimeType="application/octet-stream")]
		public static const god:Class;

		public function AnimationsLibrary()
		{
			throw Error("AnimationsLibrary is a static class.")
		}
	}
}
