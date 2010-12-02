/**		
 * 
 *	uk.co.soulwire.hox.Application
 *	
 *	@version 1.00 | Nov 6, 2010
 *	@author Justin Windle
 *  
 **/
package uk.co.soulwire.hox
{
	import flash.system.Capabilities;
	import flash.display.Sprite;
	import uk.co.soulwire.air.AbstractApplication;
	import uk.co.soulwire.air.FileManager;
	import uk.co.soulwire.hox.modules.Export;
	import uk.co.soulwire.hox.modules.Combine;
	import uk.co.soulwire.hox.modules.Minify;
	import uk.co.soulwire.text.FontManager;

	/**
	 * @author soulwire
	 */
	public class Application extends AbstractApplication
	{
		//	----------------------------------------------------------------
		//	CONSTANTS
		//	----------------------------------------------------------------
		
		public static const UPDATE_URL : String = "https://github.com/LeanMeanFightingMachine/HOX/raw/master/version.xml";		//public static const UPDATE_URL : String = "file:///Users/justin/Dropbox/Workspace/Flash/HOX/version.xml";		//public static const UPDATE_URL : String = "file:///Volumes/Workspace/Dropbox/Workspace/Flash/HOX/version.xml";
		
		//	----------------------------------------------------------------
		//	PRIVATE MEMBERS
		//	----------------------------------------------------------------
		
		private var _modules : Vector.<Module> = new Vector.<Module>();
		private var _controls : WindowControls = new WindowControls();
		private var _container : Sprite = new Sprite();
		
		//	----------------------------------------------------------------
		//	CONSTRUCTOR
		//	----------------------------------------------------------------
		
		public function Application()
		{
			super();
			checkForUpdates(UPDATE_URL);
			addChild(_container);
		}
		
		//	----------------------------------------------------------------
		//	PROTECTED METHODS
		//	----------------------------------------------------------------
		
		override protected function start() : void
		{
			FontManager.init();
			
			addModule(new Combine());
			addModule(new Minify());
			addModule(new Export());

			_container.addChild(_controls);
			center();
		}
			
		override protected function close() : void
		{
			super.close();
			FileManager.clean();
		}
		
		//	----------------------------------------------------------------
		//	PRIVATE METHODS
		//	----------------------------------------------------------------
		
		private function center() : void
		{
			stage.nativeWindow.x = (Capabilities.screenResolutionX / 2) - (_container.width / 2);
			stage.nativeWindow.y = (Capabilities.screenResolutionY / 2) - (_container.height / 1.5);
			stage.nativeWindow.height = Capabilities.screenResolutionY - stage.nativeWindow.y;
			stage.nativeWindow.width = _container.width;
		}
		
		private function addModule(module : Module) : void
		{
			module.x = _controls.width + ((module.width + 1) * _modules.length) + 1;
			_container.addChild(module);
			_modules.push(module);
		}
	}
}
