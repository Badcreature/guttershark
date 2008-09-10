package preferences
{
	import flash.text.TextField;
	
	import core.BaseToolMain;
	
	import fl.controls.Button;
	import fl.controls.CheckBox;	

	public class PreferencesMain extends BaseToolMain
	{
		
		public var flexHome:TextField;
		public var gsHome:TextField;
		public var autoLoadLastTool:CheckBox;
		public var autoSelectTracking:CheckBox;
		public var savebtn:Button;

		public function PreferencesMain()
		{
			super();
			em.handleEvents(this,this,"onThis");
			em.handleEvents(savebtn, this, "onSave");
		}
		
		public function onThisAddedToStage():void
		{
			em.disposeEventsForObject(this);
			initUI();
		}
		
		private function initUI():void
		{
			autoLoadLastTool.label = "                                                                             ";
			autoSelectTracking.label = "                                                                                                                    ";
			if(!ml.sharedObject) return;
			if(ml.sharedObject.data.autoLoadLastTool === true) autoLoadLastTool.selected = true;
			if(ml.sharedObject.data.autoSelectTracking === true) autoSelectTracking.selected = true;
			if(ml.sharedObject.data.guttersharkHome) gsHome.text = ml.sharedObject.data.guttersharkHome;
			if(ml.sharedObject.data.flexHome) flexHome.text = ml.sharedObject.data.flexHome;
			initFromPreferences();
		}
		
		private function initFromPreferences():void
		{
			if(ml.sharedObject.data.autoLoadLastTool && ml.sharedObject.data.lastTool) controller.selectTool(ml.sharedObject.data.lastTool);
		}
		
		public function updateLastTool(id:String):void
		{
			if(ml.sharedObject.data.autoLoadLastTool) ml.sharedObject.data.lastTool = id;
			ml.flushSharedObject();
		}
		
		public function onSaveClick():void
		{
			ml.sharedObject.data.autoLoadLastTool = autoLoadLastTool.selected;
			if(autoLoadLastTool.selected) ml.sharedObject.data.lastTool = controller.currentTool;
			ml.sharedObject.data.autoSelectTracking = autoSelectTracking.selected;
			ml.sharedObject.data.guttersharkHome = gsHome.text;
			ml.sharedObject.data.flexHome = flexHome.text;
			ml.flushSharedObject();
		}	}}