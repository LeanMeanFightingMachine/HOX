package uk.co.soulwire.hox.ui
{
	import assets.ButtonLayout;

	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author justin
	 */
	public class IconButton extends Sprite
	{
		//	----------------------------------------------------------------
		//	PUBLIC STATIC CONSTANTS
		//	----------------------------------------------------------------
		
		public static const MINIMISE : String = "minimise";
		public static const FOLDER : String = "folder";
		public static const CLOSE : String = "close";
		public static const FILE : String = "file";
		
		//	----------------------------------------------------------------
		//	PRIVATE MEMBERS
		//	----------------------------------------------------------------
		
		private var _button : ButtonLayout = new ButtonLayout();
		private var _background : MovieClip = _button.background;
		private var _icon : MovieClip = _button.icon;
		
		//	----------------------------------------------------------------
		//	CONSTRUCTOR
		//	----------------------------------------------------------------
		
		public function IconButton(type : String = null)
		{
			_background.alpha = 0.5;
			_icon.gotoAndStop(type);
			_icon.alpha = 0.8;
			
			buttonMode = true;
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onClick);
			addChild(_button);
		}
		
		//	----------------------------------------------------------------
		//	EVENT HANDLERS
		//	----------------------------------------------------------------

		private function onMouseOver(event : MouseEvent) : void
		{
			TweenMax.to(_background, 0.3, {alpha:0.7});
			TweenMax.to(_icon, 0.3, {alpha:1.0});
		}

		private function onMouseOut(event : MouseEvent) : void
		{
			TweenMax.to(_background, 0.3, {alpha:0.5});
			TweenMax.to(_icon, 0.3, {alpha:0.8});
		}

		private function onClick(event : MouseEvent) : void
		{
		}
	}
}
