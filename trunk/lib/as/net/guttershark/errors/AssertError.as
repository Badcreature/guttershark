package net.guttershark.errors 
{
	
	/**
	 * The AssertError class defines a custom error that can be used with the
	 * Assert class.
	 * 
	 * @see net.guttershark.util.Assert Assert Class
	 */
	public class AssertError extends Error 
	{
		
		/**
		 * Constructor for AssertError instances.
		 * 
		 * @param	message	The error message.
		 * @param	id	An id for this error.
		 */
		public function AssertError(message:String, id:int = 0):void
		{
			super(message,id);
		}	}}