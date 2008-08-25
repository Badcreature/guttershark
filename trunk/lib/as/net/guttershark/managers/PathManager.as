package net.guttershark.managers 
{
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	
	import net.guttershark.core.Singleton;	

	public class PathManager 
	{
		
		private static var inst:PathManager;
		private var paths:Dictionary;
		private var available:Boolean;
		
		public static function gi():PathManager
		{
			if(!inst) inst = Singleton.gi(PathManager);
			return inst;
		}
		
		public function PathManager()
		{
			Singleton.assertSingle(PathManager);
			paths = new Dictionary();
			if(PlayerManager.IsIDEPlayer() || PlayerManager.IsStandAlonePlayer())
			{
				trace("WARNING: Path logic is not coming from Javascript because the player is standable, an internal dictionary is used instead.");
				available = false;
				return;
			}
			available = true;
		}
		
		public function isDefined(path:String):Boolean
		{
			if(!available) return !(paths[path]==false);
			return ExternalInterface.call("net.guttershark.Paths.isDefined",path);
		}
				
		public function addPath(pathId:String, path:String):void
		{
			if(!available)
			{
				paths[pathId]=path;
				return;
			}
			ExternalInterface.call("net.guttershark.Paths.addPath",pathId,path);
		}
		
		public function getPath(pathId:String):String
		{
			if(!available)
			{
				if(!paths[pathId]) throw new Error("Path {"+pathId+"} not defined.");
				return paths[pathId];
			}
			return ExternalInterface.call("net.guttershark.Paths.getPath",pathId);
		}
		
		public function getFullPath(firstPathId:String,secondPathId:String):String
		{
			if(!available)
			{
				if(!paths[firstPathId]) throw new Error("Path {"+firstPathId+"} not defined.");
				//return rootURL+paths[pathId];
			}
			return ExternalInterface.call("net.guttershark.Paths.getFullPath",firstPathId);
		}	}}