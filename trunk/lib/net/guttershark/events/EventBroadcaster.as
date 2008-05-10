package net.guttershark.events
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * The EventBroadcaster is a static class, and wraps one instance of
	 * an event dispatcher and has static methods to work with that
	 * single instance of the event dispatcher.
	 * 
	 * @example	Using the EventBroadcaster
	 * <listing>	
	 * private function onTest(e:Event):void
	 * {
	 *   trace("event received");
	 * }
	 * EventBroadcaster.addEventListener("test",onTest); 
	 * EventBroadcaster.broadcastEvent(new Event("test"));
	 * </listing>
	 */
	public class EventBroadcaster
	{
		
		private static var dispatcher:EventDispatcher = new EventDispatcher();
		
		/**
		 * Add a listener the the event broadcaster.
		 * 
		 * @param	String		The type of event listener
		 * @param	Function	The callback function when event is fired
		 * @param	Boolean		UseCapture or not.
		 * @param	int			Priority of the event.
		 * @param	Boolean		Use weak references.
		 */
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean = false):void
		{
			dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		/**
		 * Broadcast an event.
		 * 
		 * @param		Event		Any Event.
		 */
		public static function broadcastEvent(event:Event):void
		{
			dispatcher.dispatchEvent(event);
		}
		
		/**
		 * Remove an event listener from the broadcaster.
		 * 
		 * @param		String		The listener type.
		 * @param		Function	The callback listening function.
		 * @param		Boolean		UseCapture of not.
		 */
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			dispatcher.removeEventListener(type,listener,useCapture);
		}
		
		/**
		 * Check to see if there is a listener of specified type on the broadcaster.
		 * 
		 * @param	type	The event type.
		 */
		public static function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		/**
		 * Test to see if an event will fire of type.
		 * 
		 * @param	type	The event type.
		 */
		public static function willTrigger(type:String):Boolean
		{
			return dispatcher.willTrigger(type);
		}
	}
}