/**		
 * 
 *	uk.co.soulwire.hox.processes.OpenProcess
 *	
 *	@version 1.00 | Nov 6, 2010
 *	@author Justin Windle
 *  
 **/
package uk.co.soulwire.hox.processes
{
	import flash.filesystem.File;
	import uk.co.soulwire.air.Process;

	/**
	 * @author soulwire
	 */
	public class OpenProcess extends Process
	{
		public function OpenProcess(file : File, application : String = "/Applications/TextEdit.app")
		{
			super("/usr/bin/open");
			_arguments.push("-a", application);
			_arguments.push(file.nativePath);
		}
	}
}
