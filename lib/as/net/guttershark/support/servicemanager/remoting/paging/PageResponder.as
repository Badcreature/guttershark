package net.guttershark.support.servicemanager.remoting.paging
{
	import flash.events.EventDispatcher;
	
	import net.guttershark.support.servicemanager.remoting.events.FaultEvent;
	import net.guttershark.support.servicemanager.remoting.events.PageEvent;
	import net.guttershark.support.servicemanager.remoting.events.ResultEvent;	

	/**
	 * Dispatched when a page was received.
	 * 
	 * @eventType net.guttershark.remoting.events.PageEvent
	 */
	 [Event(name=PageEvent.RECEIVED,name="net.guttershark.remoting.events.PageEvent")];

	/**
	 * Dispatched when a page was received.
	 * 
	 * @eventType net.guttershark.remoting.events.PageEvent
	 */
	 [Event(name=PageEvent.FAILED,name="net.guttershark.remoting.events.PageEvent")];

	/**
	 * Default generic responder used with the RemotingPager class.
	 * Each page reqeust in a RemotingPager uses page responders
	 * as delegates for response / faults from the remoting request.
	 */
	public class PageResponder extends EventDispatcher
	{
		
		/**
		 * The offset of data.
		 */
		protected var offset:Number;
		
		/**
		 * The number of rows to get.
		 */
		protected var count:Number;

		/**
		 * The result data.
		 */
		public var resultData:*;

		/**
		 * New PageResponder, the offset and count are use when the PageEvent.RECEIVED
		 * event is dispatched, so you can identify where exactly in the data this payload
		 * should be placed.
		 * 
		 * @param		Number		The offset in the data to start at.
		 * @param		Number		The total rows to grab.
		 */		
		public function PageResponder(offset:Number, count:Number):void
		{
			this.offset = offset;
			this.count = count;
		}
		
		/**
		 * On remoting request result.
		 * 
		 * @return		void
		 */
		public function onResult(re:ResultEvent,args:Array = null):void
		{
			this.resultData = re.result;
			var pe:PageEvent = new PageEvent(PageEvent.RECEIVED);
			pe.data = re.result;
			pe.offset = offset;
			pe.count = count;
			dispatchEvent(pe);
		}
		
		/**
		 * On remoting request fault.
		 * 
		 * @return		void
		 */
		public function onFault(fe:FaultEvent, args:Array = null):void
		{
			this.resultData = fe.fault;
			var pe:PageEvent = new PageEvent(PageEvent.FAILED);
			pe.data = null;
			pe.offset = offset;
			pe.count = count;
			dispatchEvent(pe);
		}
	}
}