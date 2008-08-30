package net.guttershark.support.servicemanager.remoting.events
{
	import flash.events.Event;	

	/**
	 * ConnectionEvent is dispatched from RemotingConnection for 
	 * any events that occur from attempting to connect to the 
	 * remoting gateway.
	 */
	public class ConnectionEvent extends Event
	{
		
		/**
		 * Dispatched when the RemotingConnection has successfully
		 * connected.
		 */
		public static const CONNECTED:String = "connected";
		
		/**
		 * Dispatched when the connection was disconnected.
		 */
		public static const DISCONNECT:String = "disconnect";
		
		/**
		 * Dispatched when the connection failed.
		 */
		public static const FAILED:String = "failed";

		/**
		 * Dispatched when the RemotingConnection has some ambiguous error.
		 */
		public static const ERROR:String = "error";
		
		/**
		 * Dispatched when a security error happens.
		 */
		public static const SECURITY_ERROR:String = "securityError";
		
		/**
		 * Dispatched when AMF Version errors happen.
		 */
		public static const FORMAT_ERROR:String = "formatError";
		
		/**
		 * The message from the event / error.
		 */
		public var message:String;
		
		/**
		 * New ConnectionEvent
		 * 
		 * @param		String		event type
		 * @param		Boolean		bubbles	
		 * @param		Boolean		cancelable
		 */
		public function ConnectionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type,bubbles,cancelable);
		}
	}
}