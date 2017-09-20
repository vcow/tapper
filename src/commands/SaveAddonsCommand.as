package commands
{
	import app.AppFacade;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	import models.GameModel;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * Команда на сохранение дополнительных игровых настроек.
	 */
	public class SaveAddonsCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			try {
				var file:File = File.documentsDirectory.resolvePath("miroed");
				file.createDirectory();
			}
			catch (e:Error) {
				file = File.applicationStorageDirectory;
			}
			file = file.resolvePath(Const.APP_NAME + ".addon");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(gameModel.addonModel.serialize());
			stream.close();
		}
	}
}
