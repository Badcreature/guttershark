package net.guttershark.managers 
{

	import flash.text.TextField;
	import flash.net.URLVariables;
	import net.guttershark.ui.controls.buttons.IToggleable;

	public class FormFieldManager
	{
		
		private var tfs:Array;
		private var cbs:Array;
		public var displayBoolsAsYesNo:Boolean;
		
		public function FormFieldManager()
		{
			tfs = new Array();
			cbs = new Array();
		}
		
		private function getOutputAsType(type:Class):*
		{
			var out:*;
			var i:int;
			if(type == URLVariables) out = new URLVariables();
			else if(type == Object) out = new Object();
			for(i = 0; i < tfs.length; i++) out[tfs[i].name] = tfs[i].text;
			for(i = 0; i < cbs.length; i++)
			{
				out[cbs[i].name] = cbs[i].toggled;
				if(displayBoolsAsYesNo && cbs[i].toggled) out[cbs[i].name] = "YES";
				else if(displayBoolsAsYesNo) out[cbs[i].name] = "NO";
			}
			return out;
		}
		
		public function addTextField(tf:TextField):void
		{
			tfs.push(tf);
		}
		
		public function addTextFields(tfs:Array):void
		{
			for(var i:int = 0; i < tfs.length; i++)
			{
				this.tfs.push(tfs[i]);
			}
		}
		
		public function addCheckbox(cb:IToggleable):void
		{
			cbs.push(cb);
		}
		
		public function addCheckboxes(cbs:Array):void
		{
			for(var i:int = 0; i < cbs.length; i++)
			{
				this.cbs.push(cbs[i]);
			}
		}
		
		public function getOutputAsURLVariables():URLVariables
		{
			return getOutputAsType(URLVariables);
		}
		
		public function getOutputAsObject():Object
		{
			return getOutputAsType(Object);
		}
		
		public function setTabs(clips:Array = null):void
		{
			var i:int;
			if(clips)
			{
				for(i = 0; i < clips.length; i++)
				{
				 	clips[i].tabIndex = i;
				}	
			}
			else
			{
				for(i = 0; i < tfs.length; i++)
				{
					tfs[i].tabIndex = i;
				}
				
				for(i = 0; i < cbs.length; i++)
				{
					cbs[i].tabIndex = i;
				}
			}
		}	}}