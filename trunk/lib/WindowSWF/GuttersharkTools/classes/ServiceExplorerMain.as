package  
{
	import net.guttershark.display.views.BasicView;	
	import net.guttershark.display.controls.buttons.MovieClipButton;
	import net.guttershark.util.MovieClipUtils;
	import serviceexplorer.RemotingView;		

	public class ServiceExplorerMain extends BaseToolMain 
	{
		
		public var remoting:MovieClipButton;
		public var postget:MovieClipButton;
		public var wsdl:MovieClipButton;
		public var fileupload:MovieClipButton;
		public var loadFromModel:MovieClipButton;
		public var remotingView:RemotingView;
		private var shownView:BasicView;

		public function ServiceExplorerMain()
		{
			super();
			MovieClipUtils.SetButtonMode(true,remoting,postget,wsdl,fileupload,loadFromModel);
			remotingView.visible = false;
			em.handleEvents(remoting,this,"onRemoting");
		}
		
		public function onRemotingClick():void
		{
			trace("click");
			if(shownView == remotingView) return;
			removeShownView();
			shownView = remotingView;
			showView();
		}
		
		private function showView():void
		{
			if(!shownView) return;
			addChild(shownView);
			shownView.visible = true;
		}
		
		private function removeShownView():void
		{
			if(!shownView) return;
			removeChild(shownView);
			shownView.visible = false;
		}	}}