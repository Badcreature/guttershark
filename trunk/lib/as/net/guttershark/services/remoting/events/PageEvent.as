package net.guttershark.services.remoting.events
{
	
	import flash.events.Event;
	
	/**
	 * Generic event used when paging is performing actions.
	 * 
	 * This event is used in PageResponder to callback to the RemotingPager
	 * with the data in this event. 
	 * 
	 * It's also dispatched from RemotingPager. When an event of this type is dispatched
	 * from the RemotingPager class, count and offset are -1 and the data property
	 * is null. This is because you should use the hasNext() and next() methods
	 * of your RemotingPager instance to get the data you need correctly instead of relying
	 * on properties on this event.
	 */
	public class PageEvent extends Event
	{
		
		/**
		 * When all page requests are complete, this is dispatched
		 * from RemotingPager.
		 */
		public static const RECEIVED:String = "received";
		
		/**
		 * When any page request fails, one of these is dispatched.
		 */
		public static const FAILED:String = "failed";
		
		/**
		 * Dipatched when a page reqeust(s) was sent. You'll 
		 * get events for each page reqeust that was sent.
		 */
		public static const RETRIEVING:String = "retrieving";
		
		/**
		 * Dispatched after a buffer fill is called from the remoting
		 * pager and it successfully completed.
		 */
		public static const BUFFER_FULL:String = "bufferFull";
		
		/**
		 * Dispatched when a releaseAll call was made on a pager,
		 * and all subsequent pages have been received.
		 */
		public static const RELEASED_ALL:String = "releasedAll";
		
		/**
		 * The offset that this data starts at.
		 */
		public var offset:Number;
		
		/**
		 * The count that it should fill.
		 */
		public var count:Number;
		
		/**
		 * The raw data from the remoting request.
		 */
		public var data:*;
		
		/**
		 * New PageEvent
		 * @param	String	The event type.
		 * @param	Boolean	Bubbling event or not.
		 * @param	Boolean	Cancelable.
		 */
		public function PageEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);
		}
	}
}