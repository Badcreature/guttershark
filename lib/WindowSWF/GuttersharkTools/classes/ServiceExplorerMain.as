package  
{
	import net.guttershark.display.controls.buttons.MovieClipButton;
	import net.guttershark.util.MovieClipUtils;		

	public class ServiceExplorerMain extends BaseToolMain 
	{
		
		public var remoting:MovieClipButton;
		public var postget:MovieClipButton;
		public var wsdl:MovieClipButton;
		public var fileupload:MovieClipButton;

		public function ServiceExplorerMain()
		{
			super();
			MovieClipUtils.SetButtonMode(true,remoting,postget,wsdl,fileupload);
		}	}}