package  
{
	import flash.display.Sprite;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	import fl.controls.DataGrid;
	import fl.controls.dataGridClasses.DataGridColumn;		

	public class TrackingMonitor extends Sprite
	{
		
		private var lc:LocalConnection;
		public var dg:DataGrid;

		public function TrackingMonitor()
		{
			lc = new LocalConnection();
			lc.allowDomain("*");
			lc.addEventListener(StatusEvent.STATUS, ons);
			lc.connect("TrackingMonitor");
			lc.client = this;
			var dg1:DataGridColumn = new DataGridColumn("type");
			dg1.headerText = "Type";
			dg1.width = 100;
			var dg2:DataGridColumn = new DataGridColumn("tag");
			dg2.headerText = "Tag";
			dg.columns = [dg1,dg2];
		}
		
		public function tracked(msg:String):void
		{
			var d:Array = msg.split("::");
			var type:String = d[0];
			var tag:String = d[1];
			switch(type)
			{
				case "al":
					type = "Atlas";
					break;
				case "ga":
					type = "Google";
					break;
				case "wt":
					type = "Webtrends";
					break;
			}
			dg.addItem({type:type,tag:tag});
		}
		
		private function ons(se:StatusEvent):void
		{
			switch (se.level)
			{
                case "status":
                    break;
                case "error":
                    trace("TrackingMonitor could not connect. Code: " + se.code);
                    break;
            }
		}
	}}