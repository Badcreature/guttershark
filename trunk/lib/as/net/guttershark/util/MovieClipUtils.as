package net.guttershark.util 
{
	import flash.display.MovieClip;		

	public class MovieClipUtils 
	{
		
		public static function SetButtonMode(value:Boolean, ...clips:Array):void
		{
			for each(var clip:MovieClip in clips)
			{
				clip.buttonMode = value;
			}
		}
		
		public static function SetVisible(value:Boolean, ...clips:Array):void
		{
			for each(var clip:MovieClip in clips)
			{
				clip.visible = value;
			}
		}
		
		public static function SetAlpha(value:Number, ...clips:Array):void
		{
			for each(var clip:MovieClip in clips)
			{
				clip.alpha = value;
			}
		}
			}}