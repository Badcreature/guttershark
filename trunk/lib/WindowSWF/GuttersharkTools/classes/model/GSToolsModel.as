package model  
{
	import net.guttershark.model.Model;	
	import net.guttershark.util.Singleton;		

	public class GSToolsModel
	{
		
		private static var inst:GSToolsModel;
		
		public var ml:Model;
		public var servicesFromModelXML:XML;
		
		public function GSToolsModel()
		{
			Singleton.assertSingle(GSToolsModel);
		}
		
		public static function gi():GSToolsModel
		{
			if(!inst) inst = Singleton.gi(GSToolsModel);
			return inst;
		}	}}