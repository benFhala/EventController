/**
 * VERSION: 1.3.03
 * DATE: 04/09/2009
 * MOD: 04/08/2010
 * UPDATES AND DOCUMENTATION AT: http://fla.as/ec
 * ...
 * @author Ben Fhala 
 * contributors: Corban Baxter
 * @site http://fla.as/ec
 * @date 03/01/2009
 * Copyright (c) 2009-2010 Everything Nice Inc.
 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php 
 **/ 

package _as.fla.events.log{
	import nl.demonsters.debugger.MonsterDebugger;
	import _as.fla.events.LEC;
	/**
		* Enables you to log event information directly into your de Monster debugger. To enable this feature you need to send it to the plug method. After setting it up
		* all log events will go through Monster.  The implementation was tested on <a href="http://demonsterdebugger.com/">De Monster Debugger v2.5.1</a>.<br/><br/>
		* <pre name="code" class="js">
		* import _as.fla.events.LEC;
		* import _as.fla.events.log.MonsterDebuggerLog;
		*
		* LEC.plug(MonsterDebuggerLog);</pre><br/>
	**/
	public class MonsterDebuggerLog extends ClassicLog{
		public function MonsterDebuggerLog(){
			super();
		}
		
		override protected function echo(str:String,data:*=null):void{
			 MonsterDebugger.trace(LEC,str);
		}
	
	}
}