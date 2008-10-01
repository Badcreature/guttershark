package net.guttershark.support.preloading.events
{
	import flash.events.Event;
	
	import net.guttershark.support.preloading.Asset;	

	/**
	 * The AssetCompleteEvent dispatches when an asset has completed downloading.
	 */
	final public class AssetCompleteEvent extends Event
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
		 * @param type The event type.
		 * @param asset The Asset that has completely downloaded.
		 * @see	net.guttershark.preloading.Asset Asset class
		 */
		public function AssetCompleteEvent(type:String,asset:Asset)
		{
			super(type,false,false);
			this.asset = asset;
		}
		
		/**
		 * Clone this AssetCompleteEvent.
		 */
		override public function clone():Event
		{
			return new AssetCompleteEvent(type,asset);
		}
		
		/**
		 * To string override for descriptions.
		 */
		override public function toString():String
		{
			return "[AssetCompleteEvent asset:"+asset.source+"]";
		}
	}
}