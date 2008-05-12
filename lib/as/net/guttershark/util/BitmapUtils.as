package net.guttershark.util 
{
	
	import flash.display.Bitmap;
	
	/**
	 * The BitmapUtils class has utility methods for easy access to common Bitmap operations.
	 */
	public class BitmapUtils 
	{
	
		/**
		 * Copy a Bitmap.
		 * 
		 * @example Copying a bitmap.
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
			Assert.NotNull(bitmapToCopy, "Parameter bitmapToCopy cannot be null");
			var b:Bitmap = new Bitmap(bitmapToCopy.bitmapData);
			return b;
		}
	}
}
