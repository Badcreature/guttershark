package net.guttershark.util 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;	

	/**
	 * The DisplayListUtils class contains utlility methods for display
	 * list manipulation.
	 * 
	 * @see net.guttershark.util.Utilities Utilities class.
	 */
	final public class DisplayListUtils
	{
		
		/**
		 * Singleton instance.
		 */
		private static var inst:DisplayListUtils;
		
		/**
		 * Singleton access.
		 */
		public static function gi():DisplayListUtils
		{
			if(!inst) inst = Singleton.gi(DisplayListUtils);
			return inst;
		}
		
		/**
		 * @private
		 */
		public function DisplayListUtils()
		{
			Singleton.assertSingle(DisplayListUtils);
		}

		/**
		 * Translate the <code>DisplayObject</code> container position in a new container.
		 */
		public function localToLocal(from:DisplayObject, to:DisplayObject):Point
		{
			var point:Point = new Point();
			point = from.localToGlobal(point);
			point = to.globalToLocal(point);
			return point;
		}	}}