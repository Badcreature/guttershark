package net.guttershark.util 
{	import flash.text.TextField;
	
	public class TextFieldUtils
	{
		
		public static function SetCacheAsBitmap(value:Boolean, ...fields:Array):void
		{
			var i:int = 0;
			while(fields[i]!=null){fields[i].cacheAsBitmap=value;i++;};
		}
		
		public static function SetTabIndexes(...fields:Array):void
		{
			var i:int = 0;
			while(fields[i]!=null){fields[i].tabIndex=i;i++;};
		}
		
		public static function RestrictEmail(tf:TextField):void
		{
			tf.restrict = "a-zA-Z0-9@._\-";
		}	}}