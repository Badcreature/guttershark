package net.guttershark.util
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import net.guttershark.util.Singleton;		

	/**
	 * The MouseUtils class has utility methods for working with mouse positions.
	 */
	final public class MouseUtils
	{
		
		/**
		 * singleton instance.
		 */
		private static var inst:MouseUtils;
		
		/**
		 * Singleton access.
		 */
		public static function gi():MouseUtils
		{
			if(!inst) inst = Singleton.gi(MouseUtils);
			return inst;
		}
		
		/**
		 * @private
		 */
		public function MouseUtils()
		{
			Singleton.assertSingle(MouseUtils);
		}

		/**
		 * Check to see if the mouse is within the bounds of a rectangle.
		 * 
		 * @param scope The scope of mouse coordinates to use.
		 * @param rectangle The bounds in wich to check the mouse position against.
		 */
		public function inRectangle(scope:DisplayObject, rectangle:Rectangle):Boolean
		{
			if(!scope) throw new ArgumentError("Parameter scope cannot be null.");
			if(!rectangle) throw new ArgumentError("Parameter rectangle cannot be null");
			var ym:Number = scope.mouseY;
			var xm:Number = scope.mouseX;
			if(xm > rectangle.x && xm < rectangle.right && ym > rectangle.y && ym < rectangle.bottom) return true;
			return false;
		}
	}
}