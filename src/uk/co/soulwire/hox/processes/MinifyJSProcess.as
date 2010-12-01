/**		
 * 
 *	uk.co.soulwire.hox.processes.MinifyJSProcess
 *	
 *	@version 1.00 | Nov 8, 2010
 *	@author Justin Windle
 *  
 **/
package uk.co.soulwire.hox.processes
{
	import uk.co.soulwire.air.Process;
	import uk.co.soulwire.hox.html.ErrorLog;

	import flash.filesystem.File;

	/**
	 * MinifyJSProcess
	 */
	public class MinifyJSProcess extends Process
	{
		//	----------------------------------------------------------------
		//	PRIVATE MEMBERS
		//	----------------------------------------------------------------
		
		private var _output : File;
		private var _inputs : Vector.<File>;
		private var _compiler : File = File.applicationDirectory.resolvePath("bin/compiler.jar");
		
		//	----------------------------------------------------------------
		//	CONSTRUCTOR
		//	----------------------------------------------------------------
		
		public function MinifyJSProcess(inputs : Vector.<File>, output : File)
		{
			super("/usr/bin/java");

			_inputs = inputs;
			_output = output;
			
			_arguments.push("-jar", _compiler.nativePath);
			_arguments.push("--warning_level", "QUIET");
			_arguments.push("--compilation_level", "ADVANCED_OPTIMIZATIONS");
			
			for (var i : int = 0; i < inputs.length; i++)
			{
				if (inputs[i].extension.toLowerCase() == "js")
				{
					_arguments.push("--js", inputs[i].nativePath);
				}
			}
			
			_arguments.push("--js_output_file", output.nativePath);
		}
			
		override protected function handleComplete(success : Boolean) : void
		{
			if (!success)
			{
				var log : ErrorLog = new ErrorLog();
				
				var n : int;
				var m : int = 100;
				var r : RegExp = /([^\n]+ERROR[^\n]+)(\n([^\n]+))?(\n(\s+\^))?/g;
				var o : Object = r.exec(errorLog);
				
				var e : String,
					c : String,
					p : String;
				
				while(o)
				{
					e = o[1];
					c = o[3] || ' ';
					p = o[5] || '^';
					
					if((n = p.length - 1) > m)
					{
						c = c.substr(n - (m/2), m);
						p = p.substr(n - (m/2), m);
					}
					
					var desc : String = e.match(/ERROR.*?$/)[0];
					var file : String = e.match(/(^.*)(?=:\d+:\sERROR)/)[0];
					var line : String = e.match(/(?<=:)\d+(?=:\sERROR)/)[0];
					var code : String = c.replace(/\\n/g, '') + '\n' + p.replace(/\^/, "<span>^</span>");

					log.addError(desc, file, line, code);
					
					o = r.exec(errorLog);
				}
				
				log.openAsWindow();
			}		
		}
		
		//	----------------------------------------------------------------
		//	PUBLIC ACCESSORS
		//	----------------------------------------------------------------
		
		public function get inputs() : Vector.<File>
		{
			return _inputs;
		}
		
		public function get output() : File
		{
			return _output;
		}
	}
}
