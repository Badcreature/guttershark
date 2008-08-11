package net.guttershark.services 
{
	
	/**
	 * The ServiceResult class is passed to your onResult handler function
	 * from a ServiceManager call.
	 */
	public class ServiceResult
	{
		/**
		 * The response format. Format taken from ServiceResponseFormat.
		 */
		public var format:String;
		
		/**
		 * The result. It's not typed, because the result format can be multiple types.
		 */
		public var result:*;
		
		/**
		 * The original result data. From urlLoader.data.
		 */
		public var data:*;	}}