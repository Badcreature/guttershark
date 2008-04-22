package net.guttershark.effects.stencils.pixel 
{	
	
	/**
	 * The Pixel class represents a pixel that was read from the initial stencil scan.
	 * Values from that read are wrapped in this class for easier access.
	 */
	public class Pixel
	{
		
		public var x:int;
		public var y:int;
		public var value:uint;
		public var alpha:uint;
		public var red:uint;
		public var green:uint;
		public var blue:uint;
		public var pixelCount:int;
		
		public function Pixel(x:int, y:int,value:uint, alpha:uint, red:uint, green:uint, blue:uint,count:int)
		{
			this.x = x;
			this.y = y;
			this.value = value;
			this.alpha = alpha;
			this.red = red;
			this.green = green;
			this.blue = blue;
			this.pixelCount = count;
		}
	}
}
