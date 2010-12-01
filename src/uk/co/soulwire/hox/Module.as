/**		
 * 
 *	uk.co.soulwire.hox.Module
 *	
 *	@version 1.00 | Nov 6, 2010
 *	@author Justin Windle
 *  
 **/
package uk.co.soulwire.hox
{
	import flash.events.MouseEvent;
	import assets.ModuleLayout;

	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;

	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragActions;
	import flash.desktop.NativeDragManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NativeDragEvent;
	import flash.geom.Matrix;

	/**
	 * @author soulwire
	 */
	public class Module extends Sprite
	{
		//	----------------------------------------------------------------
		//	PROTECTED MEMBERS
		//	----------------------------------------------------------------
		
		protected var _colours : Array;
		protected var _layout : ModuleLayout = new ModuleLayout();
		protected var _results : Vector.<Result> = new Vector.<Result>();
		protected var _initHeight : int;
		protected var _resultsY : int;
		
		//	----------------------------------------------------------------
		//	CONSTRUCTOR
		//	----------------------------------------------------------------
		
		public function Module(name : String, colours : Array)
		{
			this.name = name;
			_colours = colours;
			
			configureListeners();
			initDisplay();
		}
		
		//	----------------------------------------------------------------
		//	PROTECTED METHODS
		//	----------------------------------------------------------------
		
		protected function processDrop(files : Array) : void
		{
			// override
		}
		
		protected function addResult(result : Result) : void
		{
			result.addEventListener(Event.CLOSE, onResultClose);
			
			for each (var old : Result in _results)
			{
				TweenMax.to(old, 0.3, {alpha : 0.6});
			}
			
			_layout.results.addChild(result);
			_results.push(result);
			
			result.alpha = 0.0;
			result.y = resultsHeight;

			sortResults();
			
			TweenMax.to(result, 0.5, {
				alpha : 1.0,
				delay : 0.2
			});
		}
		
		private function sortResults() : void
		{
			for (var i : int = 0; i < _results.length; i++) {
				TweenMax.to(_results[i], 0.3, {
					y:-((i + 1) * (_results[i].height + 1)),
					ease : Expo.easeOut
				});
			}
			
			TweenMax.to(_layout.background, 0.3, {
				height : _initHeight + resultsHeight,
				ease : Expo.easeOut
			});
			
			TweenMax.to(_layout.results, 0.3, {
				y : resultsY,
				ease : Expo.easeOut
			});
		}
		
		protected function removeResult(result : Result) : void
		{
			_results.splice(_results.indexOf(result), 1);
			_layout.results.removeChild(result);
			sortResults();
		}
		
		protected function showLoading() : void
		{
			_layout.loadingAnim.visible = true;
		}
		
		protected function hideLoading() : void
		{
			_layout.loadingAnim.visible = false;
		}
		
		//	----------------------------------------------------------------
		//	PRIVATE METHODS
		//	----------------------------------------------------------------
		
		private function configureListeners() : void
		{
			_layout.background.addEventListener(MouseEvent.MOUSE_DOWN, onBackgroundDown);
			_layout.gradient.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragEnter);
			_layout.gradient.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, onDragExit);
			_layout.gradient.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDragDrop);
		}
		
		private function initDisplay() : void
		{
			var gw : Number = _layout.gradient.width * 1.25;
			var gh : Number = _layout.gradient.height * 1.25;
			var tx : Number = _layout.gradient.width * -0.125;
			var ty : Number = _layout.gradient.height * -0.125;
			
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(gw, gh, -Math.PI / 4, tx, ty);

			_layout.gradient.graphics.beginGradientFill(GradientType.LINEAR, _colours, [1,1], [0,255], matrix);
			_layout.gradient.graphics.drawRect(0, 0, _layout.gradient.width, _layout.gradient.height);
			_layout.gradient.graphics.endFill();

			_layout.titleTF.text = name.toLowerCase();
			_layout.loadingAnim.visible = false;
			
			// Copy text to Bitmap
			
			var bmd : BitmapData = new BitmapData(_layout.titleTF.width, _layout.titleTF.height, true, 0x0);
			bmd.draw(_layout.titleTF);

			var bmp : Bitmap = new Bitmap(bmd);
			bmp.x = _layout.titleTF.x;
			bmp.y = _layout.titleTF.y;
			
			_layout.addChild(bmp);
			_layout.removeChild(_layout.titleTF);
			
			// Remove placeholder graphics
			_layout.gradient.removeChildAt(0);
			_layout.results.removeChildAt(0);

			_resultsY = _layout.results.y + 1;
			_initHeight = _layout.background.height;
			
			addChild(_layout);
		}
		
		//	----------------------------------------------------------------
		//	EVENT HANDLERS
		//	----------------------------------------------------------------
		
		private function onBackgroundDown(event : MouseEvent) : void
		{
			stage.nativeWindow.startMove();
		}
		
		private function onResultClose(event : Event) : void
		{
			var result : Result = event.target as Result;
			
			TweenMax.to(result, 0.3, {
				alpha : 0.2,
				onComplete : removeResult,
				onCompleteParams : [result],
				ease : Expo.easeOut
				});
		}
		
		private function onDragEnter(event : NativeDragEvent) : void
		{
			trace("onDragEnter");
			NativeDragManager.dropAction = NativeDragActions.COPY;
			NativeDragManager.acceptDragDrop(_layout.gradient);
		}

		private function onDragExit(event : NativeDragEvent) : void
		{
			trace("onDragExit");
		}

		private function onDragDrop(event : NativeDragEvent) : void
		{
			trace("onDragDrop");
			var dropped : Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			processDrop(dropped);
		}
		
		//	----------------------------------------------------------------
		//	MUTATORS
		//	----------------------------------------------------------------
		
		private function get resultsHeight() : int
		{
			return _results.length > 0 ? (_results.length * (_results[0].height + 1)) : 0;
		}
		
		private function get resultsY() : int
		{
			return _resultsY + resultsHeight - 1;
		}
	}
}
