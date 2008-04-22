package net.guttershark.util
{
	
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * Dispatched when the user becomes inactive.
	 */
	[Event(name="inactive",type="flash.events.Event")]
	
	/**
	 * Dispatched when the user becomes active.
	 */
	[Event(name="active",type="flash.events.Event")]
	
	/**
	 * The Inactivity class can be used to watch for inactivity within the
	 * scope of a DisplayObject.
	 * 
	 * <p>Note that continuous events aren't dispatched, they only dispatch
	 * when the state changes. So if the user goes from active to inactive,
	 * the inactive event will be dispatched. As soon as they go active again,
	 * the active event is dispatched.</p>
	 * 
	 * @example Using the inactivity class:
	 * <listing>	
	 * var inact:Inactivity = new Inactivity(myMovieClip, 2000);
	 * inact.addEventListener(Inactivity.ACTIVE, whenActiveAgain);
	 * inact.addEventListener(Inactivity.INACTIVE, whenGoInactive); 
	 * inact.start();
	 * </listing>
	 */
	public class Inactivity extends EventDispatcher
	{
	
		/**
		 * Defines the value of the type property of the event object used for inactive events.
		 */
		public static var INACTIVE:String = "inactive";
		
		/**
		 * Defines the value of the type property of the event object used for active events.
		 */
		public static var ACTIVE:String = "active";
		
		/**
		 * number of ms before inactive.
		 */
		private var milliseconds:int;
		
		/**
		 * handle on the interval.
		 */
		private var interval:int;
		
		/**
		 * Internal use flag for active / inactive
		 */
		private var isActive:Boolean = true;
		
		/**
		 * Internal toggle for start / stop.
		 */
		private var working:Boolean = false;
		
		/**
		 * The scope watching for inactivity in.
		 */
		private var scope:DisplayObject;

		/**
		 * Constructor for Inactivity instances.
		 * 
		 * @param	scope	The object to watch for user activity.
		 * @param	int	The time in milliseconds to wait before the user is considered inactive.
		 */
		public function Inactivity(scope:DisplayObject,timeout:int):void
		{
			milliseconds = timeout;
			this.scope = scope;
		}
		
		/**
		 * This executes when the user has interacted with the target 'scope' display object.
		 * It dispatches Inactivity.ACTIVE. 
		 */
		private function userActive(e:*):void
		{
			if(!working) return;
			if(!isActive)
				if(this.hasEventListener(Inactivity.ACTIVE)) dispatchEvent(new Event(Inactivity.ACTIVE));
			isActive = true;
			flash.utils.clearInterval(interval);
			interval = flash.utils.setInterval(userInactive,milliseconds);
		}
		
		/**
		 * If an 'inactive' interval successfully completes, this method is executed. Dispatching
		 * a Inactivity.INACTIVE event. This will only dispatch the first time they're considered 'inactive'.
		 * 
		 * Once the Inactivity.INACTIVE is dispatched, they're in an inactive state. When the User 
		 * interacts with the 'scope' again, Inactivity.ACTIVE is dispatched. Switching the state
		 * to active. 
		 */
		private function userInactive():void
		{
			if(!working) return;
			if(isActive) 
				if(hasEventListener(Inactivity.INACTIVE)) dispatchEvent(new Event(Inactivity.INACTIVE));
			isActive = false;
		}
		
		private function addListeners():void
		{
			scope.addEventListener(MouseEvent.MOUSE_MOVE, userActive);
			scope.addEventListener(KeyboardEvent.KEY_UP, userActive);
		}
		
		private function removeListeners():void
		{
			scope.removeEventListener(MouseEvent.MOUSE_MOVE, userActive);
			scope.removeEventListener(KeyboardEvent.KEY_UP, userActive);
		}
		
		/**
		 * Start the inactivity watching.
		 */
		public function start():void
		{
			addListeners();
			working = true;
		}
		
		/**
		 * Stop inactivity watching.
		 */
		public function stop():void
		{
			removeListeners();
			working = false;
		}
	}
}