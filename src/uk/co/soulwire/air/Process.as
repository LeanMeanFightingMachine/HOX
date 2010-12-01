/**		
 * 
 *	uk.co.soulwire.air.Process
 *	
 *	@version 1.00 | Nov 6, 2010
 *	@author Justin Windle
 *  
 **/
package uk.co.soulwire.air
{
	import uk.co.soulwire.hox.processes.OpenProcess;
	import uk.co.soulwire.util.FileUtil;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;

	/**
	 * @author soulwire
	 */
	public class Process extends EventDispatcher
	{
		//	----------------------------------------------------------------
		//	PROTECTED MEMBERS
		//	----------------------------------------------------------------
		
		protected var _errorLog : String;
		protected var _outputLog : String;
		protected var _hasError : Boolean = false;
		protected var _process : NativeProcess = new NativeProcess();
		protected var _arguments : Vector.<String> = new Vector.<String>();
		protected var _info : NativeProcessStartupInfo = new NativeProcessStartupInfo();
		
		//	----------------------------------------------------------------
		//	CONSTRUCTOR
		//	----------------------------------------------------------------
		
		public function Process(executable : String)
		{
			_info.executable = new File(executable);
			_info.arguments = _arguments;
		}
		
		//	----------------------------------------------------------------
		//	PUBLIC METHODS
		//	----------------------------------------------------------------
		
		public function start() : void
		{
			_hasError = false;
			_outputLog = '';
			_errorLog = '';

			addEventListener(ErrorEvent.ERROR, onError);
			_process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onProcessDataOutput);
			_process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onProcessErrorData);
			_process.addEventListener(NativeProcessExitEvent.EXIT, onProcessExit);
			_process.start(_info);
		}
		
		//	----------------------------------------------------------------
		//	PROTECTED METHODS
		//	----------------------------------------------------------------
		
		protected function handleError(error : String) : void
		{
			trace("handleError:", error);
		}
		
		protected function handleOutput(output : String) : void
		{
			trace("handleOutput:", output);
		}
		
		protected function handleComplete(success : Boolean) : void
		{
			trace("handleComplete:", success);
			trace("errors:", _errorLog);
			trace("output:", _outputLog);
			
			if(!success && _errorLog.length > 0)
			{
				var log : File = FileManager.createTempFile("errorlog.txt");
				FileUtil.writeUTF(_errorLog, log);
				
				var open : OpenProcess = new OpenProcess(log);
				open.start();
			}
		}
		
		//	----------------------------------------------------------------
		//	EVENT HANDLERS
		//	----------------------------------------------------------------
		
		private function onError(event : ErrorEvent) : void
		{
			trace("Standard error");
			_hasError = true;
		}
		
		private function onProcessDataOutput(event : ProgressEvent) : void
		{
			var result : String = _process.standardOutput.readUTFBytes(_process.standardOutput.bytesAvailable);
			_outputLog += result;
			
			handleOutput(result);
		}

		private function onProcessErrorData(event : ProgressEvent) : void
		{
			_hasError = true;
			
			var result : String = _process.standardError.readUTFBytes(_process.standardError.bytesAvailable);
			_errorLog += result;
			
			handleError(result);
		}

		private function onProcessExit(event : NativeProcessExitEvent) : void
		{
			handleComplete(!_hasError);
			
			if (_hasError)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, _errorLog, 1));
			}
			else
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		//	----------------------------------------------------------------
		//	PUBLIC ACCESSORS
		//	----------------------------------------------------------------
		
		public function get errorLog() : String
		{
			return _errorLog;
		}
		
		public function get outputLog() : String
		{
			return _outputLog;
		}
	}
}
