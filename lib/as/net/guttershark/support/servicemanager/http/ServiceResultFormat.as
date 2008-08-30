package net.guttershark.support.servicemanager.http
{
	
	/**
	 * The ServiceResultFormat Class is an enumeration of values used with the ServiceManager.
	 */
	public class ServiceResultFormat 
	{
		/**
		 * URL Encoded variables response.
		 */
		public static const VARS:String = "variables";
		
		/**
		 * XML Response
		 */
		public static const XML:String = "text"; //property is actually text because this is all the URLLoader supports.
		
		/**
		 * Binary Response.
		 */
		public static const BIN:String = "binary";	}}