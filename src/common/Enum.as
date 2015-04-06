package common
{
		
	import flash.errors.IllegalOperationError;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * An abstact class to emulate Enum types
	 */
	public class Enum
	{
		/**
		 * Provides a mechanism to block unauthorized instantiation of this type.
		 */ 
		protected static var locks:Object = new Object();
		
		/**
		 * Function to call for each enum type declared and in static init.
		 */
		protected static function initEnumConstant(inType:Class):void
		{
			
			var className:String = getQualifiedClassName(inType);
			var typeXML:XML = describeType(inType);
			for each(var constant:XML in typeXML.constant)
			{
				inType[constant.@name]._name = constant.@name;
			}
			locks[className] = true;
		}
		
		/**
		 * Instance name for the Enum type
		 */ 
		private var _name:String;
		
		public function Enum() 
		{
			var className:String = getQualifiedClassName(this);
			if(locks[className])
			{
				throw new IllegalOperationError("Cannot instantiate enum of type " + className + ".\n");
			}
		}
		
		public function toString():String
		{
			return _name;
		}
	}
}