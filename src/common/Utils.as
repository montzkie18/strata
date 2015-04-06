package common
{
	import flash.geom.Point;
	
	public class Utils
	{
		public static function clearArray(array:Array):void
		{
			while(array.length > 0)
				array.pop();
		}
		
		public static function copyArray(array:Array):Array
		{
			var clone:Array = new Array();
			for each(var object:Object in array)
			{
				clone.push(object);
			}
			return clone;
		}
		
		public static function clamp(num:Number, min:Number, max:Number):Number
		{
			if(num > max)
				return max;
			else if(num < min)
				return min;
			else
				return num;
		}
		
		public static function isInsidePolygon(polygon:Array, pt:Point):Boolean
		{
			var numIntersects:int = 0;
			var xIntersect:Number;
			var p1:Point = polygon[0];
			var p2:Point;
			
			var numPoints:int = polygon.length;
			for(var i:int = 0; i < numPoints; i++)
			{
				p2 = polygon[i] as Point;
				if(pt.y > Math.min(p1.y, p2.y) && pt.y <= Math.max(p1.y, p2.y)
					&& pt.x <= Math.max(p1.x, p2.x) && p1.y != p2.y)
					{
						xIntersect = (pt.y - p1.y) * (p2.x - p1.x) / (p2.y - p1.y) + p1.x;
						if(p1.x == p2.x || pt.x <= xIntersect)
							numIntersects++;
					}
				p1 = p2;
			}
			
			if(numIntersects %2 != 0)
				return true;
			else
				return false;
		}
		
		public static function getRandomNumber(low:Number, high:Number):Number
		{
			return Math.floor(Math.random() * (1+high-low)) + low;
		}

	}
}