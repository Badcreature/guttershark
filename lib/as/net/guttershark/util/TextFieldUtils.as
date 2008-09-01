package net.guttershark.util 
{	import flash.text.TextFormat;		import flash.text.TextField;
	
	public class TextFieldUtils
	{
		
		public static function create(name:String,x:Number,y:Number,w:Number,h:Number,selectable:Boolean=false,multiline:Boolean=false,border:Boolean=false,embedFonts:Boolean=false,autoSize:String='left'):TextField
		{
			var tf:TextField = new TextField();
			tf.name = name;
			tf.x = x;
			tf.y = y;
			tf.width = w;
			tf.height = h;
			tf.selectable = selectable;
			tf.multiline = multiline;
			tf.border = border;
			tf.embedFonts = embedFonts;
			tf.autoSize = autoSize;
			return tf;
		}
		
		/**
		 * Set the <code>TextField</code> leading formatting.
		 */
		public static function setLeading(tf:TextField,space:Number = 0):void
		{
			var fmt:TextFormat = tf.getTextFormat();
			fmt.leading = space;			
			tf.setTextFormat(fmt);
		}
		
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
		}
		
		public static function SetAutoSize(value:String, ...fields:Array):void
		{
			var i:int = 0;
			while(fields[i]!=null){fields[i].autoSize=value;i++;};
		}	}}