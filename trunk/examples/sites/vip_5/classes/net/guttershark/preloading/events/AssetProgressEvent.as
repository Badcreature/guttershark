package net.guttershark.preloading.events
{
	
	import flash.events.Event;
	import net.guttershark.preloading.Asset;
	
	/**
	 * The AssetProgressEvent dispatches for an Asset that is downloading.
	 */
	public class AssetProgressEvent extends Event
	{ 
		
		/**
		 * Defines the value of the type property of the assetProgress event type.
		 */
		public static const PROGRESS:String = "assetProgress";
		
		/**
		 * The asset that is loading.
		 */
		public var asset:Asset;
		
		/**
		 * Constructor for AssetProgressEvent instances.
		 * 
		 * @param	String		The type.
		 * @param	LoadItem	The Asset that is downloading.
		 * @see	net.guttershark.preloading.Asset Asset class
		 */
		public function AssetProgressEvent(type:String, asset:Asset)
		{
			super(type,false,false);
			this.asset = asset;
		}
	}
}