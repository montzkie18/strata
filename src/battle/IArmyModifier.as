package battle
{
	public interface IArmyModifier
	{
		function activate(actionPool:IActionPool, actionReceiver:Object):Boolean;
	}
}