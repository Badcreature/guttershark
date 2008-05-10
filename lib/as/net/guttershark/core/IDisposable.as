package net.guttershark.core 
{

	/**
	 * The IDisposable interface creates the contract for objects that need to implement the disposable pattern.
	 */
	public interface IDisposable
	{
		
		/**
		 * Dispose of internal objects used for an instance.
		 */
		function dispose():void;
	}
}