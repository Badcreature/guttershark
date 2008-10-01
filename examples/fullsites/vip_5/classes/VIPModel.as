package  
{
	import scenes.bunker.RandomClip;	
	
	import net.guttershark.model.Model;		

	public class VIPModel
	{
		
		protected static var instance:VIPModel;
		private var md:Model;
		private var randomClips:XMLList;

		/*public var host:String = "http://www.guttershark.net/";
		public var imageUpload:String = host + "/vip/php/upload_image.php";
		public var imageUploadStore:String = host + "vip/php/uploaded/";
		public var crewSignup:String = host + "/vip/php/crew_submit.php";
		public var castSignup:String = host + "/vip/php/cast_submit.php";*/
		
		public static function gi():VIPModel
		{
			if(!instance) instance = new VIPModel();
			return instance;
		}
		
		public function VIPModel()
		{
			md = Model.gi();
		}
		
		public function getRandomClips():Array
		{
			var a:Array = new Array();
			randomClips = md.xml.randomclips;
			for each(var node:XML in randomClips.clip)
			{
				var r:RandomClip = new RandomClip(randomClips.@src + node.@src);
				if(node.@x != "" && node.@x != undefined) r.x = Number(node.@x);
				if(node.@y != "" && node.@y != undefined) r.y = Number(node.@y);
				if(node.@w != "" && node.@w != undefined) r.w = Number(node.@w);
				if(node.@h != "" && node.@h != undefined) r.h = Number(node.@h);
				a.push(r);
			}
			return a;
		}
		
		public function getRandomClipFrequence():Number
		{
			return Number(randomClips.@frequency);
		}	}}