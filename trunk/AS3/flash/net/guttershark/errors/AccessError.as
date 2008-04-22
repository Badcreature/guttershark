package net.guttershark.errors 
{
	
	/**
	 * The AccessError class is used when there are errors reading properties
	 * in classes that have been disposed of or any other general access error
	 * for properties.
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