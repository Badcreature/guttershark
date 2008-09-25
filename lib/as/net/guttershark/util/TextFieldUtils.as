package net.guttershark.util
{	import net.guttershark.util.Assertions;	
	
	import flash.display.Stage;	
	import flash.text.TextField;	import flash.text.TextFormat;		import net.guttershark.util.Singleton;		
	/**
	 * The TextFieldUtils class is a singleton that has utility
	 * methods for common operations with TextFields.
	 * 
	 * @see net.guttershark.util.Utilities Utilities class.
	 */
	final public class TextFieldUtils
	{
		
		/**
		 * Singleton instance.
		 */
		private static var inst:TextFieldUtils;
		
		/**
		 * Assertions singleton.
		 */
		private var ast:Assertions;

		/**
		 * Singleton access.
		 */
		public static function gi():TextFieldUtils
		{
			if(!inst) inst = Singleton.gi(TextFieldUtils);
			return inst;
		}
		
		/**
		 * @private
		 */
		public function TextFieldUtils()
		{
			Singleton.assertSingle(TextFieldUtils);
			ast = Assertions.gi();
		}

		/**
		 * Create a TextField.
		 * 
		 * @param name The textfield's name.
		 * @param x	The x position.
		 * @param y	The y position.
		 * @param w	The width.
		 * @param h	The height.
		 * @param selectable Whether or not the new text field should be selectable.
		 * @param multiline Whether or not the new text field is multiline.
		 * @param border Whether or not to show the 1 px black border around the new textfield.
		 * @param embedFonts Whether or not to embed fonts.
		 * @param autoSize The autosize value.
		 */
		public function create(name:String,x:Number,y:Number,w:Number,h:Number,selectable:Boolean=false,multiline:Boolean=false,border:Boolean=false,embedFonts:Boolean=false,autoSize:String='left'):TextField
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
		 * @param tf The textfield.
		 * @param space The leading space.
		 */
		public function setLeading(tf:TextField,space:Number = 0):void
		{
			ast.notNil(tf,"Parameter {tf} cannot be null");
			var fmt:TextFormat = tf.getTextFormat();
			fmt.leading = space;
			tf.setTextFormat(fmt);
		}
		
		/**
		 * Restrict a text field to email only characters.
		 * 
		 * @param tf The text field to restrict.
		 */
		public function restrictToEmail(tf:TextField):void
		{
			ast.notNil(tf,"Parameter {tf} cannot be null");
			tf.restrict = "a-zA-Z0-9@._-";
		}
		
		/**
		 * @private
		 * Restrict a text field to file path only characters (win|unix).
		 * 
		 * @param tf The text field to restrict.
		 */
		public function restrictToFilePath(tf:TextField):void
		{
			ast.notNil(tf,"Parameter {tf} cannot be null");
			tf.restrict = "a-zA-Z0-9./\ ";
		}
		
		/**
		 * Restrict a text field to class path characters only (a-zA-Z0-9_.).
		 * 
		 * @param tf The text field to restrict.
		 */
		public function restrictToClassPaths(tf:TextField):void
		{
			ast.notNil(tf,"Parameter {tf} cannot be null");
			tf.restrict = "a-zA-Z0-9_.";
		}
		
		/**
		 * @private
		 * Restrict a text field to file URI format only (file:///).
		 */
		public function restrictToFilURI(tf:TextField):void
		{
			ast.notNil(tf,"Parameter {tf} cannot be null");
			tf.restrict = "a-zA-Z0-9";
		}
		
		/**
		 * Restrict a text field to letters (lower/upper) and numbers only.
		 * 
		 * @param tf The text field to restrict.
		 */
		public function restrictLettersAndNumbers(tf:TextField):void
		{
			ast.notNil(tf,"Parameter {tf} cannot be null");
			tf.restrict = "a-zA-Z0-9";
		}
		
		/**
		 * Select all the text in a text field.
		 * 
		 * @param tf The TextField to select all in.
		 */
		public function selectAll(tf:TextField):void
		{
			ast.notNil(tf,"Parameter {tf} cannot be null");
			tf.setSelection(0,tf.length);
		}
		
		/**
		 * Deselect a text field.
		 * 
		 * @param tf The TextField to deselect.
		 */
		public function deselect(tf:TextField):void
		{
			ast.notNil(tf,"Parameter {tf} cannot be null");
			tf.setSelection(0,0);
		}
		
		/**
		 * Set the stage focus to the target text field and select all text in it.
		 * 
		 * @param stage The stage instance.
		 * @param tf The text field.
		 */
		public function focusAndSelectAll(stage:Stage,tf:TextField):void
		{
			ast.notNil(stage,"Parameter {stage} cannot be null");
			ast.notNil(tf,"Parameter {tf} cannot be null");
			stage.focus = tf;
			selectAll(tf);
		}	}}