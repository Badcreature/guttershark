package net.guttershark.util 
{
	public class MathUtils 
	{
		
		public static function ConstrainedResize(targetWidth:Number, targetHeight:Number, currentWidth:Number, currentHeight:Number):Object
		{
			var hx:Number;
			var wx:Number;
			var sw:Number = currentWidth;
			var sh:Number = currentHeight;
			var w:Number = 110;
			var h:Number = 110;
			hx = (100 / (sw / w)) * .01;
			hx = Math.round((sh * hx));
			wx = (100 / (sh / h)) * .01;
			wx = Math.round((sw * wx));	
			if(hx < h)
			{					
				h = (100 / (sw / w)) * .01;
				h = Math.round((sh * h));
			}
			else
			{
				w = (100 / (sh / h)) * .01;
				w = Math.round((sw * w));
			}
			return {w:w,h:h};
		}	}}