/**		
 * 
 *	uk.co.soulwire.hox.processes.MinifyProcess
 *	
 *	@version 1.00 | Nov 6, 2010
 *	@author Justin Windle
 *  
 **/
package uk.co.soulwire.hox.processes
{
	import uk.co.soulwire.air.Process;

	import flash.events.ErrorEvent;
	import flash.filesystem.File;

	/**
	 * @author soulwire
	 */
	public class MinifyProcess extends Process
	{	
		//	----------------------------------------------------------------
		//	PRIVATE MEMBERS
		//	----------------------------------------------------------------
		
		private var _input : File;
		private var _output : File;
		private var _compiler : File = File.applicationDirectory.resolvePath("bin/compiler.jar");
		private var _compressor : File = File.applicationDirectory.resolvePath("bin/yuicompressor-2.4.2.jar");
		
		//	----------------------------------------------------------------
		//	CONSTRUCTOR
		//	----------------------------------------------------------------
		
		public function MinifyProcess(input : File, output : File)
		{
			super("/usr/bin/java");

			_input = input;
			_output = output;
			
			var type : String = input.extension.toLowerCase();
			
			switch(type)
			{
				case "js" :
				
					_arguments.push("-jar", _compiler.nativePath);
					_arguments.push("--warning_level", "QUIET");
					_arguments.push("--compilation_level", "ADVANCED_OPTIMIZATIONS");
					_arguments.push("--js", input.nativePath);
					_arguments.push("--js_output_file", output.nativePath);
					
					break;
				
				case "css" :
					
					_arguments.push("-jar", _compressor.nativePath);
					_arguments.push("-o", output.nativePath);
					_arguments.push("--type", type.toLowerCase());
					_arguments.push(input.nativePath);
				
					break;
					
				default :
					
					_errorLog = input.nativePath + " is not a valid format";
					dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
				
					break;
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
