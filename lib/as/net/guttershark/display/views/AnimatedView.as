package net.guttershark.display.views 
{
	import flash.events.Event;
	
	import net.guttershark.display.views.BasicView;
	import net.guttershark.util.Assert;
	import net.guttershark.util.FrameDelay;
	import net.guttershark.util.FramePulse;	

	/**
	 * The AnimatedView class provides structure to a class
	 * where views need to have animated timelines, rather
	 * than all code tweened timelines.
	 * 
	 * <p>You would extend your movie clip with this class, and on
	 * the timeline in flash, make simple method calls that have 
	 * the code implemented in this class.</p>
	 */
	public class AnimatedView extends BasicView
	{
		
		private var _watchEndAndComplete:Boolean;
		private var listenerAdded:Boolean;
		private var _autoStop:Boolean;
		
		public function AnimatedView()
		{
			super();
		}
		
		/**
		 * Stub method used for naming convention. Use this method
		 * as a mechanism for updating children references in the display
		 * list.
		 * 
		 * <p>The reason you would need to update references is when
		 * there are clips that animate on the timeline, but don't
		 * always have an instance name associated with it, so on some
		 * frames you need to update the references so you can control them.</p>
		 */
		protected function updateChildrenReferences():void{}
		
		/**
		 * Stub method used for naming convention. Override this method
		 * when something from the timeline needs to execute something
		 * on it's animation completion / last frame.
		 * 
		 * <p>Overriding this method allows you to place your logic here,
		 * instead of on the timeline. Then in your timeline, you make a
		 * call to <code>this.animationComplete();</code></p>
		 * 
		 * <p>Extend a movie clip from this class, then on the timeline you
		 * can place <code>this.animationComplete();</code> method calls
		 * anywhere in the timeline to execute this method.</p>
		 */
		protected function animationComplete():void{}
		
		/**
		 * Stub method used for naming convention. Override this method
		 * when something from the timeline needs to happen right when
		 * the timeline starts playing.
		 * 
		 * <p>Extend a movie clip from this class, then on the timeline you
		 * can place <code>this.animationStart();</code> method calls
		 * anywhere in the timeline to execute this method.</p>
		 */
		protected function animationStart():void{}
		
		/**
		 * Set this property to true to automatically call the <code>animationComplete</code>
		 * method when this movie clip hits it's last frame. 
		 */
		public function set watchForLastFrameAndCallComplete(value:Boolean):void
		{
			Assert.NotNull(value, "Value cannot be null");
			if(!value && listenerAdded)
			{
				listenerAdded = false;
				FramePulse.RemoveEnterFrameListener(__onEnterFrame);
			}
			else if(value && !listenerAdded)
			{
				listenerAdded = true;
				FramePulse.AddEnterFrameListener(__onEnterFrame);
			}
		}
		
		/**
		 * Get the value of the watch for end frame and call complete flag.
		 */
		public function get watchForLastFrameAndCallComplete():Boolean
		{
			return _watchEndAndComplete;
		}
		
		/**
		 * Auto stop on the last frame of this movie clip.
		 */
		public function set autoStopOnLastFrame(value:Boolean):void
		{
			_autoStop = value;
		}
		
		/**
		 * Overrides the play method to add some logic for reverse playing
		 * and the animationStart method.
		 */
		override public function play():void
		{
			if(!listenerAdded)
			{
				FramePulse.AddEnterFrameListener(__onEnterFrame);
				listenerAdded = true;
			}
			var f:FrameDelay = new FrameDelay(animationStart,2);
			super.play();
			f.dispose();
		}
		
		/**
		 * on enter frame handler
		 */
		private function __onEnterFrame(e:Event):void
		{
			if(currentFrame == totalFrames)
			{
				if(_autoStop) stop();
				listenerAdded = false;
				FramePulse.RemoveEnterFrameListener(__onEnterFrame);
				var f:FrameDelay = new FrameDelay(animationComplete,1);
				f.dispose();
			}
		}
		
		/**
		 * Play this clip in reverse.
		 */
		public function playReverse():void
		{
			FramePulse.AddEnterFrameListener(eventForReverse);
		}
		
		/**
		 * plays reverse.
		 */
		private function eventForReverse(e:Event):void
		{
			this.gotoAndStop(Math.max(1,currentFrame-1));
			if(currentFrame == 1) FramePulse.RemoveEnterFrameListener(eventForReverse);
		}

		/**
		 * Dispose of internal variables and event listeners.
		 */
		override public function dispose():void
		{
			if(listenerAdded) FramePulse.RemoveEnterFrameListener(__onEnterFrame);
			listenerAdded = false;
		}
	}
}
