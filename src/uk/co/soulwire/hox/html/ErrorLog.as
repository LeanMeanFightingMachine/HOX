package uk.co.soulwire.hox.html
{
	import flash.system.Capabilities;
	import uk.co.soulwire.air.FileManager;
	import uk.co.soulwire.util.FileUtil;

	import flash.display.NativeWindowInitOptions;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.html.HTMLLoader;
	/**
	 * @author justin
	 */
	public class ErrorLog
	{
		//	----------------------------------------------------------------
		//	CONSTANTS
		//	----------------------------------------------------------------
		
		public static const TEMPLATE : String = '<div class="error"><h2>${description}</h2><p><a href="javascript:openFile(\'${file}\');">${file}</a> (${line})</p><pre>${source}</pre></div>';
		
		//	----------------------------------------------------------------
		//	PRIVATE MEMBERS
		//	----------------------------------------------------------------
		
		private var _errors : Vector.<String> = new Vector.<String>();
		private var _htmlTemplate : String = FileUtil.readUTF(File.applicationDirectory.resolvePath("html/errorlog.html"));
		
		//	----------------------------------------------------------------
		//	CONSTRUCTOR
		//	----------------------------------------------------------------
		
		public function ErrorLog()
		{
			
		}
		
		//	----------------------------------------------------------------
		//	PUBLIC METHODS
		//	----------------------------------------------------------------
		
		public function addError(description : String, file : String, line : String, source : String) : void
		{
			var error : String = TEMPLATE;

			error = error.replace(/\${description}/g, description);
			error = error.replace(/\${source}/g, source);
			error = error.replace(/\${file}/g, file);
			error = error.replace(/\${line}/g, line);

			_errors.push(error);
		}
		
		public function openAsWindow() : void
		{
			var options : NativeWindowInitOptions = new NativeWindowInitOptions();
			options.maximizable = true;
			options.minimizable = true;
			options.resizable = true;
			
			var rect : Rectangle = new Rectangle();
			rect.x = 24;
			rect.y = 36;
			rect.width = Capabilities.screenResolutionX * 0.5;
			rect.height = Capabilities.screenResolutionY -(rect.y * 2);
				
			var loader : HTMLLoader = HTMLLoader.createRootWindow(true, options, true, rect);
			loader.addEventListener(Event.COMPLETE, onHTMLComplete);
			loader.navigateInSystemBrowser = true;
			loader.loadString(html);
		}
		
		public function save(path : String = null) : File
		{
			var log : File = path ? new File().resolvePath(path) : FileManager.createTempFile("errorlog.html");
			FileUtil.writeUTF(html, log);
			
			return log;
		}
		
		//	----------------------------------------------------------------
		//	PRIVATE METHODS
		//	----------------------------------------------------------------
		
		private function openFile(path : String) : void
		{
			var file : File = new File().resolvePath(path);
			file.openWithDefaultApplication();
		}
		
		private function openLog() : void
		{
			save().openWithDefaultApplication();
		}
		
		//	----------------------------------------------------------------
		//	EVENT HANDLERS
		//	----------------------------------------------------------------
		
		private function onHTMLComplete(event : Event) : void
		{
			var html : HTMLLoader = event.currentTarget as HTMLLoader;
			html.removeEventListener(Event.COMPLETE, onHTMLComplete);
			html.window["openFile"] = openFile;
			html.window["openLog"] = openLog;
		}
		
		//	----------------------------------------------------------------
		//	PUBLIC ACCESSORS
		//	----------------------------------------------------------------
		
		public function get html() : String
		{
			return _htmlTemplate.replace(/\${date}/g, new Date())
								.replace(/\${errors}/g, _errors.join("\n\n"));
		}
	}
}
