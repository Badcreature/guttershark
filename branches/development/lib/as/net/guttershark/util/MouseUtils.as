package net.guttershark.util
{
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * The MouseUtils class has utility methods for working with mouse positions.
	 */
	public class MouseUtils
	{
		
		/**
		 * Check to see if the mouse is within the bounds of a rectangle.
		 * 
		 * @param	DisplayObject	The scope of mouse coordinates to use.
		 * @param	Rectangle	The bounds in wich to check the mouse position against.
		 * @throws	ArgumentError	Error if scope, or rectangle are not provided.
		 * @return	Boolean
		 */
		public static function IsMouseInRectangle(scope:DisplayObject, rectangle:Rectangle):Boolean
		{
			Assert.NotNull(scope, "Parameter scope cannot be null.");
			Assert.NotNull(rectangle, "Parameter rectangle cannot be null");
			var ym:Number = scope.mouseY;
			var xm:Number = scope.mouseX;
			if(xm > rectangle.x && xm < rectangle.right && ym > rectangle.y && ym < rectangle.bottom) return true;
			return false;
		}
	}
}