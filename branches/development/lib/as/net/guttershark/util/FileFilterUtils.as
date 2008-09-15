package net.guttershark.util 
{
	import flash.net.FileFilter;
	
	/**
	 * The FileFilterUtils class provides static variables that has predefined
	 * FileFilter instances, to save time.
	 */
	final public class FileFilterUtils 
	{
		
		/**
		 * A FileFilter containing Bitmap extensions. It contains .jpg,.jpeg,.gif,.png,.bmp.
		 */
		public static const BitmapFileFilter:FileFilter = new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png, *.bmp)","*.jpg;*.jpeg;*.gif;*.png;*.bmp");
		
		/**
		 * A FileFilter containing text extensions. It contains .txt,.rtf.
		 */
		public static const TextFileFilter:FileFilter = new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");
		
		/**
		 * A FileFilter containing more text extensions. It contains .doc,.docx.
		 */
		public static const ExtendedTextFileFilter:FileFilter = new FileFilter("Word Doc Files (*.doc, *.docx)", "*.doc;*.docx");
		
		/**
		 * A FileFilter containing xml extension. It contains .xml.
		 */
		public static const XMLFileFilter:FileFilter = new FileFilter("XML Files (*.xml)","*.xml");	}}