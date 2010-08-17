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
	
	public class SimpleCommandEvent extends Event
	{
		public static const COMMAND_ONE_COMPLETE:String = "commandOneComplete";

		public static const COMMAND_TWO_COMPLETE:String = "commandTwoComplete";
		public static const COMMAND_TWO_FAILED:String = "commandTwoFailed";

		public static const COMMAND_THREE_COMPLETE:String = "commandThreeComplete";
		
		public var doFail:Boolean = false;
		
		public function SimpleCommandEvent(type:String, doFail:Boolean = false, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.doFail = doFail;
			super(type, bubbles, cancelable);
		}
	}
}