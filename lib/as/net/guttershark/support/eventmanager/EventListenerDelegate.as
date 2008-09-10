package net.guttershark.support.eventmanager
{

	/**
	 * The EventListenerDelegate class is the base class for all IEventListenerDelegate
	 * classes. This implements the base functionality needed. Besides actually
	 * adding any events to the objects.
	 */
	public class EventListenerDelegate
	{
		
		/**
		 * A reference to the obj that listeners were added too.
		 */
		protected var obj:*;
		
		/**
		 * A function reference on EventManager. It references the
		 * handleEvent function in EventManager.
		 */
		protected var handleEvent:Function;
		
		/**
		 * The callback prefix on the target callbackDelegate;
		 */
		public var callbackPrefix:String;
		
		/**
		 * The calbackDelegate.
		 */
		public var callbackDelegate:*;
		
		/**
		 * Cycle all events through tracking framework.
		 */
		public var cycleAllThroughTracking:Boolean;
		
		/**
		 * Add listeners to the passed obj. Make sure to only add listeners
		 * to the obj if the (obj is MyClass) && if the target listener callback
		 * is defined in the object.
		 */
		public function addListeners(obj:*):void
		{
			this.obj = obj;
		}
		
		/**
		 * Remove event listeners from the internal reference to obj.
		 */
		protected function removeEventListeners():void{}
		
		/**
		 * @private
		 * Set's the event handler function which events get passed back
		 * to in the EventManager.
		 */
		public function set eventHandlerFunction(func:Function):void
		{
			handleEvent = func;
		}
		
		/**
		 * Dispose of this event listener delegate.
		 */
		public function dispose():void
		{
			removeEventListeners();
			handleEvent = null;
			obj = null;
			callbackDelegate = null;
			callbackPrefix = null;
		}