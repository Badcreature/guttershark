package net.guttershark.support.preloading.events
{
	import flash.events.Event;
	
	import net.guttershark.support.preloading.Asset;	

	/**
	 * The AssetOpenEvent dispatches when an Asset has started downloading.
	 */
	final public class AssetOpenEvent extends Event
	{ 
		
		/**
		 * Defines the value of the type property of the assetOpen event type.
		 */
		public static const OPEN:String = "assetOpen";
		
		/**
		 * The Asset that started downloading.
		 */
		public var asset:Asset;
		
		/**
		 * Constructor for AssetOpenEvent instances.
		 * 
		 * @param type The event type.
		 * @param asset	The Asset that is downloading.
		 * @see	net.guttershark.preloading.Asset Asset class
		 */
		public function AssetOpenEvent(type:String, asset:Asset)
		{
			super(type,false,false);
			this.asset = asset;
		}
		
		/**
		 * Clone this AssetOpenEvent.
		 */
		override public function clone():Event
		{
			return new AssetOpenEvent(type,asset);
		}
		
		/**
		 * To string override for descriptions.
		 */
		override public function toString():String
		{
			return "[AssetOpenEvent asset:"+asset.source+"]";
		}
	}
}