package net.guttershark.preloading.events
{

	import flash.events.Event;

	import net.guttershark.preloading.Asset;
	
	/**
	 * The AssetCompleteEvent dispatches when an asset has completed downloading.
	 */
	public class AssetCompleteEvent extends Event
	{
		
		/**
		 * Defines the value of the type property of the assetComplete event type.
		 */
		public static const COMPLETE:String = 'assetComplete';
		
		/**
		 * The asset that has completely downloaded.
		 */
		public var asset:Asset;
		
		/**
		 * Constructor for AssetCompleteEvent instances.
		 * 
		 * @param	type	The event type.
		 * @param	asset	The Asset that has completely downloaded.
		 * @see	net.guttershark.preloading.Asset Asset class
		 */
		public function AssetCompleteEvent(type:String, asset:Asset)
		{
			super(type,false,false);
			this.asset = asset;
		}
	}
}