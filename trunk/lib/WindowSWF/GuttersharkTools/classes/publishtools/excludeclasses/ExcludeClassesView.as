package publishtools.excludeclasses
{
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import adobe.utils.MMExecute;
	
	import core.BaseToolMain;
	
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.controls.DataGrid;
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.data.DataProvider;
	
	import net.guttershark.control.PreloadController;
	import net.guttershark.display.controls.buttons.MovieClipButton;
	import net.guttershark.support.preloading.Asset;
	import net.guttershark.support.preloading.events.AssetErrorEvent;
	import net.guttershark.util.MovieClipUtils;

	public class ExcludeClassesView extends BaseToolMain
	{
		
		public var refresh:Button;
		public var forFLA:TextField;
		public var addClassesFromLibrary:Button;
		public var removeClass:Button;
		public var excludedClasses:DataGrid;
		public var apiClasses:ComboBox;
		public var addLibClass:Button;
		public var addCompClass:Button;
		public var libDefaults:MovieClipButton;
		public var compDefaults:MovieClipButton;
		public var compClasses:ComboBox;
		public var publish:Button;
		public var savebtn:Button;
		private var allowSave:Boolean;
		public var autoSave:CheckBox;

		private var fla:String;
		private var flaPath:String;
		private var xmlFile:String;
		private var apiXML:String;
		private var componentXML:String;
		private var componentExcludes:XML;
		private var apiExcludes:XML;
		private var customExcludes:XML;
		private var dgdp:DataProvider;
		private var defClick:Boolean;
		private var compDefClick:Boolean;
		private var excludedClassesLookup:Dictionary;

		public function ExcludeClassesView()
		{
			super();
			apiXML = "guttershark_tools_support/publishtools/lib_excludes.xml";
			componentXML = "guttershark_tools_support/publishtools/component_excludes.xml";
			excludedClassesLookup = new Dictionary();
			excludedClasses.allowMultipleSelection = true;
			pc = new PreloadController();
			em.handleEvents(libDefaults, this, "onDef");
			em.handleEvents(compDefaults,this,"onCompDef");
			em.handleEvents(addLibClass,this,"onLibAdd");
			em.handleEvents(addCompClass,this,"onCompAdd");
			em.handleEvents(removeClass,this,"onRemove");
			em.handleEvents(addClassesFromLibrary,this,"onAddClassFromLib");
			em.handleEvents(publish,this,"onPublish");
			em.handleEvents(pc, this, "onPC");
			em.handleEvents(savebtn,this,"onSave");
			em.handleEvents(refresh,this,"onRefresh");
			MovieClipUtils.SetButtonMode(true,compDefaults,libDefaults);
			compDefClick = false;
			defClick = false;
			autoSave.label = "                                                                                        ";
			autoSave.selected = true;
			changeFLA();
		}
		
		public function onSaveClick():void
		{
			if(!saved) save();
		}
		
		public function onRefreshClick():void
		{
			if(pc.working) return;
			allowSave = false;
			changeFLA();
		}
		
		public function onPublishClick():void
		{
			if(!saved) save();
			jp.runScript(gm.ml.getPath("publish_with_excludes"));
		}
		
		public function onAddClassFromLibClick():void
		{
			var a:Array = jp.runScript(gm.ml.getPath("jsflFunctionLib"),{method:"getSelectedBaseClassesCSV",responseFormat:"array"});
			if(a.length < 1) return;
			if(a[0] == "") return;
			for(var i:int = 0; i < a.length; i++)
			{
				if(excluded(a[i])) return;
				var obj:Object = {};
				obj.label = a[i];
				obj.className = a[i];
				exclude(a[i]);
				excludedClasses.addItem(obj);
			}
		}
		
		public function onRemoveClick():void
		{
			if(excludedClasses.selectedIndex == -1) return;
			var cn:String;
			var i:int;
			var l:int = excludedClasses.selectedItems.length;
			if(l > 1)
			{
				var si:Array = excludedClasses.selectedItems;
				for(i=0; i < l; i++)
				{
					cn = si[i].className;
					excludedClasses.removeItem(si[i]);
					unexclude(cn);
				}
			}
			else
			{
				cn = excludedClasses.selectedItem.className;
				i = excludedClasses.selectedIndex;
				excludedClasses.removeItemAt(i);
				unexclude(cn);
				if(i >= 1) excludedClasses.selectedIndex = Math.max(0,i-1);
				else excludedClasses.selectedIndex = 0;
			}
		}
		
		public function onLibAddClick():void
		{
			var s:String = apiClasses.selectedItem.className;
			if(excluded(s)) return;
			excludedClasses.addItem({label:s,className:s});
			exclude(s);
		}
		
		public function onCompAddClick():void
		{
			var s:String = compClasses.selectedItem.className;
			if(excluded(s)) return;
			excludedClasses.addItem({label:s,className:s});
			exclude(s);
		}

		override public function changeFLA():void
		{
			resetExcludeClasses();
			doforFLA();
		}
		
		override public function save():void
		{
			if(!allowSave) return;
			var fileURI:String = "file://"+xmlFile;
			var x:String = "<?xml version='1.0' encoding='utf-8'?>\n<excludeAssets>";
			var dp:DataProvider = excludedClasses.dataProvider;
			for(var i:int = 0; i < dp.length; i++)
			{
				var obj:Object = excludedClasses.getItemAt(i);
				var n:String = '\n\t<asset name="'+obj.className+'"/>';
				x += n;
			}
			x += "\n</excludeAssets>";
			jp.runScript(gm.ml.getPath("jsflFunctionLib"),{method:"writeXML",params:[fileURI,escape(x)]});
			saved = true;
		}

		private function resetExcludeClasses():void
		{
			resetExcludes();
			var dgc:DataGridColumn = new DataGridColumn("className");
			dgc.headerText = "CLASSES TO EXCLUDE";
			excludedClasses.columns = [dgc];
			dgdp = new DataProvider();
			excludedClasses.dataProvider = dgdp;
		}
		
		private function doforFLA():void
		{
			fla = MMExecute("fl.getDocumentDOM().name");
			flaPath = MMExecute("fl.getDocumentDOM().path");
			xmlFile = flaPath.split(".fla").join("_exclude.xml");
			forFLA.text = "FOR FLA:  " + fla.toUpperCase();
			loadXML();
		}
		
		private function loadXML():void
		{
			pc.addItems([
				new Asset(xmlFile,"customExcludes"),
				new Asset(apiXML,"libExcludes"),
				new Asset(componentXML,"componentExcludes")
			]);
			pc.start();
		}

		public function onPCAssetError(aee:AssetErrorEvent):void
		{
			switch(aee.asset.libraryName)
			{
				case "customExcludes":
					//MMExecute("fl.trace('WARNING: Exclude xml file was not found, creating it.')");
					//var fileURI:String = "file://"+xmlFile;
					//MMExecute("FLfile.write('"+fileURI+"')");
					break;
				case "libExcludes":
					MMExecute("fl.trace('EXCLUDE CLASSES ERROR: The lib excludes XML file could not be found.')");
					break;
				case "componentExcludes":
					MMExecute("fl.trace('EXCLUDE CLASSES ERROR: The component excludes XML file could not be found.')");
					break;
			}
		}

		public function onPCComplete():void
		{
			customExcludes = am.getXML("customExcludes");
			apiExcludes = am.getXML("libExcludes");
			componentExcludes = am.getXML("componentExcludes");
			updateExcludeListFromCustomXML();
			updateApiExcludes();
			updateComponentExcludes();
			allowSave = true;
		}
		
		private function updateExcludeListFromCustomXML():void
		{
			for each(var n:XML in customExcludes.asset)
			{
				var obj:Object = {};
				obj.label = n.@name;
				obj.className = n.@name;
				exclude(n.@name);
				excludedClasses.addItem(obj);
			}
		}
		
		private function updateApiExcludes():void
		{
			var dp:DataProvider = new DataProvider();
			apiClasses.rowCount = 10;
			for each(var n:XML in apiExcludes.asset)
			{
				var obj:Object = {};
				obj.label = n.@name;
				obj.className = n.@name;
				dp.addItem(obj);
			}
			apiClasses.dataProvider = dp;
		}
		
		private function updateComponentExcludes():void
		{
			var dp:DataProvider = new DataProvider();
			compClasses.rowCount = 10;
			for each(var n:XML in componentExcludes.asset)
			{
				var obj:Object = {};
				obj.label = n.@name;
				obj.className = n.@name;
				dp.addItem(obj);
			}
			compClasses.dataProvider = dp;
		}

		public function onCompDefClick():void
		{
			if(compDefClick) return;
			compDefClick = true;
			var defaults:Array = [];
			var n:XML;
			for each(n in componentExcludes.asset)
			{
				if(!n.attribute("default")) continue;
				if(excluded(n.@name)) continue;
				if(n.@default != undefined && n.@default == "true") defaults.push(n);
			}
			for each(n in defaults)
			{
				var obj:Object = {};
				obj.className = n.@name;
				excludedClasses.addItem(obj);
				exclude(n.@name);
			}
		}

		public function onDefClick():void
		{
			if(defClick) return;
			defClick = true;
			var defaults:Array = [];
			var n:XML;
			for each(n in apiExcludes.asset)
			{
				if(!n.attribute("default")) continue;
				if(excluded(n.@name)) continue;
				if(n.@default != undefined && n.@default == "true") defaults.push(n);
			}
			for each(n in defaults)
			{
				var obj:Object = {};
				obj.className = n.@name;
				excludedClasses.addItem(obj);
				exclude(n.@name);
			}
		}
		
		private function resetExcludes():void
		{
			saved = false;
			excludedClassesLookup = new Dictionary();
		}

		private function unexclude(key:String):void
		{
			saved = false;
			if(autoSave.selected) save();
			excludedClassesLookup[key.toString()] = false;
		}

		private function exclude(key:String):void
		{
			saved = false;
			if(autoSave.selected) save();
			excludedClassesLookup[key.toString()] = true;
		}
		
		private function excluded(key:String):Boolean
		{
			if(excludedClassesLookup[key.toString()]==true) return true;
			return false;
		}	}}