package org.robotlegs.utilities.macro.tests.support.vo
{
	public class CommandPayload
	{
		public var doFail:Boolean = false;
		public var isAtomic:Boolean = true;
		
		public function CommandPayload(doFail:Boolean = false, isAtomic:Boolean = true):void {
			this.doFail = doFail;
			this.isAtomic = isAtomic;
		}
	}
}