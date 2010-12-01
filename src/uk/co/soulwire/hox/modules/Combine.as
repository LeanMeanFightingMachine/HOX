/**		
 * 
 *	uk.co.soulwire.hox.modules.Combine
 *	
 *	@version 1.00 | Nov 7, 2010
 *	@author Justin Windle
 *  
 **/
package uk.co.soulwire.hox.modules
{
	import uk.co.soulwire.hox.Module;
	import uk.co.soulwire.hox.Result;
	import uk.co.soulwire.hox.processes.CombineProcess;

	import flash.events.Event;

	/**
	 * @author soulwire
	 */
	public class Combine extends Module
	{
		// ----------------------------------------------------------------
		// CONSTANTS
		// ----------------------------------------------------------------
		
		private static const VALID_EXTENSIONS : Array = ["css", "js"];

		// ----------------------------------------------------------------
		// CONSTRUCTOR
		// ----------------------------------------------------------------
		
		public function Combine()
		{
			super("Combine", [0xF31768, 0xFF40E3]);
		}

		// ----------------------------------------------------------------
		// PROTECTED METHODS
		// ----------------------------------------------------------------
		
		override protected function processDrop(files : Array) : void
		{
			showLoading();
			
			var type : String;
			var process : CombineProcess;
			
			for each (type in VALID_EXTENSIONS)
			{
				process = new CombineProcess(files, type);
				process.addEventListener(Event.COMPLETE, onProcessComplete);
				process.start();
			}
		}
		
		//	----------------------------------------------------------------
		//	EVENT HANDLERS
		//	----------------------------------------------------------------
		
		private function onProcessComplete(event : Event) : void
		{
			var process : CombineProcess = event.target as CombineProcess;
			if (process.output.size > 0)
			{
				addResult(new Result(process.output));
				hideLoading();
			}
		}
	}
}
