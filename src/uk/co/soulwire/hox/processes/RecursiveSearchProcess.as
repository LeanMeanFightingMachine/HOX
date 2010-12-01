/**		
 * 
 *	uk.co.soulwire.hox.processes.RecursiveSearchProcess
 *	
 *	@version 1.00 | Nov 12, 2010
 *	@author Justin Windle
 *  
 **/
package uk.co.soulwire.hox.processes
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FileListEvent;
	import flash.filesystem.File;

	/**
	 * @author soulwire
	 */
	public class RecursiveSearchProcess extends EventDispatcher
	{
		//	----------------------------------------------------------------
		//	PRIVATE MEMBERS
		//	----------------------------------------------------------------
		
		private var _depth : int;
		private var _queue : int;
		private var _match : RegExp;
		private var _maxDepth : int;
		private var _directory : File;
		private var _results : Vector.<File>;
		private var _includeHiddenFiles : Boolean;
		
		//	----------------------------------------------------------------
		//	CONSTRUCTOR
		//	----------------------------------------------------------------
		
		public function RecursiveSearchProcess(directory : File, match : RegExp, maxDepth : int = 20, includeHiddenFiles : Boolean = false)
		{
			_includeHiddenFiles = includeHiddenFiles;
			_directory = directory;
			_maxDepth = maxDepth;
			_match = match;
		}
		
		//	----------------------------------------------------------------
		//	PRIVATE METHODS
		//	----------------------------------------------------------------
		
		private function search(file : File) : void
		{
			if (file.isHidden && !_includeHiddenFiles) return;

			if (file.isDirectory)
			{
				if (file.nativePath.split('/').length > _maxDepth)
				{
					return;
				}
				
				++_queue;
				file.addEventListener(FileListEvent.DIRECTORY_LISTING, onDirectoryListing);
				file.getDirectoryListingAsync();
			}
			else
			{
				if (_match.test(file.name))
				{
					_results.push(file);
				}
			}
		}
		
		//	----------------------------------------------------------------
		//	PUBLIC METHODS
		//	----------------------------------------------------------------
		
		public function start() : void
		{
			_results = new Vector.<File>();
			_depth = _directory.nativePath.split('/').length;
			_queue = 0;
			
			if (_directory.isHidden && !_includeHiddenFiles)
			{
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}

			search(_directory);
		}
		
		//	----------------------------------------------------------------
		//	EVENT HANDLERS
		//	----------------------------------------------------------------
		
		private function onDirectoryListing(event : FileListEvent) : void
		{
			var file : File = event.target as File;
			file.removeEventListener(FileListEvent.DIRECTORY_LISTING, onDirectoryListing);

			var files : Array = event.files;
			
			for (var i : int = 0; i < files.length; i++)
			{
				search(files[i]);
			}

			if (--_queue <= 0)
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		//	----------------------------------------------------------------
		//	PUBLIC ACCESSORS
		//	----------------------------------------------------------------
		
		public function get results() : Vector.<File>
		{
			return _results;
		}
	}
}
