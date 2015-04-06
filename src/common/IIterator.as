package common
{
	public interface IIterator
	{
		function hasNext():Boolean;
		
		function next():Object;
		
		function reset():void;
	}
}