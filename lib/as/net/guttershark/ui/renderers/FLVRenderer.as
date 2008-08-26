package net.guttershark.ui.renderers 
{
	import net.guttershark.core.CoreClip;	
	
	public class FLVRenderer extends CoreClip 
	{
		
		public var player:*;
		private var _d:*;
		
		public function set delegate(del:*):void
		{
			_d = del;
		}	}}