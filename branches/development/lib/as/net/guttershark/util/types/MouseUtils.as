package net.guttershark.util.types
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;	

	/**
	 * The MouseUtils class has utility methods for working with mouse positions.
	 */
	final public class MouseUtils
	{
		
		/**
		 * Check to see if the mouse is within the bounds of a rectangle.
		 * 
		 * @param DisplayObject The scope of mouse coordinates to use.
		 * @param Rectangle The bounds in wich to check the mouse position against.
		 */
		public static function IsMouseInRectangle(scope:DisplayObject, rectangle:Rectangle):Boolean
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