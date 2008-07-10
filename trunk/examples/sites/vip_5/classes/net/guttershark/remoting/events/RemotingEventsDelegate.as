package net.guttershark.remoting.events
{
	
	import net.guttershark.remoting.events.CallEvent;	
	
	/**
	 * The RemotingEventsDelegate class is a super implementation of
	 * the IRemotingEventsInterface. This is in place so you can extend it
	 * and just override whatever methods you want, intead of having to
	 * implement every single method.
	 */
	public class RemotingEventsDelegate implements IRemotingEventsDelegate 
	{
		
		/**
		 * Handler for a connection event.
		 */
		public function onConnect(ce:ConnectionEvent):void{}
		
		/**
		 * Handler for a disconnect event.
		 */
		public function onDisconnect(ce:ConnectionEvent):void{}
		
		/**
		 * Handler for a connection fail event.
		 */
		public function onConnectionFail(ce:ConnectionEvent):void{}
		
		/**
		 * Handler for a connection security error event.
		 */
		public function onConnectionSecurityError(ce:ConnectionEvent):void{}
		
		/**
		 * Handler for a connection format error event. This is an error when something
		 * triggers the server into thinking the AMF is not 0 or 3.
		 */
		public function onConnectionFormatError(ce:ConnectionEvent):void{}
		
		/**
		 * Handler for a remoting service's retry event.
		 */
		public function onRetry(callEvent:CallEvent):void{}
		
		/**
		 * Handler for a remoting service's retry event.
		 */
		public function onTimeout(callEvent:CallEvent):void{}
		
		/**
		 * Handler for a remoting service's request sent event.
		 */
		public function onRequestSent(callEvent:CallEvent):void{}
		
		/**
		 * Handler for a remoting services call limited event.
		 */
		public function onCallLimited(callEvent:CallEvent):void{}
		
		/**
		 * Handler for when all RemotingService's have been halted.
		 */
		public function onServicesHalted():void{}			}}