package  
{
	import gs.TweenMax;	
	
	import flash.display.MovieClip;	
	import flash.display.Loader;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import adobe.utils.MMExecute;
	
	import core.BaseToolMain;
	import core.JSFLProxy;
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import model.GSToolsModel;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.control.PreloadController;
	import net.guttershark.managers.EventManager;
	import net.guttershark.model.Model;
	import net.guttershark.support.eventmanager.ComboBoxEventListenerDelegate;
	import net.guttershark.support.preloading.Asset;
	import net.guttershark.util.XMLLoader;	

	public class GSToolsMain extends DocumentController
	{

		public var tcb:ComboBox;
		public var changedFLAFlash:MovieClip;
		private var txml:XML;
		private var xl:XMLLoader;
		private var shownSWF:Loader;
		private var fla:String;
		private var updateTimer:Timer;
		private var viewLookup:Dictionary;
		private var firstLoad:Boolean;

		private var jp:JSFLProxy;
		private var gm:GSToolsModel;

		public function GSToolsMain()
		{
			super();
			firstLoad = true;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			changedFLAFlash.visible = false;
		}
		
		override protected function initModel():void
		{
			gm = GSToolsModel.gi();
			gm.ml = ml = Model.gi();
		}

		override protected function restoreSharedObject():void
		{
			gm.ml.sharedObject = SharedObject.getLocal("guttershark_toolbox");
		}
		
		override protected function initPathsForStandalone():void
		{
			var cfu:String = MMExecute("fl.configURI") || "NOT DEFINED";
			gm.ml.addPath("configURI",cfu);
			gm.ml.addPath("commands",cfu+"Commands/");
			gm.ml.addPath("supportJSFL",cfu+"Commands/guttershark_tool_support/");
			gm.ml.addPath("publish_with_excludes",gm.ml.getPath("commands")+"publish with excludes.jsfl");
			gm.ml.addPath("jsflFunctionLib",gm.ml.getPath("configURI")+"Commands/guttershark_tool_support/function_lib.jsfl");
		}
		
		override protected function setupComplete():void
		{
			initJSFLProxy();
			em.addEventListenerDelegate(ComboBox,ComboBoxEventListenerDelegate);
			pc = new PreloadController();
			xl = new XMLLoader();
			viewLookup = new Dictionary();
			updateTimer = new Timer(500);
			em.handleEvents(updateTimer,this,"onTi");
			em.handleEvents(xl, this, "onXML");
			em.handleEvents(tcb,this,"onToolsCB");
			em.handleEvents(pc,this,"onPC");
			xl.load(new URLRequest("guttershark_tools_support/tools.xml"));
			tcb.rowCount = 10;
			updateTimer.start();
		}
		
		private function initJSFLProxy():void
		{
			jp = JSFLProxy.gi();
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
			
		public function onTiTimer():void
		{
			var docsOpen:Boolean = jp.runScript(ml.getPath("jsflFunctionLib"),{method:"isDocumentOpen", responseFormat:"boolean"});
			if(!docsOpen) return;
			if(fla != MMExecute("fl.getDocumentDOM().name"))
			{
				fla = MMExecute("fl.getDocumentDOM().name");
				var s:BaseToolMain = BaseToolMain(shownSWF.content);
				if(!s.saved) s.save();
				s.changeFLA();
				flashChange();
			}
		}
		
		private function flashChange():void
		{
			changedFLAFlash.alpha = 0;
			changedFLAFlash.visible = true;
			TweenMax.from(changedFLAFlash,.3,{alpha:.6,onComplete:hideFlash});
		}
		
		private function hideFlash():void
		{
			changedFLAFlash.visible = false;
		}

		public function onToolsCBChange():void
		{
			flashChange();
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