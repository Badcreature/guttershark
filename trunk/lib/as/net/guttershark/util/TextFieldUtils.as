package net.guttershark.util 
{
	public class TextFieldUtils	 
	{
		
		public static function SetCacheAsBitmap(value:Boolean, ...fields:Array):void
		{
			var i:int = 0;
			while(fields[i]!=null){fields[i].cacheAsBitmap=value;i++;};
		}	}}