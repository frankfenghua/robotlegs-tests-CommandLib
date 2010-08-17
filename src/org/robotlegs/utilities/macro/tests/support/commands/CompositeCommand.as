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
	import org.robotlegs.utilities.macro.tests.support.events.MyMacroCommandEvent;
	import org.robotlegs.utilities.macro.tests.support.events.SimpleCommandEvent;
	import org.robotlegs.utilities.macro.examples.simpleExample.commands.CommandC;
	import org.robotlegs.utilities.macro.tests.support.commands.SimpleParallelCommand;
	import org.robotlegs.utilities.macro.tests.support.commands.SimpleSequenceCommand;
	import org.robotlegs.utilities.macro.ParallelCommand;
	
	/**
	 * Shows how a batch command can use other batch commands inside of it
	 *  
	 * @author chbrammer
	 * 
	 */	
	public class CompositeCommand extends ParallelCommand
	{
		public function CompositeCommand()
		{
			super();
			
			// This is where we add in all of the commands that we want execute
			addCommand(SimpleParallelCommand);
			addCommand(SimpleSequenceCommand);
			addCommand(CommandC, new SimpleCommandEvent(SimpleCommandEvent.COMMAND_C));
		}
		
		override public function execute():void
		{
			// Make sure to call the super here, because that is what kicks off the process
			super.execute();
			
		}
		
		/**
		 * This is the function we can override that gets called when we are finished 
		 * with all our commands
		 * 
		 */		
		override protected function commandComplete():void {
			//Finish up
			dispatch(new MyMacroCommandEvent(MyMacroCommandEvent.MY_COMPOSITE_FINISHED));
			
			// Always make sure you call the sumer so things can wrap up
			super.commandComplete();
		}
		
	}
}