package net.guttershark.command
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Dispatches when the event is considered complete, to 
	 * allow the CommandQueueExecutor to move onto the next command.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event("complete",type="flash.events.Event")]
	
	/**
	 * The QueueableCommand class is the base class that must be used in
	 * conjunction with the CommandQueueExecutor.
	 * 
	 * <p>Every QueueableCommand must dispatch a complete event in order
	 * for the CommandQueueExecutor to continue.</p>
	 */
	public class QueueableCommand extends EventDispatcher implements ICommand
	{
		
		/**
		 * Interface compliance.
		 * 
		 * @inheritDoc
		 */
		public function execute(data:*, ...rest:Array):void
		{
			throw new Error("You must override the QueueableCommand's execute method and specify your own logic");
		}
		
		/**
		 * Dispose of this command.
		 */
		public function dispose():void
		{
			
		}
		
		/**
		 * Dispatches an Event.COMPLETE event. Just call super.complete()
		 * from any command that extends QueueableCommand to proceed to the 
		 * next command.
		 */
		protected function complete():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}