package net.guttershark.core 
{

	/**
	 * The IDisposable interface is used to help objects conform to a disposable pattern.
	 */
	public interface IDisposable
	{
		
		/**
		 * Dispose of internal objects used for an instance.
		 */
		function dispose():void;
	}
}
