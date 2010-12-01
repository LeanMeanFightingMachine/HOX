/**		
 * 
 *	uk.co.soulwire.hox.modules.Minify
 *	
 *	@version 1.00 | Nov 6, 2010
 *	@author Justin Windle
 *  
 **/
package uk.co.soulwire.hox.modules
{
	import flash.display.BlendMode;
	import flash.events.ErrorEvent;
	import uk.co.soulwire.air.FileManager;
	import uk.co.soulwire.hox.Module;
	import uk.co.soulwire.hox.Result;
	import uk.co.soulwire.hox.processes.MinifyCSSProcess;
	import uk.co.soulwire.hox.processes.MinifyJSProcess;
	import uk.co.soulwire.hox.processes.RecursiveSearchProcess;
	import uk.co.soulwire.util.FileUtil;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;

	/**
	 * @author soulwire
	 */
	public class Minify extends Module
	{
		// ----------------------------------------------------------------
		// CONSTANTS
		// ----------------------------------------------------------------
		
		private static const FILETYPE_ANY : RegExp = /(css|js)$/;
		private static const FILETYPE_CSS : RegExp = /css$/i;
		private static const FILETYPE_JS : RegExp = /js$/i;
		
		//	----------------------------------------------------------------
		//	PRIVATE MEMBERS
		//	----------------------------------------------------------------
		
		private var _queue : int;
		private var _running : int;
		private var _filename : String;
		private var _queueCSS : Vector.<File>;
		private var _queueJS : Vector.<File>;
		
		//	----------------------------------------------------------------
		//	CONSTRUCTOR
		//	----------------------------------------------------------------
		
		public function Minify()
		{
			super("Minify", [0x00ff18, 0xe1e913]);
			_layout.loadingAnim.blendMode = BlendMode.INVERT;
		}
		
		//	----------------------------------------------------------------
		//	PRIVATE METHODS
		//	----------------------------------------------------------------
		
		private function evaluate(file : File) : void
		{
			if (FILETYPE_CSS.test(file.extension))
			{
				_queueCSS.push(file);
			}
			else if (FILETYPE_JS.test(file.extension))
			{
				_queueJS.push(file);
			}
		}
		
		private function minify() : void
		{
			_running = 0;
			
			if (_queueJS.length > 0)
			{
				++_running;
				minifyJS(_queueJS);
			}

			if (_queueCSS.length > 0)
			{
				++_running;
				
				if (_queueCSS.length == 1)
				{
					minifyCSS(_queueCSS[0]);
				}
				else
				{
					var combined : String = '';
					
					for (var i : int = 0; i < _queueCSS.length; i++)
					{
						combined += FileUtil.readUTF(_queueCSS[i]);
					}
					
					var input : File = FileManager.createTempFile("combined.css");
					FileUtil.writeUTF(combined, input);
					minifyCSS(input);
				}
			}
		}
		
		private function minifyJS(input : Vector.<File>) : void
		{
			trace("minifyJS", input);
			var output : File = FileManager.createTempFile(_filename || "script.min.js");
			var minify : MinifyJSProcess = new MinifyJSProcess(input, output);
			minify.addEventListener(ErrorEvent.ERROR, onMinifyError);
			minify.addEventListener(Event.COMPLETE, onMinifyComplete);
			minify.start();
		}
		
		private function minifyCSS(input : File) : void
		{
			trace("minifyCSS", input);
			var output : File = FileManager.createTempFile(_filename || "style.min.css");
			var minify : MinifyCSSProcess = new MinifyCSSProcess(input, output);
			minify.addEventListener(ErrorEvent.ERROR, onMinifyError);
			minify.addEventListener(Event.COMPLETE, onMinifyComplete);
			minify.start();
		}
		
		//	----------------------------------------------------------------
		//	PROTECTED METHODS
		//	----------------------------------------------------------------
		
		override protected function processDrop(files : Array) : void
		{
			var file : File;
			
			_queue = 0;
			_queueJS = new Vector.<File>();
			_queueCSS = new Vector.<File>();
			
			_filename = null;

			if (files.length == 1)
			{
				file = files[0];
				
				if (!file.isDirectory)
				{
					_filename = file.name.replace(/(\.\w+)$/, ".min$1");
				}
			}
			
			for (var i : int = 0; i < files.length; i++)
			{
				file = files[i];

				if (file.isDirectory)
				{
					++_queue;

					var process : RecursiveSearchProcess = new RecursiveSearchProcess(files[i], FILETYPE_ANY);
					process.addEventListener(Event.COMPLETE, onSearchComplete);
					process.start();
				}
				else
				{
					evaluate(file);
				}
			}

			if (_queue == 0)
			{
				minify();
			}
			
			showLoading();
		}
		
		//	----------------------------------------------------------------
		//	EVENT HANDLERS
		//	----------------------------------------------------------------
		
		private function onSearchComplete(event : Event) : void
		{
			--_queue;
			
			var process : RecursiveSearchProcess = event.target as RecursiveSearchProcess;
			
			for each (var file : File in process.results)
			{
				evaluate(file);
			}

			if (_queue <= 0)
			{
				minify();
			}
		}
		
		private function onMinifyError(event : ErrorEvent) : void
		{
			trace("Minify Error: ", event.errorID, event.text);
			hideLoading();
		}
		
		private function onMinifyComplete(event : Event) : void
		{
			var target : EventDispatcher = event.target as EventDispatcher;
			target.removeEventListener(Event.COMPLETE, onMinifyComplete);
			addResult(new Result(event.target["output"]));
			
			if(--_running <= 0)
			{
				hideLoading();
			}
		}
	}
}
