package commands
{
	import config.ApplicationConfig;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	import models.GameModel;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class DeactivateCommand implements ICommand
	{
		[Inject]
		public var gameModel:GameModel;

		public function execute():void
		{
			var data:String = gameModel.serialize(true) as String;
			if (data) {
				data.replace(/\n/g, File.lineEnding);
				var file:File = File.applicationStorageDirectory;
				file = file.resolvePath(ApplicationConfig.APP_NAME + ".state");
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.WRITE);
				stream.writeUTFBytes(data);
				stream.close();
			}
		}
	}
}
