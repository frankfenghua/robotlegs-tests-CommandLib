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
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.macro.SubcommandDescriptor;
	import org.robotlegs.utilities.macro.tests.support.events.SimpleCommandEvent;
	
	public class CommandOne extends Command
	{
		[Inject]	public var testSuite:ICommandBatchTest;
		
		override public function execute():void {
			testSuite.setCommandOneExecutionStatus(SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
		}
	}
}