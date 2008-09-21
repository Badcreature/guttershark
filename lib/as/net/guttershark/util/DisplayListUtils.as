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
		}
		
		/**
		 * 
		 */
		public function localToContainerLocal(from:DisplayObject, to:DisplayObject):Point
		{
			var point:Point = new Point();
			point = from.localToGlobal(point);
			point = to.parent.globalToLocal(point);
			return point;
		}
		
		/**
		 * Set the scale of an object; this updates the scale for both x and y.
		 * 
		 * @param item The target item to scale. 
		 * @param scale	The scale percentage.
		 */
		public function scale(item:DisplayObject,scale:Number):void 
		{
			item.scaleX = scale;
			item.scaleY = scale;
		}

		/**
		 * Scale target item to fit within target confines.
		 * 
		 * @param item The item to be aligned.
		 * @param targetW The target item width.
		 * @param targetH The target item height.
		 * @param center Center the object within the targetW and targetH.
		 */
		public function scaleToFit(item:DisplayObject,targetW:Number,targetH:Number,center:Boolean):void
		{
			if(item.width<targetW && item.width>item.height)
			{
				item.width = targetW;
				item.scaleY = item.scaleX;
			}
			else
			{
				item.height = targetH;
				item.scaleX = item.scaleY;
			}
			if(center) 
			{
				item.x = int(targetW/2-item.width/2);
				item.y = int(targetH/2-item.height/2);
			}
		}

		/**
		 * Scale while retaining original w:h ratio.
		 * 
		 * @param item The item to be scaled.
		 * @param targetW The target item width.
		 * @param targetH The target item height.
		 */
		public function scaleRatio(item:DisplayObject,targetW:Number,targetH:Number):void
		{
			if(targetW/targetH<item.height/item.width) targetW = targetH * item.width / item.height; 
			else targetH = targetW * item.height / item.width;
			item.width = targetW;
			item.height = targetH;
		}

		/**
		 * Flip an object on the x or y axis.
		 * 
		 * @param obj The object to flip
		 * @param axis The axis to flip on - "x" or "y"
		 */
		public function flip(obj:Object,axis:String="y"):void
		{
			if(axis != "x" && axis != "y") 
			{
				throw new Error("Error: flip expects axis param: 'x' or 'y'.");
				return;
			}
			var _scale:String = axis == "x" ? "scaleX" :"scaleY";
			var _prop:String = axis == "x" ? "width" : "height";
			obj[_scale] = -obj[_scale];
			obj[axis] += obj[_prop];
		}	}}