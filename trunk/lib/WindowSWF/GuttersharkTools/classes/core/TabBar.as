package core 
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import net.guttershark.managers.EventManager;	

	public class TabBar
	{
		
		private var em:EventManager;
		private var shownView:*;
		private var viewLookup:Dictionary;
		private var tabs:Array;
		
		public function TabBar(tabObjs:Array, autoSelectIndex:int = 0)
		{
			em = EventManager.gi();
			tabs = tabObjs;
			viewLookup = new Dictionary();
			selectNone();
			select(autoSelectIndex);
			buildLookup();
			addEvents();
		}
		
		public function addTab(tabObj:Object):void
		{
			tabs.push(tabObj);
			destroyEvents();
			addEvents();
		}
		
		public function onTabClick(e:Event):void
		{
			hideView();
			shownView = viewLookup[e.target];
			showView();
		}
		
		public function selectNone():void
		{
			var l:int = tabs.length;
			for(var i:int =0; i < l; i++) tabs[i].view.hide();
		}
		
		public function select(index:int):void
		{
			hideView();
			shownView = tabs[index].view;
			showView();
		}
		
		private function buildLookup():void
		{
			var l:int = tabs.length;
			for(var i:int =0; i < l; i++) viewLookup[tabs[i].button] = tabs[i].view;
		}
		
		private function addEvents():void
		{
			var l:int = tabs.length;
			for(var i:int =0; i < l; i++) em.handleEvents(tabs[i].button,this,"onTab",true);
		}
		
		private function destroyEvents():void
		{
			var l:int = tabs.length;
			for(var i:int =0; i < l; i++) em.disposeEventsForObject(tabs[i].button);
		}
		
		private function showView():void
		{
			if(!shownView) return;
			shownView.show();
		}
		
		private function hideView():void
		{
			if(!shownView) return;
			shownView.hide();
		}
		
		public function dispose():void
		{
			shownView = null;
			viewLookup = null;
		}	}}