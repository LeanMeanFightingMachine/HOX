/**		
 * 
 *	uk.co.soulwire.air.FileManager
 *	
 *	@version 1.00 | Nov 7, 2010
 *	@author Justin Windle
 *  
 **/
package uk.co.soulwire.air
{
	import flash.filesystem.File;
	/**
	 * @author soulwire
	 */
	public class FileManager
	{
		//	----------------------------------------------------------------
		//	PRIVATE MEMBERS
		//	----------------------------------------------------------------
		
		private static const TEMP_FILES : Vector.<File> = new Vector.<File>();
		
		//	----------------------------------------------------------------
		//	PUBLIC METHODS
		//	----------------------------------------------------------------
		
		public static function createTempFile(name : String) : File
		{
			var directory : File = File.createTempDirectory();
			TEMP_FILES.push(directory);
			
			return directory.resolvePath(name);
		}
		
		public static function clean() : void
		{
			for each (var file : File in TEMP_FILES)
			{
				if (file.isDirectory)
				{
					file.deleteDirectory(true);
				}
				else
				{
					file.deleteFile();
				}
			}
		}
	}
}
