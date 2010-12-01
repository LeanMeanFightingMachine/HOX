/**		
 * 
 *	uk.co.soulwire.hox.processes.CombineProcess
 *	
 *	@version 1.00 | Nov 7, 2010
 *	@author Justin Windle
 *  
 **/
package uk.co.soulwire.hox.processes
{
	import uk.co.soulwire.air.FileManager;
	import uk.co.soulwire.util.FileUtil;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;

	/**
	 * @author soulwire
	 */
	public class CombineProcess extends EventDispatcher
	{
		//	----------------------------------------------------------------
		//	PRIVATE MEMBERS
		//	----------------------------------------------------------------
		
		private var _type : String;
		private var _input : Array;
		private var _output : File;
		private var _validator : RegExp;
		private var _contents : String;
		
		//	----------------------------------------------------------------
		//	CONSTRUCTOR
		//	----------------------------------------------------------------
		
		public function CombineProcess(files : Array, type : String)
		{
			_validator = new RegExp(type, 'i');
			_input = files;
			_type = type;
		}
		
		//	----------------------------------------------------------------
		//	PUBLIC METHODS
		//	----------------------------------------------------------------
		
		public function start() : void
		{
			_output = FileManager.createTempFile("combined." + _type);
			_contents = '';

			for each (var file : File in _input)
			{
				processFile(file);
			}

			FileUtil.writeUTF(_contents, _output);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		// ----------------------------------------------------------------
		// PRIVATE METHODS
		// ----------------------------------------------------------------
		
		private function processFile(file : File) : void
		{
			if (file.isHidden)
			{
				return;
			}
			
			if (file.isDirectory)
			{
				var files : Array = file.getDirectoryListing();

				for each (file in files)
				{
					processFile(file);
				}
			}
			else
			{
				if (_validator.test(file.extension))
				{
					_contents += FileUtil.readUTF(file);
				}
			}
		}
		
		//	----------------------------------------------------------------
		//	PUBLIC ACCESSORS
		//	----------------------------------------------------------------
		
		public function get output() : File
		{
			return _output;
		}
	}
}
