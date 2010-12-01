/**		
 * 
 *	uk.co.soulwire.hox.modules.Clean
 *	
 *	@version 1.00 | Nov 6, 2010
 *	@author Justin Windle
 *  
 **/
package uk.co.soulwire.hox.modules
{
	import uk.co.soulwire.air.FileManager;
	import uk.co.soulwire.hox.Module;
	import uk.co.soulwire.hox.Result;

	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;

	/**
	 * @author soulwire
	 */
	public class Export extends Module
	{
		//	----------------------------------------------------------------
		//	CONSTANTS
		//	----------------------------------------------------------------
		
		private static const IGNORE : RegExp =  /\.(DS_Store|svn)$/i;
		
		// ----------------------------------------------------------------
		// PRIVATE MEMBERS
		// ----------------------------------------------------------------
		
		private var _temp : File;
		private var _root : File;
		private var _fileQueue : int;
		private var _directoryQueue : int;

		// ----------------------------------------------------------------
		// CONSTRUCTOR
		// ----------------------------------------------------------------
		public function Export()
		{
			super("Export", [0x0072ff, 0x00ffea]);
		}

		// ----------------------------------------------------------------
		// PROTECTED METHODS
		// ----------------------------------------------------------------
		
		override protected function processDrop(files : Array) : void
		{
			showLoading();
			_fileQueue = 0;
			_directoryQueue = 0;
			
			if (files.length == 1)
			{
				_root = files[0];
			}
			else
			{
				_root = File(files[0]).parent;
			}
			
			_temp = FileManager.createTempFile(_root.name);
			
			for each (var file : File in files)
			{
				processFile(file);
			}
		}

		// ----------------------------------------------------------------
		// PRIVATE METHODS
		// ----------------------------------------------------------------
		
		private function processFile(file : File) : void
		{
			trace("Process File:", file.name);
			
			var path : String = _root.getRelativePath(file);
			var dest : File = _temp.resolvePath(path);
			
			if (!IGNORE.test(file.name))
			{
				if (file.isDirectory)
				{
					++_directoryQueue;
					file.addEventListener(FileListEvent.DIRECTORY_LISTING, onDirectoryListing);
					file.getDirectoryListingAsync();
				}
				else
				{
					++_fileQueue;
					file.addEventListener(Event.COMPLETE, onCopyFileComplete);
					file.copyToAsync(dest);
				}
			}
		}

		// ----------------------------------------------------------------
		// EVENT HANDLERS
		// ----------------------------------------------------------------
		
		private function onDirectoryListing(event : FileListEvent) : void
		{
			File(event.target).removeEventListener(FileListEvent.DIRECTORY_LISTING, onDirectoryListing);

			--_directoryQueue;
			
			for each (var file : File in event.files)
			{
				processFile(file);
			}
		}
		
		private function onCopyFileComplete(event : Event) : void
		{
			File(event.target).removeEventListener(Event.COMPLETE, onCopyFileComplete);

			--_fileQueue;
			
			if (_fileQueue == 0 && _directoryQueue == 0)
			{
				addResult(new Result(_temp));
				hideLoading();
			}
		}
	}
}
