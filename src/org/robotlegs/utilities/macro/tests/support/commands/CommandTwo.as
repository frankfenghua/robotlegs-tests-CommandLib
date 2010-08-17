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
	import org.robotlegs.utilities.macro.tests.support.vo.CommandPayload;
	
	/**
	 * This command extends AsyncCommand, which allows for asynchronous comamnds to be executed,
	 *  so things like webservices, timers, or almost anythign that waits on an event to execute
	 * 
	 * While this class is an Async Command and can run in a Parallel or Sequence coammand, it 
	 * can also be called directly like any other class without any other problem and will 
	 * still retain its memory reference until exeuction is complete
	 * 
	 * @author chbrammer
	 * 
	 */	
	public class CommandTwo extends AsyncCommand
	{
		[Inject]	public var payload:CommandPayload;
		[Inject]	public var testSuite:ICommandBatchTest;
		
		override public function execute():void {
			var t:Timer = new Timer(100, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			t.start();
		}

		private function onTimerComplete(e:TimerEvent):void {
			if(payload.doFail) {
				dispatch(new SimpleCommandEvent(SimpleCommandEvent.COMMAND_TWO_FAILED));
				testSuite.setCommandTwoExecutionStatus(SubcommandDescriptor.EXECUTED_UNSUCCESSFULLY);
				commandIncomplete();
			} else {
				dispatch(new SimpleCommandEvent(SimpleCommandEvent.COMMAND_TWO_COMPLETE));
				testSuite.setCommandTwoExecutionStatus(SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
				commandComplete();
			}
		}
	}
}