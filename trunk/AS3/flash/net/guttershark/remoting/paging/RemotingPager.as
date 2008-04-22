package net.guttershark.remoting.paging
{
	
	import flash.events.EventDispatcher;
	
	import net.guttershark.remoting.RemotingService;
	import net.guttershark.remoting.events.CallEvent;
	import net.guttershark.remoting.events.PageEvent;
	import net.guttershark.remoting.errors.PageError;
	
	/**
	 * Dispatched when any one of the paging requests retries.
	 */
	[Event(name=CallEvent.RETRY,type="com.niarbtfel.remoting.events.CallEvent")];
	
	/**
	 * Dispatched when a paging request times out.
	 */
	[Event(name=CallEvent.TIMEOUT,type="com.niarbtfel.remoting.events.CallEvent")];
	
	/**
	 * Dispatched when all one page has have been receied.
	 */
	[Event(name=PageEvent.RECEIVED,type="com.niarbtfel.remoting.events.PageEvent")];
	
	/**
	 * Dispatched when a page request fails. An event is dispatched for each page that fails.
	 */
	[Event(name=PageEvent.FAILED,type="com.niarbtfel.remoting.events.PageEvent")];
	
	/**
	 * Dispatched when a page request is sent. An event is dispatched for
	 * each request sent.
	 */
	[Event(name=PageEvent.RETRIEVING,type="com.niarbtfel.remoting.events.PageEvent")];
	
	/**
	 * Dispatched when the page buffer is full.
	 */
	[Event(name=PageEvent.BUFFER_FULL,type="com.niarbtfel.remoting.events.PageEvent")];
	
	/**
	 * Dispatched when the releaseAll call finishes.
	 */
	[Event(name=PageEvent.RELEASED_ALL,type="com.niarbtfel.remoting.events.PageEvent")];
	
	/**
	 * A generic remoting pager.
	 */
	public class RemotingPager extends EventDispatcher
	{
		
		/**
		 * The remoting service to do the paging on.
		 */
		private var remotingService:RemotingService;
		
		/**
		 * The page responder class to use.
		 */
		private var pageResponderClass:Class;
		
		/**
		 * The method that is being paged through.
		 */
		private var methodToCall:String;
		
		/**
		 * The original arguments sent in the call.
		 */
		private var args:Array;
		
		/**
		 * All records from each page received get's
		 * put here.
		 */
		private var _data:Array;
		
		/**
		 * The page size.
		 */
		public var pageSize:int;
		
		/**
		 * Total records on the server.
		 */
		public var totalRecordsOnServer:Number;
		
		/**
		 * Total pages on the server.
		 */
		public var totalPagesOnServer:Number;
		
		/**
		 * The total local records available
		 */
		public var totalLocalRecords:Number;
		
		/**
		 * The total local pages that have been retrieved from the server already.
		 */
		public var totalLocalPages:Number;
		
		/**
		 * The cursor over pages.
		 */
		private var pageCursor:int;
		
		/**
		 * The minimum amount of pages locally before calling 
		 * to get more pages.
		 */
		public var pageBuffer:int = 2;
		
		/**
		 * This can be used to have the pager fill the buffer
		 * when less than x amount of local pages are available.
		 */
		public var fillBufferWhenLocalPagesAvailableLessThan:Number = 2;
		
		/**
		 * Counter used for keeping track of when to 
		 * dispatch the PageEvent.RECEIVED event.
		 */
		private var spawns:int;
		
		/**
		 * Flag variable used when a releaseAll call is made.
		 */
		private var releasedAll:Boolean;
		
		/**
		 * Creates a new Remoting Pager. You should have already intialized a RemotingService, and called
		 * the initial data request, meaning you have the first page already (0 - pageSize). It is 
		 * required to make a new pager.
		 * 
		 * @param		RemotingService		The service that was used to get the initial data.
		 * @param		String				The method that was called initially.
		 * @param		Class				A PageResponder (or subclass), there is a base PageResponder you can use, 
		 * this is done so you can change what property of the resulting data structure get's stored in the paging mechanism..
		 * @param		Array				The arguments sent to the original service call. Don't put any offsets or page size info on the end of the array. 
		 * The offset, and pagesize get appended to the arguments ent to the remoting service.
		 * @param		Array				The initial data from the very first service call.
		 * @param		Number				The total records on the server.
		 * @param		int					The page size.
		 * @param		int					The number of pages to grab from the server when a buffer fill happens.
		 * @param		int					The number of remaining locla pages available before a buffer is filled.
		 * 
		 * @throws 		ArgumentError
		 */
		public function RemotingPager(service:RemotingService, methodToCall:String, responderClass:Class, args:Array, initialData:Array, totalRecordsOnServer:Number, pageSize:Number, pageBuffer:int = 1, fillBufferWhenLocalPagesLeft:int = 1)
		{
			if(totalRecordsOnServer < 0)
				throw new ArgumentError("You must supply the total records available on the server.");
			
			if(!responderClass)
				throw new ArgumentError("A PageResponder class must be supplied.");
			
			if(!service)
				throw new ArgumentError("A RemotingService must be provided.");
			
			if(!methodToCall)
				throw new ArgumentError("The name of the method to call was not provided");
			
			if(!pageSize)
				throw new ArgumentError("The page size was not provided.");
			
			if(!args || args == null)
				this.args = [];
			
			if(!initialData)
				throw new ArgumentError("The initial data was not supplied.");
			
			if(!totalRecordsOnServer)
				throw new ArgumentError("The total records on the server must be supplied.");
			
			this.remotingService = service;
			this.methodToCall = methodToCall;
			this.args = args;
			this.pageResponderClass = responderClass;
			this.pageSize = pageSize;
			this._data = initialData;
			this.totalLocalRecords = initialData.length;
			this.totalRecordsOnServer = totalRecordsOnServer;
			this.fillBufferWhenLocalPagesAvailableLessThan = fillBufferWhenLocalPagesLeft;
			calcTotalServerPages();
			calcTotalLocalPages();
			this.pageBuffer = Math.max(0,pageBuffer);
			pageCursor = 0;
			spawns = 0;

			if(pageBuffer <= 1)
			{
				this.pageBuffer = 1;
				if(this.fillBufferWhenLocalPagesAvailableLessThan < 1)
					this.fillBufferWhenLocalPagesAvailableLessThan = 1;
				retrieveBuffer();
				return;
			}
			else if(remainingLocalPages() <= fillBufferWhenLocalPagesAvailableLessThan)
			{
				retrieveBuffer();
			}
			else if(remainingLocalPages() >= fillBufferWhenLocalPagesAvailableLessThan)
			{
				dispatchEvent(new PageEvent(PageEvent.BUFFER_FULL));
			}
			else if(initialData.length < pageSize && totalRecordsOnServer > pageSize)
			{
				retrieveBuffer();
				dispatchEvent(new PageEvent(PageEvent.BUFFER_FULL));
			}
		}
		
		/**
		 * Calulates the total local pages available.
		 */
		private function calcTotalLocalPages():Number
		{
			this.totalLocalPages = Math.ceil((_data.length / pageSize));
			return totalLocalPages;
		}
		
		/**
		 * Calculates the remainging pages avaiable locally.
		 */
		private function remainingLocalPages():Number
		{
			var recordsLeft:int = _data.length - (pageCursor * pageSize);
			var ps:int = recordsLeft / pageSize;
			return ps;
		}
		
		/**
		 * Calculates the total server pages available.
		 */
		private function calcTotalServerPages():Number
		{
			this.totalPagesOnServer = Math.ceil(totalRecordsOnServer / pageSize);
			return totalPagesOnServer;
		}
		
		/**
		 * Calculates the remaining server pages.
		 */
		private function remaingingServerPages():Number
		{
			return (calcTotalServerPages() - calcTotalLocalPages());
		}
		
		/**
		 * Helper method that triggeres the buffer retrieval calls,
		 * and figures out how many pages to grab / the offests.
		 */
		private function retrieveBuffer():void
		{
			var numPages:int = pageBuffer - remainingLocalPages();
			getPages(pageBuffer);
		}
		
		/**
		 * Resets the page cursor.
		 * @return		void
		 */
		public function start():void
		{
			pageCursor = 0;
		}
		
		/**
		 * Test if there is an available page.
		 * @return		Boolean
		 */
		public function hasNext():Boolean
		{
			/*trace("HAS NEXT");
			trace(remainingLocalPages() - 1);
			trace(remaingingServerPages());
			trace(!(((remainingLocalPages() - 1) == -1) && ((remaingingServerPages() == 0))));*/
			return !(((remainingLocalPages() - 1) == -1) && ((remaingingServerPages() == 0)));
		}
		
		/**
		 * Get's the next page, and triggers page
		 * buffering if in place.
		 * 
		 * @throws 		PageError
		 * @return		*
		 */
		public function next():*
		{	
			var nextPage:Array;
			var startPosition:int;
			var endPosition:int;
			
			startPosition = ((pageCursor) * pageSize);
			endPosition = startPosition + pageSize;
			
			if(!hasNext())
				throw new PageError("next() was called without calling hasNext() first. Use hasNext() before calling next to ensure the next page exists.");
			
			/*trace("NEXT");
			trace(startPosition);
			trace(endPosition);*/
			
			if(endPosition > (_data.length - 1))
				endPosition = _data.length - 1;
			
			if(startPosition >= endPosition)
				nextPage = null;
			else
				nextPage = _data.slice(startPosition,endPosition);
			
			/*trace("NEXT PAGE");
			trace(nextPage);*/
			
			pageCursor++; //increment here so buffer is correct.
			
			if(remainingLocalPages() <= fillBufferWhenLocalPagesAvailableLessThan)
			{
				if(totalLocalPages >= totalPagesOnServer)
				{
					if(nextPage)
						return nextPage;
					else
						throw new PageError("The next page is not available.");
				}
				retrieveBuffer();
			}
			return nextPage;
		}
		
		/**
		 * Seek's the cursor to whichever page you supply. 
		 * Use this if you need to go backwards in the paging.
		 * 
		 * Index's start at 1, so if you want to seek to the
		 * beginning, supply 1 as the index.
		 * 
		 * @param		int			The page index to seek to. (start at 1).
		 * @throws		PageError
		 * @return		void
		 */
		public function seek(pageIndex:int):void
		{
			var si:int = pageIndex - 1;
			
			if(pageIndex > totalLocalPages)
				throw new PageError("You cannot seek to a page that is not available locally.");
			
			if(pageIndex > totalPagesOnServer)
				throw new PageError("You cannot seek to a page that doesn't exist on the server");
			 
			pageCursor = Math.max(0,si);
		}
		
		/**
		 * Test to see if the specified page is available.
		 * Index's start at 1.
		 * 
		 * @param		int			The page index.
		 * @return		Boolean
		 */
		public function hasPage(pageIndex:int):Boolean
		{
			var i:int = pageIndex - 1;
			var tmp:int = Math.max(0,i);
			var start:int = (tmp * pageSize) - 1;
			var end:int = start + pageSize;
			return !(_data.length < end);
		}
		
		/**
		 * Get a LOCAL page at certain index. An error is thrown if
		 * it is not available. Index's start at 1.
		 * 
		 * @param		int			The page index (starts at 1).
		 * @throws		PageError	Thrown when a page doesn't exist locally.
		 * @return		*
		 */
		public function getPage(pageIndex:int):*
		{
			var i:int = pageIndex - 1;
			var tmp:int = Math.max(0,i);
			var page:Array = [];
			var start:int = (tmp * pageSize) - 1;
			var end:int = start + pageSize;
			if(_data.length < end)
			{
				var len:int = _data.length;
				if((len - end) <= 0)
					throw new PageError("Page " + pageIndex.toString() + " is not available locally");
				else
					end = _data.length - 1;
			}
			page = _data.slice(start,end);
			return page;
		}
		
		/**
		 * Initiates remoting calls to get all data up to and
		 * including the specified page.
		 * 
		 * Note that you can't get pages ahead of what is available
		 * without it getting all the middle pages. So if you have
		 * 4 local pages, and you want page 7, pages 5,6, and 7 will
		 * be retrieved.
		 * 
		 * @param		int			The page to get from the server. Index's start at 1.
		 * @throws		PageError	Thrown when the server doesn't have that many pages.
		 * @return		void
		 */
		public function sendForPage(pageIndex:int):void
		{
			if(pageIndex > calcTotalServerPages())
				throw new PageError("The server only has " + calcTotalServerPages().toString() + " pages available");
			
			var i:int = pageIndex - 1;
			var tmp:int = Math.max(0,i);
			var page:Array = [];
			var start:int = (tmp * pageSize) - 1;
			var end:int = start + pageSize;
			if(_data.length > end)
			{
				var toGet:int = pageIndex - calcTotalLocalPages();
				getPages(toGet);
			}
			else
			{
				var pe:PageEvent = new PageEvent(PageEvent.RECEIVED);
				pe.offset = start;
				pe.count = (end - start);
				pe.data = _data.slice(start,end);
				dispatchEvent(pe);
			}
		}
		
		/**
		 * Retrieves all pages from the server. A PageEvent.RECEIVED
		 * event is dispatched after ALL are available.
		 * 
		 * @return		void
		 */
		public function releaseAll():void
		{
			var toget:int = remaingingServerPages();
			if(toget > 0)
			{
				getPages(toget);
			}
			releasedAll = true;
		}
		
		/**
		 * 
		 * Worker method that does the PageResponder spawning
		 * and figures out offsets / page amounts to grab.
		 * 
		 * @param		int		The number of pages to retrieve from the server.
		 */
		private function getPages(numPages:int=1):void
		{
			remotingService.addEventListener(CallEvent.RETRY, onRetry);
			remotingService.addEventListener(CallEvent.TIMEOUT, onTimeout);
			for(var i:int = 0; i < numPages; i++)
			{
				var t:Array = args.concat();
				var off:Number = ((calcTotalLocalPages() + (i)) * pageSize);
				t.push(off);
				t.push(pageSize);
				var responder:* = new pageResponderClass(off,pageSize);
				responder.addEventListener(PageEvent.RECEIVED, onPageReceived);
				responder.addEventListener(PageEvent.FAILED, onPageFail);
				remotingService.apply(methodToCall,t,responder.onResult,responder.onFault,false);
				spawns++;				
				var pe:PageEvent = new PageEvent(PageEvent.RETRIEVING,false,false);
				pe.offset = off;
				pe.count = pageSize;
				pe.data = null;
				dispatchEvent(pe);
			}
		}
		
		/**
		 * Returns all the records that have been
		 * retrieved and stored locally, this is the array
		 * that all records live in.
		 * 
		 * @return		*
		 */
		public function get data():*
		{
			return _data;
		}
		
		/**
		 * When a page requests have been received. When all 
		 * outstanding page requests are received, a PageEvent.RECEIVED
		 * is dispatched.
		 * 
		 * @param		PageEvent
		 * @return		void
		 */
		private function onPageReceived(pe:PageEvent):void
		{	
			_data = _data.concat((pe.data as Array));
			calcTotalLocalPages();
			spawns--;
			
			var npe:PageEvent;
			npe = new PageEvent(PageEvent.RECEIVED);
			npe.offset = -1;
			npe.count = -1;
			npe.data = null;
			dispatchEvent(npe);
			
			if(spawns <= 0)
			{
				spawns = 0;
				if(releasedAll)
				{
					npe = new PageEvent(PageEvent.RELEASED_ALL);
					npe.offset = -1;
					npe.count = -1;
					npe.data = null;
					releasedAll = false;
					dispatchEvent(npe);	
				}
			}
			
			if(remainingLocalPages() > pageBuffer)
			{
				npe = new PageEvent(PageEvent.BUFFER_FULL);
				npe.offset = -1;
				npe.count = -1;
				npe.data = null;
				dispatchEvent(npe);
			}
			
			totalLocalRecords = _data.length;
		}

		/**
		 * When a page request fails. This does not break any other
		 * events, but the total local pages will never be able to 
		 * be fully populated.
		 * 
		 * @param		PageEvent
		 * @return		void
		 */
		private function onPageFail(pe:PageEvent):void
		{
			spawns--;
			var npe:PageEvent;
			npe = new PageEvent(PageEvent.FAILED);
			
			if(spawns <= 0)
			{
				spawns = 0;
				npe = new PageEvent(PageEvent.RECEIVED);
			}

			npe.offset = -1;
			npe.count = -1;
			npe.data = null;
			dispatchEvent(npe);
		}
		
		/**
		 * When one of the page requests retries.
		 * @param		CallEvent
		 * @return		void
		 */
		private function onRetry(ce:CallEvent):void
		{
			dispatchEvent(new CallEvent(CallEvent.RETRY,false,false));
		}
		
		/**
		 * When one of the page reqeusts times out.
		 * @param		CallEvent
		 * @return		void
		 */
		private function onTimeout(ce:CallEvent):void
		{
			dispatchEvent(new CallEvent(CallEvent.TIMEOUT,false,false));
		}
	}
}