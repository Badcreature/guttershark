package net.guttershark.util 
{
	import flash.net.FileFilter;
	public class FileFilterUtils 
	{
		public static const BitmapFileFilter:FileFilter = new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png, *.bmp)","*.jpg;*.jpeg;*.gif;*.png;*.bmp");
		public static const TextTypeFileFilter:FileFilter = new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf"); 	}}