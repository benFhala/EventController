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
	import com.hexagonstar.util.debug.Debug;
	/**
	* Enables you to log event information directly into your Alcon debugger . To enable this feature you need to send it to the plug method. After setting it up
	* all log events will go through Alcon.  The implementation was tested on <a href="http://blog.hexagonstar.com/downloads/alcon/">Alcon Debugger v3.1.3</a>.<br/><br/>
	* <pre name="code" class="js">
	* import _as.fla.events.LEC;
	* import _as.fla.events.log.AlconLog;
	*
	* LEC.plug(AlconLog); </pre></br>
	**/
	public class AlconLog extends ClassicLog{
		public function AlconLog(){
			}
		
		override protected function echo(str:String,data:*=null):void{
			 Debug.trace(str);
		}
	
	}
}