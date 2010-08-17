package org.robotlegs.utilities.macro.tests.support.commands
{
	public interface ICommandBatchTest
	{
		function resetExecutionStatuses():void;
		function setCommandOneExecutionStatus(status:String):void;
		function setCommandTwoExecutionStatus(status:String):void;
		function setCommandThreeExecutionStatus(status:String):void;
		function setMacroExecutionStatus(status:String):void;
	}
}