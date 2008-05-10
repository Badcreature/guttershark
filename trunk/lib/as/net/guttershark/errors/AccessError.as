package net.guttershark.errors 
{
	
	/**
	 * The AccessError class defines an error that should be used when
	 * a property read or write error happens.
	 */
	public class AccessError extends Error
	{
		
		/**
		 * Constructor for AccessError instances.
		 * 
		 * @param	message	The error message.
		 * @param	id	An id for this error.
		 */
		public function AccessError(message:String, id:int = 0):void
		{
			super(message,id);
		}
	}
}