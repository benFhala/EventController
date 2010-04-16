﻿/**
 * VERSION: 1.3.02
 * DATE: 04/09/2009
 * MOD: 04/07/2010
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
		* Enables you to log event information directly into your Arthropod debugger. To enable this feature you need to send it to the plug method. After setting it up
		* all log events will go through Arthropod. The implementation was tested on  Carl Calderon's the <a href="http://arthropod.stopp.se/index2.php/?page_id=3">Arthropod Debugger v1.0</a>.
		* <br/> <br/>
		* <p> import _as.fla.events.LEC;<br/>
		* import _as.fla.events.log.ArthropodLog<br/><br/>
		* LEC.plug(ArthropodLog); <br/><br/>
	**/
	public class ArthropodLog extends ClassicLog{
		protected var _BASE:String="_base";
		private var clr:Object={};
		public function ArthropodLog(){
			super();
			clr[_LOG] = Debug.RED;
			clr[_OLOG] = Debug.YELLOW;
			clr[_BASE] = Debug.LIGHT_BLUE;
		}
		
		override protected function echo(str:String,data:*=null):void{
			Debug.log(str,clr[(clr[data])?data:_BASE]);
		}
	
	}
}