package trackingtools 
{
	import core.BaseToolMain;
	
	import net.guttershark.display.controls.buttons.MovieClipButton;
	import net.guttershark.util.MovieClipUtils;
	
	import trackingtools.trackingmonitor.TrackingMonitorView;		

	public class TrackingToolsMain extends BaseToolMain
	{
		
		public var trackingMonitor:MovieClipButton;
		public var trackingMonitorView:TrackingMonitorView;

		public function TrackingToolsMain()
		{
			super();
			MovieClipUtils.SetButtonMode(true,trackingMonitor);
		}	}}