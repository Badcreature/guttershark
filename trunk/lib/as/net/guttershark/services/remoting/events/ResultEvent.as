package net.guttershark.services.remoting.events
{

	import flash.events.Event;
	
	/**
	 * A result event for any remoting call.
	 */
	public class ResultEvent extends Event 
	{
		
		/**
		 * Result identifier
		 */
		public static const RESULT:String = "result";
		
		/**
		 * The resulting payload object.
		 */
		public var result:Object;
		
		/**
		 * New ResultEvent
		 * @param	Object		The result data.
		 * @param	Boolean		Whether to bubble or not.
		 * @param	Boolean		Cancelable.
		 */
		public function ResultEvent(result:Object, bubbles:Boolean, cancelable:Boolean) 
		{
			super(ResultEvent.RESULT, bubbles, cancelable);
			this.result = result;
		}
	}
}