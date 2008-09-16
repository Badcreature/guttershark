package net.guttershark.remoting.events
{
	import net.guttershark.remoting.RemotingService;	
	import net.guttershark.remoting.RemotingConnection;	
	import net.guttershark.remoting.events.CallEvent;	

	/**
	 * The IRemotingEventsDelegate creates the contract for an object
	 * that wants to be a delegate for all events from RemotingConnection
	 * or RemotingService objects that are created within a RemotingManager.
	 *
	 * @see net.guttershark.remoting.RemotingManager#remotingEventsDelegate;
	 */
	public interface IRemotingEventsDelegate 
	{
		
		/**
		 * Handler for a connection event.
		 */
		function onConnect(ce:ConnectionEvent):void;
		
		/**
		 * Handler for a disconnect event.
		 */
		function onDisconnect(ce:ConnectionEvent):void;
		
		/**
		 * Handler for a connection fail event.
		 */
		function onConnectionFail(ce:ConnectionEvent):void;
		
		/**
		 * Handler for a connection security error event.
		 */
		function onConnectionSecurityError(ce:ConnectionEvent):void;
		
		/**
		 * Handler for a connection format error event. This is an error when something
		 * triggers the server into thinking the AMF is not 0 or 3.
		 */
		function onConnectionFormatError(ce:ConnectionEvent):void;
		
		/**
		 * Handler for a remoting service's retry event.
		 */
		function onRetry(callEvent:CallEvent):void;
		
		/**
		 * Handler for a remoting service's retry event.
		 */
		function onTimeout(callEvent:CallEvent):void;
		
		/**
		 * Handler for a remoting service's request sent event.
		 */
		function onRequestSent(callEvent:CallEvent):void;
		
		/**
		 * Handler for a remoting services call limited event.
		 */
		function onCallLimited(callEvent:CallEvent):void;
		
		/**
		 * Handler for when all RemotingService's have been halted.
		 */
		function onServicesHalted():void;	}}