package net.guttershark.decorators 
{
	import flash.display.MovieClip;
	import flash.events.Event;	

	/**
	 * The ReversableClip class decorates a
	 * movie clip with play in reverse functionality.
	 * 
	 * @example Decorating a movie clip with reversable clip:
	 * <listing>	
	 * var myClip:MovieClip;
	 * var rm:ReversableMovieClip=new ReversableMovieClip(myClip);
	 * myClip.gotoAndStop(myClip.totalFrames);
	 * rm.playReverse();
	 * </listing>
	 */
	final public class ReversableClip
	{
		
		/**
		 * The clip being decorated.
		 */	
		private var clip:MovieClip;
		
		/**
		 * Constructor for ReversableClip instances.
		 * 
		 * @param clip The movie clip to decorate.
		 */
		public function ReversableClip(clip:MovieClip)
		{
			this.clip=clip;
		}
		
		/**
		 * Play the movie clip in reverse.
		 */
		public function playReverse():void
		{
			clip.addEventListener(Event.ENTER_FRAME,onEnterFrame,false,0,true);
		}
		
		/**
		 * on enter frame of clip.
		 */
		private function onEnterFrame(e:Event):void
		{
			if(clip.currentFrame==1)
			{
				clip.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				return;
			}
			clip.gotoAndPlay(clip.currentFrame-1);
		}
		
		/**
		 * Dispose of this decorator.
		 */
		public function dispose():void
		{
			if(!clip)return;
			clip.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			clip=null;
		}	}}