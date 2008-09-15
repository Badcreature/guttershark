package net.guttershark.util.types 
{
	import net.guttershark.util.Singleton;	

	import flash.display.Bitmap;
	
	/**
	 * The BitmapUtils class has utility methods for easy access to common Bitmap operations.
	 */
	final public class BitmapUtils
	{
	
		/**
		 * Singleton instance.
		 */
		private static var inst:BitmapUtils;
		
		/**
		 * Singleton access.
		 */
		public static function gi():BitmapUtils
		{
			if(!inst) inst = Singleton.gi(BitmapUtils);
			return inst;
		}
		
		/**
		 * @private
		 */
		public function BitmapUtils()
		{
			Singleton.assertSingle(BitmapUtils);
		}

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
		 * @param bitmapToCopy The bitmap to copy.
		 */
		public function copyBitmap(bitmapToCopy:Bitmap):Bitmap
		{
			if(!bitmapToCopy) throw new ArgumentError("Parameter bitmapToCopy cannot be null");
			var b:Bitmap = new Bitmap(bitmapToCopy.bitmapData);
			return b;
		}
	}
}
