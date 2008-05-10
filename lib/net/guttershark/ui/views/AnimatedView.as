package net.guttershark.ui.views 
{
	import net.guttershark.util.FramePulse;	
	
	import flash.events.Event;	

	import net.guttershark.ui.views.BasicView;
	
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
		 * Sub method used for naming convention. Override this method
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
		 * Stub method used for naming conection. Override this method
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
			_watchEndAndComplete = value;
			if(!value && listenerAdded) FramePulse.RemoveEnterFrameListener(__onEnterFrame);
			if(value && !listenerAdded)
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
		 * on enter frame handler
		 */
		private function __onEnterFrame(e:Event):void
		{
			if(currentFrame == totalFrames) animationComplete();
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
