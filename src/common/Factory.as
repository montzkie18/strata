package common
{
	import flash.utils.Dictionary;

	public class Factory
	{
		private var classMap:Dictionary;
		
		public function Factory()
		{
			classMap = new Dictionary(true);
		}
		
		public function addClassType(type:Enum, objClass:Class):void
		{
			classMap[type] = objClass;
		}
		
		public function requestObject(type:Enum, ...params):Object
		{
			var objClass:Class = classMap[type];
			if(objClass != null){
				var obj:Object;
				try{
					obj = instantiate(objClass, params);
				}catch(e:Error){
					trace("Factory::requestObject() failed.\n" + e.getStackTrace());
				}
				return obj;
			}else{
				return null;
			}
		}
		
		private function instantiate(objClass:Class, params:Array):Object
		{
			// supports up to four parameters
			var obj:Object;
			switch(params.length) {
				case 0:
					obj = new objClass(); break;
				case 1:
					obj = new objClass(params[0]); break;
				case 2:
					obj = new objClass(params[0], params[1]); break;
				case 3:
					obj = new objClass(params[0], params[1], params[2]); break;
				case 4:
					obj = new objClass(params[0], params[1], params[2], params[3]); break;
				case 5:
					obj = new objClass(params[0], params[1], params[2], params[3], params[4]); break;
				case 6:
					obj = new objClass(params[0], params[1], params[2], params[3], params[4],
									   params[5]); break;
				default:
					obj = new objClass(params[0], params[1], params[2], params[3], params[4], 
									   params[5], params[6]); break;
			}
			return obj;
		}
	}
}