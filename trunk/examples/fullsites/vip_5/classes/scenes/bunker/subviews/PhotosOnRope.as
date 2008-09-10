package scenes.bunker.subviews
{
	
	import flash.display.MovieClip;
	
	public class PhotosOnRope extends MovieClip
	{
		
		public var ph0:Photo;
		public var ph1:Photo;
		public var ph2:Photo;
		public var ph3:Photo;
		public var ph4:Photo;
		public var next:MovieClip;
		public var previous:MovieClip;
		
		public function PhotosOnRope()
		{
			super();
			ph0.hit.buttonMode = true;
			ph1.hit.buttonMode = true;
			ph2.hit.buttonMode = true;
			ph3.hit.buttonMode = true;
			ph4.hit.buttonMode = true;
		}
		
		public function set displayClip(clip:LargePhotoDisplay):void
		{
			ph0.display = clip;
			ph1.display = clip;
			ph2.display = clip;
			ph3.display = clip;
			ph4.display = clip;
		}	}}