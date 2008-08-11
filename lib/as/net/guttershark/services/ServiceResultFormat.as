package net.guttershark.services 
{
	
	/**
	 * The ServiceResultFormat Class is an enumeration of values used with the ServiceManager.
	 */
	public class ServiceResultFormat 
	{
		public static const VARS:String = "variables";
		public static const XML:String = "text"; //property is actually text because this is all the URLLoader supports.
		public static const BIN:String = "binary";	}}