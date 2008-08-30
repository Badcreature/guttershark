package net.guttershark.preloading.events
{
	
	import flash.events.Event;
	
	import net.guttershark.preloading.Asset;
	
	/**
	 * The AssetStatusEvent dispatches for an Asset that had an HTTP status other than 0 or 200.
	 */
	public class AssetStatusEvent extends Event
	{ 
		/**
		 * Defines the value of the type property of the assetStatus event type.
		 */
		public static const STATUS:String = "assetStatus";
		
		/**
		 * The Asset that had the status error.
		 */
		public var asset:Asset;
		
		/**
		 * The status code.
		 */
		public var status:int;
		
		/**
		 * Constructor for AssetStatusEvent instances.
		 * 
		 * @param	String		The type.
		 * @param	LoadItem	The Asset that triggered the status event.
		 * @param	int			The status code of the event.
		 * @see	net.guttershark.preloading.Asset Asset class
		 */
		public function AssetStatusEvent(type:String, asset:Asset, status:int)
		{
			super(type,false,false);
			this.asset = asset;
			this.status = status;
		}
	}
}