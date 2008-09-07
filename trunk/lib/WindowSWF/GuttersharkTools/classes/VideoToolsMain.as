package  
{
	import net.guttershark.display.controls.buttons.MovieClipButton;
	import net.guttershark.util.MovieClipUtils;		

	public class VideoToolsMain extends BaseToolMain
	{
		public var preview:MovieClipButton;
		public var akamai:MovieClipButton;

		public function VideoToolsMain()
		{
			super();
			MovieClipUtils.SetButtonMode(true,preview,akamai);
		}	}}