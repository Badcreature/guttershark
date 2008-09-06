package net.guttershark.command
{
	
	import flash.events.EventDispatcher;
	
	/**
	 * The CommandQueueExecutor is used to execute commands in a queue.
	 * 
	 * <p>Implementation old, must be re-written.</p>
	 */
	public class CommandQueueExecutor extends EventDispatcher
	{
		
		/*
		 * private var commands:ArrayedQueue;
			private var commandIterator:Iterator;
			private var currentCommand:*;
		 */
		
		/**
		 * Creates a new CommandQueueExecutor.
		 * 
		 * @param		Array		An array of command names to fire.
		 
		public function CommandQueueExecutor(commands:Array)
		{
			if(!commands) throw new Error("No commands were given");
			this.commands = new ArrayedQueue(commands.length);
			var len:int = commands.length;
			
			for(var i:int = 0; i < len; i++)
			{
				this.commands.enqueue(commands[i]);
			}
			
			commandIterator = this.commands.getIterator();
			executeCommand();
		}
		
		//on a command completion, this is fired.
		private function onComplete(e:Event):void
		{
			if(currentCommand) currentCommand.removeEventListener(Event.COMPLETE,onComplete);
			
			if(commandIterator.hasNext())
			{
				executeCommand();
			}
			else
			{
				currentCommand = null;
				commands = null;
				commandIterator = null;
				dispatchEvent(new Event(Event.COMPLETE));	
			}
		}
		
		/**
		 * Takes care of executing the command
		 
		protected function executeCommand():void
		{
			try
			{
				var cn:String = commandIterator.next();
				var commandClass:Class = CommandRegistrar.GetCommand(cn) as Class;
			}
			catch(e:Error)
			{
				throw e;
			}
         	var commandInstance:* = new commandClass();
         	commandInstance.addEventListener(Event.COMPLETE, onComplete);
         	commandInstance.execute({});
         	commandInstance = null;
         	cn = null;
         	commandClass = null;
		}*/
	}
}