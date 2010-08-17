/**
 *  Macro commands example usage in the Robot Legs Framework
 * 
 * Any portion of this may be reused for any purpose where not 
 * licensed by another party restricting such use. 
 * 
 * Please leave the credits intact.
 * 
 * Chase Brammer
 * http://chasebrammer.com
 * cbrammer@gmail.com
 */

package org.robotlegs.utilities.macro.tests.support.commands
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.robotlegs.utilities.macro.AsyncCommand;
	import org.robotlegs.utilities.macro.SubcommandDescriptor;
	import org.robotlegs.utilities.macro.tests.support.events.SimpleCommandEvent;
	
	public class CommandThree extends AsyncCommand
	{
		[Inject]	public var testSuite:ICommandBatchTest;
		
		override public function execute():void {
			var t:Timer = new Timer(100, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			t.start();
		}

		protected function onTimerComplete(event:TimerEvent):void {
			dispatch(new SimpleCommandEvent(SimpleCommandEvent.COMMAND_THREE_COMPLETE));
			testSuite.setCommandThreeExecutionStatus(SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
			commandComplete();
		}
	}
}