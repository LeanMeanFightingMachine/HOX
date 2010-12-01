/**		
 * 
 *	uk.co.soulwire.hox.Result
 *	
 *	@version 1.00 | Nov 6, 2010
 *	@author Justin Windle
 *  
 **/
package uk.co.soulwire.hox
{
	import assets.ResultLayout;

	import uk.co.soulwire.hox.ui.IconButton;

	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.desktop.NativeDragOptions;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.geom.Point;

	/**
	 * @author soulwire
	 */
	public class Result extends Sprite
	{
		//	----------------------------------------------------------------
		//	PRIVATE MEMBERS
		//	----------------------------------------------------------------
		
		private var _file : File;
		private var _closeButton : IconButton = new IconButton(IconButton.CLOSE);
		private var _layout : ResultLayout = new ResultLayout();
		
		//	----------------------------------------------------------------
		//	CONSTRUCTOR
		//	----------------------------------------------------------------
		
		public function Result(file : File)
		{
			_file = file;
			_layout.addChild(_closeButton);
			_closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			_closeButton.x = _layout.width + 1;
			
			enableDragOut();
			initDisplay();
		}

		private function onCloseClick(event : MouseEvent) : void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		//	----------------------------------------------------------------
		//	PUBLIC METHODS
		//	----------------------------------------------------------------
		
		public function enableDragOut() : void
		{
			_layout.background.buttonMode = true;
			_layout.background.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		//	----------------------------------------------------------------
		//	PRIVATE METHODS
		//	----------------------------------------------------------------
		
		private function initDisplay() : void
		{
			_layout.fileTF.text = _file.name;
			_layout.icon.gotoAndStop(_file.isDirectory ? "folder" : "file");
			
			// Copy text to Bitmap

			var bmd : BitmapData = new BitmapData(_layout.fileTF.width, _layout.fileTF.height, true, 0x0);
			bmd.draw(_layout.fileTF);

			var bmp : Bitmap = new Bitmap(bmd);
			bmp.x = _layout.fileTF.x;
			bmp.y = _layout.fileTF.y;
			
			_layout.addChild(bmp);
			_layout.removeChild(_layout.fileTF);
			
			addChild(_layout);
		}
		
		private function startDragOut(target : InteractiveObject) : void
		{
			var clipboard : Clipboard = new Clipboard();
			clipboard.setData(ClipboardFormats.FILE_LIST_FORMAT, [_file]);
			
			var helper : BitmapData = new BitmapData(target.width, target.height, true, 0x0);
			helper.draw(target);
			
			var options : NativeDragOptions = new NativeDragOptions();
			options.allowLink = false;
			options.allowMove = false;
			options.allowCopy = true;
			
			var offset : Point = new Point();
			offset.x = -target.mouseX;
			offset.y = -target.mouseY;

			target.addEventListener(NativeDragEvent.NATIVE_DRAG_COMPLETE, onDragOutComplete);
			NativeDragManager.doDrag(target, clipboard, helper, offset, options);
		}
		
		//	----------------------------------------------------------------
		//	EVENT HANDLERS
		//	----------------------------------------------------------------

		private function onMouseDown(event : MouseEvent) : void
		{
			startDragOut(this);
		}
		
		private function onDragOutComplete(event : NativeDragEvent) : void
		{
			trace("onDragOutComplete");
		}
	}
}
