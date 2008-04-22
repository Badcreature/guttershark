/**
	Collision detection by Frederik Humblet
	(c) Boulevart N.V.
	http://labs.boulevart.be
	
	Port from the AS2 version by Grant Skinner
	http://www.gskinner.com/blog/archives/2005/08/flash_8_shape_b.html
 */
package com.gskinner{
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	public class Collision 	{
		public function getCollision(target1:DisplayObject,target2:DisplayObject,tollerance:Number = 0):Rectangle 		{
			var res:Rectangle;
			if (target1.parent == target2.parent) 			{
				var par:DisplayObjectContainer = target1.parent;
				var rect1:Rectangle = target1.getBounds(par);
				var rect2:Rectangle = target2.getBounds(par);
				var isIntersecting:Boolean = rect1.intersects(rect2);
				if (isIntersecting) 				{
					var combinedrect:Rectangle = rect1.union(rect2);
					var alpha1:BitmapData = getAlphaMap(target1,combinedrect,BitmapDataChannel.RED,rect1);
					var alpha2:BitmapData = getAlphaMap(target2,combinedrect,BitmapDataChannel.GREEN,rect2);
					alpha1.draw(alpha2,new Matrix,new ColorTransform(),BlendMode.LIGHTEN);
					if (tollerance > 1) 					{
						tollerance = 1;
					}
					if (tollerance < 0) 					{
						tollerance = 0;
					}
					var colorsearch:uint;
					if (tollerance == 0) 					{
						colorsearch = 0x010100;
					} else 					{
						var tollByte:Number = Math.round(tollerance * 255);
						colorsearch = (tollByte << 16) | (tollByte << 8) | 0;
					}
					res = alpha1.getColorBoundsRect(colorsearch,colorsearch);
					res.x += combinedrect.x;
					res.y += combinedrect.y;
					return res;
				}
			}
			return res;
		}
		private function getAlphaMap(target:DisplayObject,rect:Rectangle,channel:uint,myrect:Rectangle):BitmapData 		{
			var bmd:BitmapData = new BitmapData(rect.width,rect.height,true,0);
			var m:Matrix = new Matrix();
			var offX:Number = target.x - myrect.x;
			var offY:Number = target.y - myrect.y;
			var xpos:Number = myrect.x + offX - rect.x;
			var ypos:Number = myrect.y + offY - rect.y;
			m.translate(xpos,ypos);
			bmd.draw(target,m);
			var alphachannel:BitmapData = new BitmapData(rect.width,rect.height,false,0);

			alphachannel.copyChannel(bmd,bmd.rect,new Point(0,0),BitmapDataChannel.ALPHA,channel);
			return alphachannel;
		}
		public function getCollisionPoint(target1:DisplayObject,target2:DisplayObject,tollerance:Number = 0):Point 		{
			var pt:Point;
			var collisionRect:Rectangle = getCollision(target1,target2,tollerance);
			if (collisionRect != null && collisionRect.size.length > 0) 			{
				var xcoord:Number = (collisionRect.left + collisionRect.right) / 2;
				var ycoord:Number = (collisionRect.top + collisionRect.bottom) / 2;
				pt = new Point(xcoord,ycoord);
			}
			return pt;
		}
		public function isColliding(target1:DisplayObject,target2:DisplayObject,tollerance:Number = 0):Boolean 		{
			var collisionRect:Rectangle = getCollision(target1,target2,tollerance);
			if (collisionRect != null && collisionRect.size.length > 0) 			{
				return true;
			} else 			{
				return false;
			}
		}
	}
}