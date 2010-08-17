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
	import org.robotlegs.utilities.macro.ParallelCommand;
	import org.robotlegs.utilities.macro.SubcommandDescriptor;
	import org.robotlegs.utilities.macro.SubcommandExecutionStatusEvent;
	import org.robotlegs.utilities.macro.tests.support.events.MyMacroCommandEvent;
	import org.robotlegs.utilities.macro.tests.support.vo.CommandPayload;
	
	public class SimpleParallelCommand extends ParallelCommand
	{
		[Inject]	public var testSuite:ICommandBatchTest;
		[Inject]	public var payload:CommandPayload;
		
		override public function execute():void {
			testSuite.setMacroExecutionStatus(SubcommandDescriptor.IS_EXECUTING);
			isAtomic = payload.isAtomic;
			addCommand(CommandOne);
			addCommand(CommandTwo, payload);
			addCommand(CommandThree);
			super.execute();
		}
		
		override protected function commandComplete():void {
			testSuite.setMacroExecutionStatus(SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
			dispatch(new MyMacroCommandEvent(MyMacroCommandEvent.MY_PARALLEL_FINISHED));
			super.commandComplete();
		}

		override protected function commandIncomplete():void {
			testSuite.setMacroExecutionStatus(SubcommandDescriptor.EXECUTED_UNSUCCESSFULLY);
			dispatch(new MyMacroCommandEvent(MyMacroCommandEvent.MY_PARALLEL_FINISHED));
			super.commandComplete();
		}
		
	}
}