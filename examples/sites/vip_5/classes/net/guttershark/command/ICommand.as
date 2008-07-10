package net.guttershark.command
{
	
	import net.guttershark.core.IDisposable;	

	/**
	 * The ICommand interface creates the contract for objects that implement the command pattern.
	 */
	public interface ICommand extends IDisposable
	{

		/**
		 * Executes the command.
		 */
		function execute(e:*, ...rest:Array):void;
	}
}