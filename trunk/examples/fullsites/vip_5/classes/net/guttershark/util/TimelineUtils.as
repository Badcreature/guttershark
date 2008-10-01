package net.guttershark.util 
{
	
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class TimelineUtils
	{
		
		public static function StopClipOnLastFrame(clip:MovieClip):void
		{
			clip.addEventListener(Event.ENTER_FRAME, onClipFrame);
		}

		private static function onClipFrame(e:Event):void
		{
			var clip:MovieClip = MovieClip(e.target);
			if(clip.currentFrame == clip.totalFrames)
			{
				clip.stop();
				clip.removeEventListener(Event.ENTER_FRAME,onClipFrame);
			}
		}
		
		public static function PlayClipInReverse(clip:MovieClip):void
		{
			clip.addEventListener(Event.ENTER_FRAME, onClipFrameForReverse);
			clip.gotoAndStop(clip.currentFrame - 1);
		}
		
		private static function onClipFrameForReverse(e:Event):void
		{
			var clip:MovieClip = MovieClip(e.target);
			if(clip.currentFrame == 1)
			{
				clip.removeEventListener(Event.ENTER_FRAME,onClipFrameForReverse);
				return;
			}
			clip.gotoAndStop(clip.currentFrame - 1);
		}	}}