package net.guttershark.util 
{	import flash.text.TextFormat;		import flash.text.TextField;
	
	/**
	 * The TextFieldUtils Class has utility methods for
	 * common operations with TextFields.
	 */
	public class TextFieldUtils
	{
		
		/**
		 * Create a TextField.
		 * 
		 * @param	name	The textfield's name.
		 * @param	x	The x position.
		 * @param	y	The y position.
		 * @param	w	The width.
		 * @param	h	The height.
		 * @param	selectable	Whether or not the new text field should be selectable.
		 * @param	multiline	Whether or not the new text field is multiline.
		 * @param	border	Whether or not to show the 1 px black border around the new textfield.
		 * @param	embedFonts	Whether or not to embed fonts.
		 * @param	autoSize	The autosize value.
		 */
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
		 * Sets the <em><code>TextField</code></em> leading formatting.
		 * 
		 * @param	tf	The textfield.
		 * @param	space	The leading space.
		 */
		public static function setLeading(tf:TextField,space:Number = 0):void
		{
			var fmt:TextFormat = tf.getTextFormat();
			fmt.leading = space;
			tf.setTextFormat(fmt);
		}
		
		/**
		 * Set the cacheAsBitmap property on multiple textfields.
		 * 
		 * @param	value	The cacheAsBitmap value.
		 * @param	...fields	The textfields to set cacheAsBitmap on.
		 */
		public static function SetCacheAsBitmap(value:Boolean, ...fields:Array):void
		{
			var i:int = 0;
			while(fields[i]!=null){fields[i].cacheAsBitmap=value;i++;};
		}
		
		/**
		 * Set tab index's on multiple textfields.
		 * 
		 * @param	...fields	The textfields to set tabIndex on, it will be defined as 0->N.
		 */
		public static function SetTabIndexes(...fields:Array):void
		{
			var i:int = 0;
			while(fields[i]!=null){fields[i].tabIndex=i;i++;};
		}
		
		/**
		 * Restric a textfield to only email valid characters. 
		 */
		public static function RestrictEmail(tf:TextField):void
		{
			tf.restrict = "a-zA-Z0-9@._-";
		}
		
		/**
		 * Set the autoSize property on multiple textfields.
		 * 
		 * @param	value	The autoSize value.
		 * @param	...fields	The textfields to set the autoSize property on.
		 */
		public static function SetAutoSize(value:String, ...fields:Array):void
		{
			var i:int = 0;
			while(fields[i]!=null){fields[i].autoSize=value;i++;};
		}	}}