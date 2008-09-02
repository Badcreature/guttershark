package net.guttershark.util.display {	import flash.geom.Point;	import flash.display.DisplayObject;		/**	 * CoordinateTool provides basic coordinate translation and management utilities.	 */	public class CoordinateTool 	{		/**		 * Translate <code>DisplayObject</code> container position in a new container.		 */		public static function localToLocal(from:DisplayObject, to:DisplayObject):Point 		{			var point:Point = new Point();			point = from.localToGlobal(point);			point = to.globalToLocal(point);			return point;		}	}}