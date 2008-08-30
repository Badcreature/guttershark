package net.guttershark.services.remoting.events
{
	import flash.events.ErrorEvent;	

	/**
	 * A fault object wrapper for any faulty remoting request.
	 */
	public class FaultEvent extends ErrorEvent
	{
		
		/**
		 * Fault identifier.
		 */
		public static const FAULT:String = "fault";
		
		/**
		 * The raw fault object from the server.
		 */
		public var fault:Object;
		
		/**
		 * New FaultEvent
		 * 
		 * @param		String		event type
		 * @param		Boolean		bubbles
		 * @param		Boolean		cancelable
		 * @param		Object		The raw object from the fault response.
		 */
		public function FaultEvent(fault:Object, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(FaultEvent.FAULT, bubbles, cancelable);
			this.fault = fault;
		}
	}
}