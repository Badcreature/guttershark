package net.guttershark.util
{
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * The MousePositionUtils class has utility methods for working with mouse positions.
	 */
	public class MousePositionUtils
	{
		
		/**
		 * Check to see if the mouse is within the bounds of a rectangle.
		 * 
		 * @param	DisplayObject	The scope of mouse coordinates to use.
		 * @param	Rectangle	The bounds in wich to check the mouse position agains
		 * 
		 * @throws	ArgumentError	Error if scope, or rectangle are not provided
		 * 
		 * @return	Boolean
		 */
		public static function IsMouseInRectangle(scope:DisplayObject, rectangle:Rectangle):Boolean
		{
			if(!scope) throw new ArgumentError("You must provide a scope to check the mouse position in.");
			if(!rectangle) throw new ArgumentError("No rectange was supplied for the bounds.");
			var ym:Number = scope.mouseY;
			var xm:Number = scope.mouseX;
			if(xm > rectangle.x && xm < rectangle.right && ym > rectangle.y && ym < rectangle.bottom) return true;
			return false;
		}
	}
}