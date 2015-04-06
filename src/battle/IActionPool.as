package battle
{
	import tactics.TacticsInfo;

	public interface IActionPool
	{
		function doAction(info:TacticsInfo, actionReceiver:Object):void;
	}
}