package net.guttershark.remoting
{

	import flash.events.*;
	import flash.net.NetConnection;
	
	import net.guttershark.remoting.events.ConnectionEvent;
	import net.guttershark.core.IDisposable;
	
	/**
	 * Dispatched when a connection is successful.
	 * 
	 * @eventType net.guttershark.remoting.events.ConnectionEvent
	 */
	 [Event("connected", type="net.guttershark.remoting.events.ConnectionEvent")]
	
	/**
	 * Dispatched when a connection fails.
	 * 
	 * @eventType net.guttershark.remoting.events.ConnectionEvent
	 */
	 [Event("failed", type="net.guttershark.remoting.events.ConnectionEvent")]
	
	/**
	 * Dispatched when a connection disconnects.
	 * 
	 * @eventType net.guttershark.remoting.events.ConnectionEvent
	 */
	 [Event("disconnect", type="net.guttershark.remoting.events.ConnectionEvent")]
	
	/**
	 * Dispatched when a security error occurs.
	 * 
	 * @eventType net.guttershark.remoting.events.ConnectionEvent
	 */
	 [Event("securityError", type="net.guttershark.remoting.events.ConnectionEvent")]
	
	/**
	 * Dispatched when an AMF format error occurs.
	 * 
	 * @eventType net.guttershark.remoting.events.ConnectionEvent
	 */
	 [Event("formatError", type="net.guttershark.remoting.events.ConnectionEvent")]
	
	/**
	 * The RemotingConnection class simplifies connecting a net connection to 
	 * a Flash Remoting gateway.
	 * 
	 * <p>The RemotingConnection class must be used to connect to the
	 * gateway, and then given to a RemotingService instance.</p>
	 * 
	 * @see net.guttershark.remoting.RemotingService
	 */
	public class RemotingConnection extends EventDispatcher implements IDisposable
	{	

		/**
		 * The gateway URL.
		 */
		public var gateway:String;
		
		/**
		 * The net connection object used to connect.
		 */
		public var connection:NetConnection;
		
		/**
		 * Constructor for RemotingConnection instances.
		 * 
		 * @param	gateway	The remoting gateway URL.
		 * @param	objectEncoding	The AMF Object encoding.
		 * @throws	ArgumentError	If the gateway parameter was null.
		 * @throws	ArgumentError	IF the objectEncoding is not 0 or 3.
		 */
		public function RemotingConnection(gateway:String, objectEncoding:int = 3)
		{
			if(gateway == '') throw new ArgumentError("Gateway cannot be null");
			if(objectEncoding != 0 && objectEncoding != 3) throw new ArgumentError("Object encoding must be 0 or 3");
			this.gateway = gateway;
			connection = new NetConnection();
			connection.objectEncoding = objectEncoding;
			connection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
			connection.addEventListener(IOErrorEvent.IO_ERROR, onConnectionError);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR , onConnectionError);
			connection.connect(gateway);
		}
		
		/**
		 * onConnectionError
		 */
		private function onConnectionError(event:ErrorEvent):void
		{
			connection.close();
			connection = null;
			var ce:ConnectionEvent = new ConnectionEvent(ConnectionEvent.ERROR);
			ce.message = event.text;
			dispatchEvent(ce);
		}
		
		/**
		 * onConnectionStatus
		 */
		private function onConnectionStatus(event:NetStatusEvent):void
		{
			var ce:ConnectionEvent;
			switch(event.info.code)
			{
				case "NetConnection.Connect.Success":
					ce = new ConnectionEvent(ConnectionEvent.CONNECTED);
					ce.message = event.info.code;
					dispatchEvent(ce);
					break;
				case "NetConnection.Connect.Failed":
					ce = new ConnectionEvent(ConnectionEvent.FAILED);
					dispatchEvent(ce);
					break;
				case "NetConnection.Call.BadVersion":
					ce = new ConnectionEvent(ConnectionEvent.FORMAT_ERROR);
					dispatchEvent(ce);
					break;
				case "NetConnection.Call.Prohibited":
					ce = new ConnectionEvent(ConnectionEvent.SECURITY_ERROR);
					ce.message = event.info.code;
					dispatchEvent(ce);
					break;
				case "NetConnection.Connect.Closed":
					ce = new ConnectionEvent(ConnectionEvent.DISCONNECT);
					ce.message = event.info.code;
					dispatchEvent(ce);
					break;
			}
		}
		
		/**
		 * Dispose of this RemotingConnection.
		 */
		public function dispose():void
		{
			connection.close();
			connection = null;
			gateway = null;
		}

		/**
		 * Check whether or not the connection is currently established.
		 * 
		 * @return	Boolean
		 */
		public function get connected():Boolean
		{
			return connection.connected;
		}
		
		/**
		 * Re-connect the net connection object.
		 * 
		 * @return	void
		 */
		public function reConnect():void
		{
			connection.connect(gateway);
		}
	}
}