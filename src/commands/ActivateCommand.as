package commands
{
	import config.ApplicationConfig;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	import models.GameModel;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class ActivateCommand implements ICommand
	{
		[Inject]
		public var gameModel:GameModel;

		public function execute():void
		{
			var file:File = File.applicationStorageDirectory;
			file = file.resolvePath(ApplicationConfig.APP_NAME + ".state");
			if (file.exists && !file.isDirectory) {
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.READ);
				gameModel.deserialize(stream.readUTFBytes(stream.bytesAvailable));
				stream.close();
			}
		}
	}
}
