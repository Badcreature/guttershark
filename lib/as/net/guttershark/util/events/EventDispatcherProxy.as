package net.guttershark.util.events 
{
	
	import flash.events.Event;	
	import flash.events.EventDispatcher;	
	import flash.events.IEventDispatcher;	
	
	/**
	 * The EventDispatcherProxy class is used internally to classes that
	 * have custom event listener methods, but need to use an event
	 * dispatcher internally.
	 * 
	 * <p>The best example of this is the RemotingManager class.</p>
	 */
	public class EventDispatcherProxy implements IEventDispatcher 
	{
		
		private var ed:EventDispatcher;

		public function EventDispatcherProxy():void
		{
			ed = new EventDispatcher(this);
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			ed.addEventListener(type, listener,useCapture, priority,useWeakReference);
		}
		
		public function removeEventListener(type:String,listener:Function,useCapture:Boolean = false):void
		{
			ed.removeEventListener(type, listener);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return ed.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return ed.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return ed.willTrigger(type);
		}			}}