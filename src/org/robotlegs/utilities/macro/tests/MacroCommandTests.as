package org.robotlegs.utilities.macro.tests
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import org.robotlegs.base.CommandMap;
	import org.robotlegs.base.MediatorMap;
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.macro.SubcommandDescriptor;
	import org.robotlegs.utilities.macro.tests.support.commands.CommandOne;
	import org.robotlegs.utilities.macro.tests.support.commands.ICommandBatchTest;
	import org.robotlegs.utilities.macro.tests.support.commands.SimpleParallelCommand;
	import org.robotlegs.utilities.macro.tests.support.commands.SimpleSequenceCommand;
	import org.robotlegs.utilities.macro.tests.support.events.MyMacroCommandEvent;
	import org.robotlegs.utilities.macro.tests.support.events.SimpleCommandEvent;
	import org.robotlegs.utilities.macro.tests.support.vo.CommandPayload;
	
	import spark.components.Group;
	import spark.core.SpriteVisualElement;

	public class MacroCommandTests implements ICommandBatchTest
	{	
		public static const PARALLEL_EVENT:String = 'parallelEvent';
		
		protected var eventDispatcher:IEventDispatcher;
		protected var commandExecuted:Boolean;
		protected var commandMap:ICommandMap;
		protected var injector:IInjector;
		protected var reflector:IReflector;
		protected var mediatorMap:MediatorMap;
		protected var contextView:DisplayObjectContainer;
		
		protected var commandOneExecutionStatus:String;
		protected var commandTwoExecutionStatus:String;
		protected var commandThreeExecutionStatus:String;
		protected var macroExecutionStatus:String;
		
		[Before]
		public function setUp():void
		{
			contextView = new Group();
			eventDispatcher = new EventDispatcher();
			injector = new SwiftSuspendersInjector();
			reflector = new SwiftSuspendersReflector();
			mediatorMap = new MediatorMap(contextView, injector, reflector);
			commandMap = new CommandMap(eventDispatcher, injector, reflector);
			
			injector.mapValue(ICommandBatchTest, this);
			injector.mapValue(ICommandMap, commandMap);
			injector.mapValue(IInjector, injector);
			injector.mapValue(IMediatorMap, mediatorMap);
			injector.mapValue(IEventDispatcher, eventDispatcher);
			injector.mapValue(DisplayObjectContainer, contextView);
		}
		
		[After]
		public function tearDown():void
		{
			injector.unmap(ICommandBatchTest);
			injector.unmap(ICommandMap);
			injector.unmap(IInjector);
			injector.unmap(IMediatorMap);
			injector.unmap(IEventDispatcher);
			injector.unmap(DisplayObjectContainer);
			resetExecutionStatuses();
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		
		//////////////////////////////////////
		//  Parallel Tests
		//////////////////////////////////////
		
		
		[Test(async)]
		public function parallel_allComplete():void {
			assetNoCommandsHaveExecuted();
			eventDispatcher.addEventListener(MyMacroCommandEvent.MY_PARALLEL_FINISHED, 
				Async.asyncHandler(this, parallel_allCompleteHandler, 5000, null, handleTimeout), false, 0, true);
			commandMap.execute(SimpleParallelCommand, new CommandPayload(), CommandPayload);
		}
		
		protected function parallel_allCompleteHandler(e:MyMacroCommandEvent, object:Object):void {
			Assert.assertEquals("Command One should have executed successfully", commandOneExecutionStatus, SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
			Assert.assertEquals("Command Two should have executed successfully", commandTwoExecutionStatus, SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
			Assert.assertEquals("Command Three should have executed successfully", commandThreeExecutionStatus, SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
			Assert.assertEquals("The parallel command should have executed successfully", macroExecutionStatus, SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
		}
		
		
		[Test(async)]
		public function parallel_atomicOneFail():void {
			assetNoCommandsHaveExecuted();
			eventDispatcher.addEventListener(MyMacroCommandEvent.MY_PARALLEL_FINISHED, 
				Async.asyncHandler(this, parallel_atomicOneFailHandler, 5000, null, handleTimeout), false, 0, true);
			commandMap.execute(SimpleParallelCommand, new CommandPayload(true), CommandPayload);
		}
		
		protected function parallel_atomicOneFailHandler(e:MyMacroCommandEvent, object:Object):void {
			Assert.assertEquals("Command One should have executed successfully", commandOneExecutionStatus, SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
			Assert.assertEquals("Command Two should have failed", commandTwoExecutionStatus, SubcommandDescriptor.EXECUTED_UNSUCCESSFULLY);
			Assert.assertEquals("Command Three should have executed successfully", commandThreeExecutionStatus, SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
			Assert.assertEquals("The parallel command should have executed successfully", macroExecutionStatus, SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
		}
		
		[Test(async)]
		public function parallel_nonAtomicOneFail():void {
			assetNoCommandsHaveExecuted();
			eventDispatcher.addEventListener(MyMacroCommandEvent.MY_PARALLEL_FINISHED, 
				Async.asyncHandler(this, parallel_nonAtomicOneFailHandler, 5000, null, handleTimeout), false, 0, true);
			commandMap.execute(SimpleParallelCommand, new CommandPayload(true, false), CommandPayload);
		}
		
		protected function parallel_nonAtomicOneFailHandler(e:MyMacroCommandEvent, object:Object):void {
			Assert.assertEquals("Command One should have executed successfully", commandOneExecutionStatus, SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
			Assert.assertEquals("Command Two should have failed", commandTwoExecutionStatus, SubcommandDescriptor.EXECUTED_UNSUCCESSFULLY);
			Assert.assertEquals("Command Three should have executed successfully", commandThreeExecutionStatus, SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
			Assert.assertEquals("The parallel command should have failed", macroExecutionStatus, SubcommandDescriptor.EXECUTED_UNSUCCESSFULLY);
		}
		
		
		//////////////////////////////////////
		//  Sequence Tests
		//////////////////////////////////////
		
		
		[Test(async)]
		public function sequence_allComplete():void {
			assetNoCommandsHaveExecuted();
			eventDispatcher.addEventListener(MyMacroCommandEvent.MY_SEQUENCE_FINISHED, 
				Async.asyncHandler(this, sequence_allCompleteHandler, 5000, null, handleTimeout), false, 0, true);
			commandMap.execute(SimpleSequenceCommand, new CommandPayload(), CommandPayload);
		}
		
		protected function sequence_allCompleteHandler(e:MyMacroCommandEvent, object:Object):void {
			Assert.assertEquals("Command One should have executed successfully", commandOneExecutionStatus, SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
			Assert.assertEquals("Command Two should have executed successfully", commandTwoExecutionStatus, SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
			Assert.assertEquals("Command Three should have executed successfully", commandThreeExecutionStatus, SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
			Assert.assertEquals("The parallel command should have executed successfully", macroExecutionStatus, SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
		}
		
		
		[Test(async)]
		public function sequence_atomicOneFail():void {
			assetNoCommandsHaveExecuted();
			eventDispatcher.addEventListener(MyMacroCommandEvent.MY_SEQUENCE_FINISHED, 
				Async.asyncHandler(this, sequence_atomicOneFailHandler, 5000, null, handleTimeout), false, 0, true);
			commandMap.execute(SimpleSequenceCommand, new CommandPayload(true), CommandPayload);
		}
		
		protected function sequence_atomicOneFailHandler(e:MyMacroCommandEvent, object:Object):void {
			Assert.assertEquals("Command One should have executed successfully", commandOneExecutionStatus, SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
			Assert.assertEquals("Command Two should have failed", commandTwoExecutionStatus, SubcommandDescriptor.EXECUTED_UNSUCCESSFULLY);
			Assert.assertEquals("Command Three should have executed successfully", commandThreeExecutionStatus, SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
			Assert.assertEquals("The parallel command should have executed successfully", macroExecutionStatus, SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
		}
		
		[Test(async)]
		public function sequence_nonAtomicOneFail():void {
			assetNoCommandsHaveExecuted();
			eventDispatcher.addEventListener(MyMacroCommandEvent.MY_SEQUENCE_FINISHED, 
				Async.asyncHandler(this, sequence_nonAtomicOneFailHandler, 5000, null, handleTimeout), false, 0, true);
			commandMap.execute(SimpleSequenceCommand, new CommandPayload(true, false), CommandPayload);
		}
		
		protected function sequence_nonAtomicOneFailHandler(e:MyMacroCommandEvent, object:Object):void {
			Assert.assertEquals("Command One should have executed successfully", commandOneExecutionStatus, SubcommandDescriptor.EXECUTED_SUCCUSSFULLY);
			Assert.assertEquals("Command Two should have failed", commandTwoExecutionStatus, SubcommandDescriptor.EXECUTED_UNSUCCESSFULLY);
			Assert.assertEquals("Command Three should have never executed", commandThreeExecutionStatus, null);
			Assert.assertEquals("The parallel command should have failed", macroExecutionStatus, SubcommandDescriptor.EXECUTED_UNSUCCESSFULLY);
		}
		
		
		//////////////////////////////////////
		//  Helper Functions
		//////////////////////////////////////
		
		public function assetNoCommandsHaveExecuted():void {
			Assert.assertNull("Command One should NOT have a status event", commandOneExecutionStatus);
			Assert.assertNull("Command Two should NOT have a status event", commandTwoExecutionStatus);
			Assert.assertNull("Command Three should NOT have a status event", commandThreeExecutionStatus);
			Assert.assertNull("The Parallel Command should NOT have a status event", macroExecutionStatus);
		}
		
		public function resetExecutionStatuses():void {
			commandOneExecutionStatus = null;
			commandTwoExecutionStatus = null;
			commandThreeExecutionStatus = null;
			macroExecutionStatus = null;
		}
		
		public function setCommandOneExecutionStatus(status:String):void {
			commandOneExecutionStatus = status;
		}
		
		public function setCommandTwoExecutionStatus(status:String):void {
			commandTwoExecutionStatus = status;
		}
		
		public function setCommandThreeExecutionStatus(status:String):void {
			commandThreeExecutionStatus = status;
		}
		
		public function setMacroExecutionStatus(status:String):void {
			macroExecutionStatus = status;
		}
		
		protected function handleTimeout(object:Object):void {
			Assert.fail("The testing batch command never finished executing");
		}
		
	}
}