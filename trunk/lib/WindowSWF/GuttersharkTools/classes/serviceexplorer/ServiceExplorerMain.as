package  serviceexplorer
{
	import adobe.utils.MMExecute;
	
	import core.BaseToolMain;
	import core.TabBar;
	
	import net.guttershark.display.controls.buttons.MovieClipButton;
	import net.guttershark.util.MovieClipUtils;
	
	import serviceexplorer.postget.PostAndGetView;
	import serviceexplorer.remoting.RemotingView;
	import serviceexplorer.upload.UploadView;	

	public class ServiceExplorerMain extends BaseToolMain 
	{
		
		public var remoting:MovieClipButton;
		public var postget:MovieClipButton;
		public var wsdl:MovieClipButton;
		public var fileupload:MovieClipButton;
		public var loadFromModel:MovieClipButton;
		public var remotingView:RemotingView;
		public var uploadView:UploadView;
		public var postAndGetView:PostAndGetView;
		
		public function ServiceExplorerMain()
		{
			super();
			var tabs:Array = [
				{button:remoting,view:remotingView},
				{button:postget,view:postAndGetView},
				{button:fileupload,view:uploadView}
			];
			tabBar = new TabBar(tabs);
			MovieClipUtils.SetMouseChildren(false,remoting,postget,fileupload);
			MovieClipUtils.SetButtonMode(true,remoting,postget,wsdl,fileupload,loadFromModel);
			em.handleEvents(loadFromModel,this, "onLoadModel");
		}
		
		public function onLoadModelClick():void
		{
			var file:String = MMExecute("fl.browseForFileURL('open','Select a model.xml file')");
			if(file == null || file == "null") return;
			var fileContents:XML = jp.runScript(gm.ml.getPath("jsflFunctionLib"),{params:[file],escapeParams:true,method:"getFileContents",responseFormat:"xml",responseWasEscaped:true});
			remotingView.refresh();
			gm.servicesFromModelXML = fileContents;
			remotingView.refresh();
		}	}}