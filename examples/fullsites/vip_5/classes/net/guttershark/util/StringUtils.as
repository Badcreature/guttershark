package net.guttershark.util 
{
	
	/**
	 * The StringUtils class contains utility methods for strings.
	 */
	public class StringUtils 
	{
		
		/**
		 * Find the file type from a source path.
		 */
		public static function FindFileType(source:String):String
		{
			var fileType:String;
			var filenameRegEx:RegExp = new RegExp("\.([a-zA-Z0-9]*$)","i");
			var filematch:Array = source.match(filenameRegEx);
			if(filematch) fileType = filematch[1].toLowerCase();
			if(!fileType) return null;
			else return fileType;
		}	}}