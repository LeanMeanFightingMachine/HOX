/**		
 * 
 *	uk.co.soulwire.util.FileUtil
 *	
 *	@version 1.00 | Nov 6, 2010
 *	@author Justin Windle
 *  
 **/
package uk.co.soulwire.util
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/**
	 * @author soulwire
	 */
	public class FileUtil
	{
		public static function readUTF(file : File) : String
		{
			var text : String;
			var stream : FileStream = new FileStream();
			var bytes : ByteArray = new ByteArray();

			stream.open(file, FileMode.READ);
			stream.readBytes(bytes, 0, stream.bytesAvailable);

			text = bytes.readUTFBytes(bytes.bytesAvailable);

			stream.close();

			return text;
		}

		public static function readXML(file : File) : XML
		{
			var xml : XML;

			try
			{
				xml = new XML(readUTF(file));
			}
			catch(error : Error)
			{
				xml = new XML();
			}

			return xml;
		}

		public static function writeUTF(text : String, file : File) : void
		{
			var stream : FileStream = new FileStream();

			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(text);
			stream.close();
		}

		public static function writeXML(xml : XML, file : File) : void
		{
			writeUTF(xml.toXMLString(), file);
		}

		public static function getContents(directory : File, includeDirs : Boolean = true, includeHidden : Boolean = true) : Array
		{
			var files : Array = [];
			var valid : Boolean;
			var list : Array = directory.getDirectoryListing();

			for each (var file : File in list)
			{
				valid = false;

				if (file.isDirectory && includeDirs) valid = true;
				if (file.isHidden && includeHidden) valid = true;
				if (!file.isDirectory && !file.isHidden) valid = true;

				if (valid) files.push(file.nativePath);
			}

			return files;
		}

		public static function deleteContents(directory : File) : void
		{
			var contents : Array = directory.getDirectoryListing();

			for each (var file : File in contents)
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
