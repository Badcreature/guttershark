package net.guttershark.command
{
	import flash.utils.Dictionary;	
	
	/**
	 * The CommandRegistrar class is used to register any commands that
	 * are going to be fired with the CommandExecutor or CommandQueueExecutor.
	 * 
	 * <p>Every command MUST be registered here before they can fire.</p>
	 */
	public class CommandRegistrar
	{
		
		//holds the commands
		private static var commands:Dictionary;

		/**
		 * Registers a command to be used.
		 * 
		 * @param	commandName	The command name. 
		 * @param	classReference	A reference to the class.
		 */
		public static function Register(commandName:String, classReference:Class):void
		{
			if(!commands) commands = new Dictionary();
			if(commands[commandName] != null) return;
			else commands[commandName] = classReference;
		}
		
		/**
		 * Returns a reference to a Class of the command.
		 * 
		 * @param	cojmandName	The commands name used when it was Registered.
		 */
		public static function GetCommand(commandName:String):*
		{
			if(!commands[commandName]) throw new Error("The command {"+ commandName + "} was not found.");
			else return commands[commandName];
		}
		
		/**
		 * Deletes a reference to a registered Command class.
		 * 
		 * @param	className	The command name.
		 */
		public static function DeleteClassReference(commandName:String):void
		{
			if(!commands[commandName]) return;
			else
			{
				CommandExecutor.deleteCommand(commandName); //delete from the command executor cache
				delete commands[commandName];
			}		
		}
	}
}