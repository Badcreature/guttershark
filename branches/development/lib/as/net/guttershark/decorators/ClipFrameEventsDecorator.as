package net.guttershark.decorators 
{
	import flash.display.MovieClip;
	
	public dynamic class ClipFrameEventsDecorator 
	{
		
		//public var onFrame32
		private var _clip:MovieClip;
		public var frameDelay:Number;
		public var onLastFrame:Function;
		public var onFirstFrame:Function;
		public var onStop:Function;
		public var onPlay:Function;
		
		public function ClipFrameEventsDecorator(clip:MovieClip,dynamicFrameCallbacks:Boolean=false)
		{
			_clip=clip;
		}	}}