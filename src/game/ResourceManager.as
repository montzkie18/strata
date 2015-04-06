/*
 * 
	ResourceManager.as

	Author: Jojo Yango

	Handles all external game assets such as XML's, images, SWF, sounds, etc.
*/
package game
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class ResourceManager
	{
		public static const LOADER_ID_MAIN_XML:String = "ASSETS_XML_LOADER"
		public static const LOADER_ID_ASSET_XML:String = "ASSET_LIST_XML"
		public static const LOADER_ID_ASSETS_LIST:String = "ASSET_XML"
		public static const LOADER_ID_TEXT_XML:String = "TEXT_XML"
			
		public static const PATH_RESOUCES_ROOT:String = "../res/";
		
		private static var loader:BulkLoader;
		private static var assetList:XML;
		
		private static var _parent:MainGame;
				
		private static var gameStringsDict:Dictionary;
		private static var gameLanguage:String = "en";
		private static var gameCountry:String = "US";
		//private static const RES_TYPE_`
		
		public function ResourceManager()
		{
			//BulkLoader
			loader = null;
			//loadAssetList();
		}
		
		public static function loadAssetList(parent:MainGame):void
		{
			_parent = parent;
			
			loader = BulkLoader.getLoader(LOADER_ID_MAIN_XML);
			if(loader == null)
			{
				loader = new BulkLoader(LOADER_ID_MAIN_XML);
			}
			
			var textPath:String = PATH_RESOUCES_ROOT + "text/" + 
									gameLanguage + "-" + gameCountry + "/gametext.xml"; 
						
			loader.add(PATH_RESOUCES_ROOT +"assetlist.xml", {id:LOADER_ID_ASSET_XML});
			loader.add(textPath, {id:LOADER_ID_TEXT_XML});
			loader.addEventListener(BulkProgressEvent.COMPLETE, onLoadXMLComplete);
			
			loader.start();
		}
		
		private static function onLoadXMLComplete(e:Event):void
		{
			loader.removeEventListener(BulkLoader.COMPLETE, onLoadXMLComplete);
			
			assetList = loader.getContent(LOADER_ID_ASSET_XML);
			parseGameStringsXML(loader.getContent(LOADER_ID_TEXT_XML));
			
			if(assetList == null) return;
			
			loader = BulkLoader.getLoader(LOADER_ID_ASSETS_LIST);
			if(loader == null)
			{
				loader = new BulkLoader(LOADER_ID_ASSETS_LIST);
			}
			
			var objList:XMLList = assetList.asset;
			
			var i:int = 0;
			
			for(i = 0; i < objList.length(); i++)
			{
				var objElement:XML = objList[i];
				
				var strPath:String = "";
				
				if(objElement.attribute("global") == "true")
				{
					strPath = "../res/";
				}
				else
				{
					strPath = "../res/localized/" + gameLanguage + "-" + gameCountry + "/"; 
				}
				
				strPath = strPath + objElement.attribute("path") + objElement.text();
				
				trace("path: " + strPath);
				loader.add(strPath, { id:objElement.attribute("id") });				
			}
			
			loader.addEventListener(BulkProgressEvent.COMPLETE, onLoadAssetsComplete);
			loader.addEventListener(BulkProgressEvent.PROGRESS, onLoadAssetsProgress);
			
			loader.start();
		}
		
		private static function onLoadAssetsProgress(e:Event):void
		{
			
		}
		
		private static function onLoadAssetsComplete(e:Event):void
		{
			//trace("loading success!");
			
			_parent.initialize();
			_parent.startGame();
		}
		
		private static function parseGameStringsXML(gamestringsXML:XML) : void
		{
			gameStringsDict = new Dictionary();
			
			trace("Parsing texts ---------------------");
			
			if(gamestringsXML == null)
				return;
			
			var objList:XMLList;
			var objElement : XML;
			
			objList = gamestringsXML.String;
			
			var nMax:int = objList.length();
			var i:int = 0;
			for(i = 0; i < nMax; i++)
			{
				objElement = objList[i];
				var line:String = objElement.text();
				
				var nextLinePattern:RegExp = /\\n/g; // nextLinePattern = "\n"
				line = line.replace(nextLinePattern,"\n"); //replace all "\n" with return carriage
				
				var key:String = objElement.attribute("id");
				gameStringsDict[key] = line;
				
				trace("STRINGS: " + key + " -- " + line);
			}
			trace("------------------------------------");
		}
		
		//Returners (yeah!)
		
		public static function getAsset(keyName:String):*
		{
			var loader:BulkLoader = BulkLoader.getLoader(game.ResourceManager.LOADER_ID_ASSETS_LIST);
			return loader.getContent(keyName);
		}
		
		public static function getText(keyName:String):String
		{
			return gameStringsDict[keyName];
		}
		
		public static function getDefinitionClass(swfKeyName:String, definition:String):Class
		{				
			var mc:MovieClip = getAsset(swfKeyName);
			return mc.loaderInfo.applicationDomain.getDefinition(definition) as Class;
		}
	}
}