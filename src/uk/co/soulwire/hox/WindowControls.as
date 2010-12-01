package uk.co.soulwire.hox
{
	import uk.co.soulwire.air.FileManager;
	import uk.co.soulwire.hox.ui.IconButton;

	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author justin
	 */
	public class WindowControls extends Sprite
	{
		//	----------------------------------------------------------------
		//	PUBLIC MEMBERS
		//	----------------------------------------------------------------
		
		public var closeButton : IconButton = new IconButton(IconButton.CLOSE);
		public var hideButton : IconButton = new IconButton(IconButton.MINIMISE);
		
		//	----------------------------------------------------------------
		//	CONSTRUCTOR
		//	----------------------------------------------------------------
		
		public function WindowControls()
		{
			initButton(closeButton);
			initButton(hideButton);
		}
		
		//	----------------------------------------------------------------
		//	PRIVATE METHODS
		//	----------------------------------------------------------------
		
		private function initButton(button : IconButton) : void
		{
			button.buttonMode = true;
			button.y = (button.height + 1) * numChildren;
			button.addEventListener(MouseEvent.CLICK, onClick);
			addChild(button);
		}

		private function onClick(event : MouseEvent) : void
		{
			switch(event.currentTarget)
			{
				case closeButton :
					
					FileManager.clean();
					NativeApplication.nativeApplication.exit();
					
					break;
					
				case hideButton :
				
					stage.nativeWindow.minimize();
					
					break;
			}
		}
	}
}
