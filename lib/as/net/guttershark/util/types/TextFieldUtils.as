package net.guttershark.util.types
{	import flash.text.TextField;
	import flash.text.TextFormat;		
	
	/**
	 * The TextFieldUtils Class has utility methods for
	 * common operations with TextFields.
	 */
	final public class TextFieldUtils
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
		 * Restrict a text field to only email valid characters.
		 * 
		 * @param tf The text field that should be restricted.
		 */
		public static function restrictEmail(tf:TextField):void
		{
			tf.restrict = "a-zA-Z0-9@._-";
		}
		
		/**
		 * Select all the text in a text field.
		 * 
		 * @param	tf	The text field to select all in.
		 */
		public static function selectAll(tf:TextField):void
		{
			tf.setSelection(0,tf.length);
		}	}}