package net.guttershark.util 
{
	
	import flash.display.Bitmap;
	
	/**
	 * The BitmapUtils class has static methods on it for easy access
	 * to common bitmap operations.
	 */
	public class BitmapUtils 
	{
	
		/**
		 * A convenience method for copying bitmaps with a memory saving
		 * technique that doesn't duplicate bitmap data associated with
		 * the bitmap.
		 * 
		 * <listing>	
		 * import net.guttershark.util.BitmapUtils;
		 * var bmd:BitmapData = new BitmapData(50,50,false,0xFF0066);
		 * var bitmap1:Bitmap = new Bitmap(bmd);
		 * addChild(bitmap1);
		 * var bitmap2:Bitmap = BitmapUtils.CopyBitmap(bitmap1);
		 * bitmap2.x = 100;
		 * bitmap2.y = 100;
		 * addChild(bitmap2);
		 * </listing>
		 * 
		 * @param	Bitmap	The bitmap to copy.
		 * @return	The copied bitmap.
		 */
		public static function CopyBitmap(bitmapToCopy:Bitmap):Bitmap
		{
			var b:Bitmap = new Bitmap(bitmapToCopy.bitmapData);
			return b;
		}
	}
}
