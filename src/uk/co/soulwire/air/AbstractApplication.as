/**		
 * 
 *	uk.co.soulwire.air.AbstractApplication
 *	
 *	@version 1.00 | Nov 6, 2010
 *	@author Justin Windle
 *  
 **/
package uk.co.soulwire.air
{
	import air.update.events.StatusUpdateErrorEvent;
	import air.update.events.StatusUpdateEvent;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import air.update.events.UpdateEvent;
	import com.riaspace.nativeApplicationUpdater.NativeApplicationUpdater;

	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * @author soulwire
	 */
	public class AbstractApplication extends Sprite
	{
		//	----------------------------------------------------------------
		//	PROTECTED MEMBERS
		//	----------------------------------------------------------------
		
		protected var _updater : NativeApplicationUpdater = new NativeApplicationUpdater();
		
		//	----------------------------------------------------------------
		//	CONSTRUCTOR
		//	----------------------------------------------------------------
		
		public function AbstractApplication()
		{
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		//	----------------------------------------------------------------
		//	PUBLIC METHODS
		//	----------------------------------------------------------------
		
		public function checkForUpdates(updateURL : String) : void
		{
			_updater.addEventListener(UpdateEvent.INITIALIZED, onUpdaterInitialised);
			_updater.addEventListener(StatusUpdateEvent.UPDATE_STATUS, onUpdateStatus);			_updater.addEventListener(StatusUpdateErrorEvent.UPDATE_ERROR, onUpdateError);
			_updater.updateURL = updateURL;
			_updater.initialize();
		}
		
		//	----------------------------------------------------------------
		//	PROTECTED METHODS
		//	----------------------------------------------------------------
		
		protected function start() : void
		{
			
		}
		
		protected function close() : void
		{
			
		}
		
		//	----------------------------------------------------------------
		//	EVENT HANDLERS
		//	----------------------------------------------------------------
		
		private function onUpdateStatus(event : StatusUpdateEvent) : void
		{
			trace("onUpdateStatus");
			trace(event.version);
			trace(event.details);
		}

		private function onUpdateError(event : StatusUpdateErrorEvent) : void
		{
			trace("onUpdateError");
			trace(event.errorID);			trace(event.text);
		}
		
		private function onUpdaterInitialised(event : UpdateEvent) : void
		{
			_updater.checkNow();
		}

		private function onAddedToStage(event : Event) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			start();
		}
		
		private function onExiting(event : Event) : void
		{
			close();
		}
		
		//	----------------------------------------------------------------
		//	PUBLIC ACCESSORS
		//	----------------------------------------------------------------
		
		public function get version() : String
		{
			var desc : XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns : Namespace = desc.namespace();
			return desc.ns::version;
		}
	}
}
