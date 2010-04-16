/**
 * VERSION: 1.3.03
 * DATE: 04/09/2009
 * MOD: 04/08/2010
 * UPDATES AND DOCUMENTATION AT: http://fla.as/ec
 * ...
 * @author Ben Fhala 
 * contributors: Corban Baxter
 * @site http://fla.as/ec
 * Copyright (c) 2009-2010 Everything Nice Inc.
 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php 
 **/ 

package _as.fla.events.log{
	import flash.utils.Dictionary;
	/**
		* enables you to create your own custom logging systems. there are two ways to create custom logging. the first is by extending the ClassicLog the way most of the 
		* live samples are doing it such as AlconLog. or by creating a new prototyle the DelecateLog class is a sample of a stripped down logger.
	**/
	public class DelegateLog{
		public const TYPE:String = "log";
		
		public function _log(dic:Dictionary,obj:*,title:String):* {
			trace(dic,obj,title); // put here your debugger code
		}
		
		
		public function _oLog(o:Object,ref:Object):void{
			trace(o,ref); //put here your debbugger code
		}
		
		
	}
	
	
	
}