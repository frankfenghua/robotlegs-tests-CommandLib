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

package org.robotlegs.utilities.macro.tests.support.events
{
	import flash.events.Event;
	
	public class MyMacroCommandEvent extends Event
	{
		public static const MY_SEQUENCE_FINISHED:String = "mySequenceFinished";
		
		public static const MY_PARALLEL_FINISHED:String = "myParallelFinished";
		
		public static const MY_COMPOSITE_FINISHED:String = "myCompositeFinished";
		
		public static const MY_PROGRAMATIC_FINISHED:String = "myProgramaticFinished";

		public function MyMacroCommandEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}