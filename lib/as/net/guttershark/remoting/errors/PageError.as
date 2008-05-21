package net.guttershark.remoting.errors 
{

	/**
	 * Generic error class for Page Error situations.
	 */
	public class PageError extends Error
	{
		
		/**
		 * Identifier for this page error.
		 */
		public static const PAGE_ERROR:String = "pageError";
		
		/**
		 * Constructor for PageError instances.
		 * @param	message	Message associated with this page error.
		 * @param	id	The id for this error object.
		 */
		public function PageError(message:String, id:int = 0)
		{
			super(message,id);
			this.name = PageError.PAGE_ERROR;
		}
	}
}
