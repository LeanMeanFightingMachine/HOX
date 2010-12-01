/**		
 * 
 *	uk.co.soulwire.hox.processes.MinifyCSSProcess
 *	
 *	@version 1.00 | Nov 8, 2010
 *	@author Justin Windle
 *  
 **/
package uk.co.soulwire.hox.processes
{
	import uk.co.soulwire.air.Process;

	import flash.events.ErrorEvent;
	import flash.filesystem.File;

	/**
	 * MinifyCSSProcess
	 */
	public class MinifyCSSProcess extends Process
	{
		//	----------------------------------------------------------------
		//	PRIVATE MEMBERS
		//	----------------------------------------------------------------
		
		private var _input : File;
		private var _output : File;
		private var _compressor : File = File.applicationDirectory.resolvePath("bin/yuicompressor-2.4.2.jar");
		
		//	----------------------------------------------------------------
		//	CONSTRUCTOR
		//	----------------------------------------------------------------
		
		public function MinifyCSSProcess(input : File, output : File)
		{
			super("/usr/bin/java");

			_input = input;
			_output = output;
			
			if(input.extension.toLowerCase() == "css")
			{
				_arguments.push("-jar", _compressor.nativePath);
				_arguments.push("-o", output.nativePath);
				_arguments.push("--type", "css");
				_arguments.push(input.nativePath);
			}
			else
			{
				_errorLog = input.nativePath + " is not a valid format";
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			}
		}
		
		//	----------------------------------------------------------------
		//	PUBLIC ACCESSORS
		//	----------------------------------------------------------------
		
		public function get input() : File
		{
			return _input;
		}
		
		public function get output() : File
		{
			return _output;
		}
	}
}
