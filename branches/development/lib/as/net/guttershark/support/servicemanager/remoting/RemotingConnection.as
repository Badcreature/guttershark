package net.guttershark.support.servicemanager.remoting
{
	import flash.events.*;
	import flash.net.NetConnection;	

	/**
	 * The RemotingConnection class simplifies connecting a net connection to 
	 * a Flash Remoting gateway.
	 */
	final public class RemotingConnection extends EventDispatcher
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
			if(gateway == '' || !gateway) throw new ArgumentError("Gateway cannot be null");
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
			trace("NetConnection Error"+event.text);
		}
		
		/**
		 * onConnectionStatus
		 */
		private function onConnectionStatus(event:NetStatusEvent):void
		{
			switch(event.info.code)
			{
				case "NetConnection.Connect.Success":
					break;
				case "NetConnection.Connect.Failed":
					trace("Error: NetConnection Failed");
					break;
				case "NetConnection.Call.BadVersion":
					trace("Error: NetConnection BadVersion");
					break;
				case "NetConnection.Call.Prohibited":
					trace("Error: NetConnection Prohibited");
					break;
				case "NetConnection.Connect.Closed":
					trace("Error: NetConnection Closed");
					break;
			}
		}
		
		/**
		 * Dispose of this RemotingConnection.
		 */
		public function dispose():void
		{
			if(connection.connected) connection.close();
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