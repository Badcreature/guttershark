package serviceexplorer.remoting
{
	import fl.data.DataProvider;	
	import fl.controls.dataGridClasses.DataGridColumn;	
	
	import flash.utils.Dictionary;	
	
	import core.BaseSubView;
	
	import fl.controls.Button;
	import fl.controls.DataGrid;
	
	import net.guttershark.util.MovieClipUtils;		

	public class RemotingView extends BaseSubView
	{

		public var deleteService:Button;
		public var newService:Button;
		public var editService:Button;
		public var deleteGateway:Button;
		public var newGateway:Button;
		public var editGateway:Button;
		public var callService:Button;
		public var exportXML:Button;
		public var callResults:RemotingCallResultsView;
		public var newRemotingGateway:NewRemotingGatewayView;
		public var remotingGateways:DataGrid;
		public var remotingServices:DataGrid;
		
		private var gatewayLookup:Dictionary;
		private var gateways:Array;

		public function RemotingView()
		{
			super();
			MovieClipUtils.SetVisible(false,callResults,newRemotingGateway);
			em.handleEvents(newGateway, this, "onNewGateway");
			gatewayLookup = new Dictionary();
			gateways = [];
			initUI();
		}
		
		override protected function initUI():void
		{
			var dgc:DataGridColumn = new DataGridColumn("url");
			dgc.headerText = "URL";
			dgc.width = 350;
			var dgc2:DataGridColumn = new DataGridColumn("objectEncoding");
			dgc2.headerText = "OBJECT ENCODING";
			remotingGateways.columns = [dgc,dgc2];
		}

		public function onNewGatewayClick():void
		{
			newRemotingGateway.show();
		}
		
		public function refresh():void
		{
			jp.trase("refresh");
			return;
			var dp:DataProvider = new DataProvider();
			var xml:XML = gm.servicesFromModelXML;
			if(!xml) return;
			if(xml.services.gateway == undefined) return;
			var r:XMLList = xml.services.gateway;
			for each(var g:XML in r)
			{
				jp.trase("gateway");
				var go:Object = {};
				var u:String;
				if(g.attribute("path") != undefined && g.attribute("url") == undefined)
				{
					jp.alert("The url attribute must be defined on a remoting node for the service explorer to work.");
					return;
				}
				go.url = g.@url.toString();
				go.objectEncoding = (g.@objectEncoding==undefined) ? "0" : g.@objectEncoding.toString();
				dp.addItem(go);
			}
			/*var s:XMLList = xml.services.children();
			for each(var n:XML in s)
			{
			}*/
		}	}}