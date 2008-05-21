package net.guttershark.remoting.events
{
	
	import flash.events.Event;
	
	import net.guttershark.remoting.RemotingConnection;
	import net.guttershark.remoting.RemotingService;

	public class CallEvent extends Event
	{
		
		/**
		 * When a remoting request was sent, this is dispatched from
		 * RemotingService
		 */
		public static const REQUEST_SENT:String = "requestSent";
		
		/**
		 * @private
		 * When a result has been received, this is dispatched from RemotingService.
		 */
		public static const RESULT:String = "result";
		
		/**
		 * @private
		 * When a remoting call fails, this is dispatched from RemotingService
		 */
		public static const FAULT:String = "fault";
		
		/**
		 * When a remoting call is retrying. Dispatched from RemotingService
		 */
		public static const RETRY:String = "retry";
		
		/**
		 * Dispatched when a remoting call times-out.
		 */
		public static const TIMEOUT:String = "timedout";
		
		/**
		 * Dispatched from RemotingService when a limiter is in place and a 
		 * call was blocked from going to the server.
		 */
		public static const LIMITER_STOPPED_CALL:String = "limiterStoppedCall";
		
		/**
		 * Dispatched when the total timeouts reaches the maximum timeouts before a halt.
		 */
		public static const SERVICE_HALTED:String = "serviceHalted";
		
		/**
		 * The connection used for the call.
		 */
		public var connection:RemotingConnection;
		
		/**
		 * The RemotingService used for the call.
		 */
		public var service:RemotingService;
		
		/**
		 * The method called.
		 */
		public var method:String;
		
		/**
		 * The args sent
		 */
		public var args:Array;
		
		/**
		 * The raw response data.
		 */
		public var rawData:*;
		
		/**
		 * The result callback function.
		 */
		public var resultCallback:Function;
		
		/**
		 * The fault callback function
		 */
		public var faultCallback:Function;
		
		/**
		 * New CallEvent
		 * 
		 * @param		String			event type
		 * @param		Boolean			bubbles
		 * @param		Boolean			cancelable
		 */
		public function CallEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);
		}
	}
}