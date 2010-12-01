/**		
 * 
 *	uk.co.soulwire.text.FontManager
 *	
 *	@version 1.00 | Nov 7, 2010
 *	@author Justin Windle
 *  
 **/
package uk.co.soulwire.text
{
	import flash.text.TextFormat;
	import flash.text.Font;
	/**
	 * @author soulwire
	 */
	public class FontManager
	{
		public static const TITLE_FONT_NAME : String = new TitleFont().fontName;
		public static const TITLE_FORMAT : TextFormat = new TextFormat(TITLE_FONT_NAME, 32, 0xFFFFFF);		public static const LABEL_FORMAT : TextFormat = new TextFormat(TITLE_FONT_NAME, 12, 0xFFFFFF);
		
		public static function init() : void
		{
			Font.registerFont(TitleFont);
		}
	}
}
