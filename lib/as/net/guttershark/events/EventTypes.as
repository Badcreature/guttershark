package net.guttershark.events 
{
	
	/**
	 * The EventTypes class is an enumeration of values
	 * you should use when using the EventManager.gi().handleEvents()
	 * method. You can bitwise or (|) these values to trigger
	 * different events from the delegate.
	 * 
	 * @example Using EventTypes with EventManager.gi().handleEvents()
	 * <listing>	
	 * EventManager.gi().handleEvents(myMC,"onMyMC",this,false,EventTypes.MOUSE | EventTypes.STAGE);
	 * </listing>
	 * 
	 * <p>In that example, only mouse events and stage events will fire for myMC</p>
	 * 
	 * @see net.guttershark.events.EventListenersDelegate EventListenersDelegate class.
	 * @see net.guttershark.events.EventListenersDelegate#delegatEvents() delegateEvents method.
	 */
	public class EventTypes
	{
		
		/**
		 * Stage events.
		 */
		public static const STAGE:int = 1;
		
		/**
		 * Mouse events.
		 */
		public static const MOUSE:int = 2;
		
		/**
		 * Focus events.
		 */
		public static const FOCUS:int = 4;
		
		/**
		 * Tab events.
		 */
		public static const TABS:int = 8;
		
		/**
		 * Key events.
		 */
		public static const KEYS:int = 16;
		
		/**
		 * Custom Event Handlers. This causes any custom
		 * event handler delegates to be run agains your object.
		 */
		public static const CUSTOM:int = 32;
		
		/**
		 * Tracking events. This turns on the internal tracking framework
		 * in the EventManager. You don't get any callbacks when this is
		 * in place. Instead events get sent through the Tracking class.
		 */
		public static const TRACKING:int = 64;	}}