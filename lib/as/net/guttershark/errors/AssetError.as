package net.guttershark.errors 
{
	/**
	 * The AssetError Class defines a custom error that will be thrown
	 * from an AssetLibrary when an Asset is not available.
	 */
	public class AssetError extends Error 
	{
		
		/**
		 * Constructor for AssetError instances.
		 * @param	message	The message for this error.
		 * @param	id	The error id.
		 */
		public function AssetError(message:String, id:int = 0)
		{
			super(message,id);
		}	}}