package net.guttershark.services 
{
	
	/**
	 * The ServiceFault class is passed back to your onFault handler function
	 * from a ServiceManage call.
	 */
	public class ServiceFault 
	{
		
		/**
		 * The fault message.
		 */
		public var fault:*;
		
		/**
		 * The original result data. From urlLoader.data.
		 */
		public var data:*;	}}