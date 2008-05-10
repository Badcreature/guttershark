package net.guttershark.util 
{
	
	import flash.events.Event;	
	import flash.display.Sprite;	
	import flash.events.EventDispatcher;	
	
	/**
	 * The FramePulse class should be used as the one
	 * source for enter frame events. This is equivalent
	 * to an on enter frame beacon from flash 7/8.
	 */
	public class FramePulse extends EventDispatcher
	{
		
		private static var sSprite:Sprite = null;

		/**
		 * Add a listener to the frame pulse.
		 * @param	eventHandler	The handler function to call.
		 */
		public static function AddEnterFrameListener(eventHandler:Function):void
		{
			if(sSprite == null) sSprite = new Sprite();
			sSprite.addEventListener(Event.ENTER_FRAME, eventHandler);
		}
		
		/**
		 * Remove an event listener from the frame pulse.
		 * @param	eventHandler	The event handler function.
		 */
		public static function RemoveEnterFrameListener(eventHandler:Function):void
		{
			if(sSprite != null) sSprite.removeEventListener(Event.ENTER_FRAME, eventHandler);
		}
	}
}