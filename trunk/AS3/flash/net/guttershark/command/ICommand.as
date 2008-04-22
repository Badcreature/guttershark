package net.guttershark.command
{
	import net.guttershark.core.IDisposable;	

	/**
	 * The ICommand interface is used to force any command implementation to conform to this common interface.
	 */
	public interface ICommand extends IDisposable
	{

		/**
		 * Executes the command.
		 */
		function execute(e:*, ...rest:Array):void;
	}
}