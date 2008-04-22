package net.guttershark.command
{

	/**
	 * The CommandExecutor is used to execute commands anonymously.
	 * 
	 * @see net.guttershark.command.CommandRegistrar CommandRegistrar class
	 */
	public class CommandExecutor
	{
		
		/**
		 * Cache instances of commands, and re-execute then when 
		 * CommandExecutor.execute is called.
		 * 
		 * <p>If this is true, the first instance of a command 
		 * that is made will be cached in memory, and each 
		 * execution will use that one instance.</p>
		 * 
		 * <p>You can still pass any data to the command, it's
		 * just never re instantiated.</p>
		 * 
		 * <p>The one exception to the cacheing is if you 
		 * specifically call CommandRegistrar.DeleteCommand. This will
		 * force the command to be purged from the registrar.</p>
		 */
		public static var CacheInstancesAndReExecute:Boolean = true;
		
		/**
		 * The memory cache of commands.
		 */
		private static var commandCache:Array;
		
		/**
		 * Executes the command given by <code>commandName</code> and caches it for any other executions.
		 * 
		 * @param	commandName	The Command Name you want to execute.
		 * @param	data	Any data object you want to pass to the command.
		 */
		public static function execute(commandName:String, data:Object = null):void
		{
			if(!commandCache) commandCache = [];
         	if((CommandExecutor.CacheInstancesAndReExecute) && !commandCache[commandName])
         	{
         		var commandClass:Class = CommandRegistrar.GetCommand(commandName) as Class;
         		var commandInstance:ICommand = new commandClass();
         		commandCache[commandName] = commandInstance;
         	}
         	else if(commandCache[commandName])
         	{
         		commandInstance = commandCache[commandName];
         	}
         	commandInstance.execute(data);
     	}
     	
     	/**
     	 * @private
     	 * 
     	 * Delete's a command from the command cache. This shouldn't be
     	 * called directly as it will cause memory leaks with the
     	 * CommandRegistrar. Use CommandRegistrar.DeleteClassReference,
     	 * which takes care of calling this function to delete the
     	 * command from the command executor.
     	 */
 		public static function deleteCommand(commandName:String):void
 		{
 			if(!commandCache[commandName]) return;
 			delete commandCache[commandName];
 		}
    }
}