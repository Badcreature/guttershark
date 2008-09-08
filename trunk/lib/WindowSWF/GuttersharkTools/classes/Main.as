package  
{
	import flash.display.Loader;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import adobe.utils.MMExecute;
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import net.guttershark.control.PreloadController;
	import net.guttershark.display.CoreSprite;
	import net.guttershark.managers.EventManager;
	import net.guttershark.support.eventmanager.ComboBoxEventListenerDelegate;
	import net.guttershark.support.preloading.Asset;
	import net.guttershark.util.XMLLoader;		
	
	public class Main extends CoreSprite 
	{

		public var tcb:ComboBox;
		private var txml:XML;
		private var xl:XMLLoader;
		private var shownSWF:Loader;
		private var fla:String;
		private var updateTimer:Timer;
		private var viewLookup:Dictionary;
		private var firstLoad:Boolean;

		public function Main()
		{
			super();
			firstLoad = true;
			restoreSharedObject();
			viewLookup = new Dictionary();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			updateTimer = new Timer(200);
			pc = new PreloadController();
			xl = new XMLLoader();
			em = EventManager.gi();
			em.addEventListenerDelegate(ComboBox,ComboBoxEventListenerDelegate);
			em.handleEvents(updateTimer,this,"onTi");
			em.handleEvents(xl, this, "onXML");
			em.handleEvents(tcb,this,"onToolsCB");
			em.handleEvents(pc,this,"onPC");
			xl.load(new URLRequest("guttershark_tools_support/tools.xml"));
			updateTimer.start();
			tcb.rowCount = 10;
		}
		
		private function restoreSharedObject():void
		{
			ml.sharedObject = SharedObject.getLocal("guttershark_toolbox");
		}
		
		public function onTiTimer():void
		{
			if(fla != MMExecute("fl.getDocumentDOM().name"))
			{
				fla = MMExecute("fl.getDocumentDOM().name");
				var s:BaseToolMain = BaseToolMain(shownSWF.content);
				if(!s.saved) s.save();
				s.changeFLA();
			}
		}
		
		public function onXMLComplete():void
		{
			em.disposeEventsForObject(xl);
			txml = xl.data;
			var dp:DataProvider = new DataProvider();
			var obj:Object;
			for each(var n:XML in txml.tool)
			{
				obj = {};
				obj.label = n.@label;
				obj.src = n.@src;
				obj.id = n.@id;
				dp.addItem(obj);
			}
			tcb.dataProvider = dp;
			loadSWF();
		}
		
		public function onToolsCBOpen():void
		{
		}
		
		public function onToolsCBChange():void
		{
			removeCurrentSWF();
			loadSWF();
		}
		
		public function onPCComplete():void
		{
			shownSWF = am.getSWF(am.lastLibraryName);
			var f:* = shownSWF.content;
			f.controller = this;
			f.id = txml.tool.(@src==pc.lastCompletedAsset.source).@id.toString();
			viewLookup[f.id] = shownSWF;
			showSWF();
		}
		
		protected function showSWF():void
		{
			shownSWF.y = 50;
			var s:* = shownSWF.content;
			if(!firstLoad) getTool("preferences").updateLastTool(s.id);
			firstLoad = false;
			addChild(shownSWF);
		}

		public function getTool(id:String):*
		{
			return viewLookup[id].content;
		}

		protected function loadSWF():void
		{
			if(tcb.selectedIndex == -1) tcb.selectedIndex = 0;
			var src:String = tcb.selectedItem.src;
			if(am.isAvailable(src))
			{
				shownSWF = am.getSWF(src);
				showSWF();
			}
			else
			{
				pc.addItems([new Asset(src)]);
				pc.start();
			}
		}
		
		protected function removeCurrentSWF():void
		{
			removeChild(shownSWF);
		}
		
		public function selectTool(id:String):void
		{
			for(var i:int = 0; i < tcb.dataProvider.length;i++)
			{
				if(tcb.getItemAt(i).id == id)
				{
					tcb.selectedIndex = i;
					break;
				}
			}
			removeCurrentSWF();
			loadSWF();
		}	}}