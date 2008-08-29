package net.guttershark.display.renderers 
{
	import net.guttershark.core.CoreClip;	
	
	/**
	 * IN DEVELOPMENT.
	 */
	public class FLVRenderer extends CoreClip 
	{
		
		public var player:*;
		private var _d:*;
		
		public function set delegate(del:*):void
		{
			_d = del;
		}	}}