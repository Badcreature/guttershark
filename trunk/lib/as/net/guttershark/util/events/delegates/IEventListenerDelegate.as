package net.guttershark.events.delegates
{
	
	/**
	 * The IEventListenerDelegate class creates the contract for objects that
	 * implement being an event listener delegate with the EventManager.
	 */
	public interface IEventListenerDelegate 
	{
		
		/**
		 * Set's a reference to a function inside of EventManager for
		 * handling events.
		 */
		function set eventHandlerFunction(func:Function):void;
		
		/**
		 * Add listeners to the obj.
		 */
		function addListeners(obj:*):void;	}}