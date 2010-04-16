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
	import flash.utils.Dictionary;
	/**
		* Enables you to log event information directly into your internal trace . This is the classic event logging from EventController 1.2
		* All log events will go through the trace output.
		* <pre name="code" class="js">
		* <p> import _as.fla.events.LEC;
		* import _as.fla.events.log.ClassicLog;
		*
		* LEC.plug(ClassicLog); </pre><br/>
	**/
	public class ClassicLog{
		public const TYPE:String = "log";
		protected const _LOG:String = "_log";
		protected const _OLOG:String = "_oLog";
		
		public function _log(dic:Dictionary,obj:*,title:String):* {
			echo("=======================\n=======================\n"+title+"-----------------------");
			var indent:String="\t";
			for(var item:String in obj){
				echo(item ,_LOG);
				echo(indent + "\t\tobj\t\t\tname\t\t\ttype\t\tlistener\t\t\t\tuseCapture",_LOG); 
				for(var item2:String in obj[item]) echo(indent + obj[item][item2].obj +"\t\t"+
																  (obj[item][item2].obj.hasOwnProperty("name")?obj[item][item2].obj["name"]:"(NAME N/A)")+ "\t\t"+
																  obj[item][item2].type+"\t\t"+
																  obj[item][item2].listener +"\t\t"+
																  obj[item][item2].useCapture ,_LOG); 
			}
			echo("-----------------------\nAll objects that are tracked by the EventController:");
			//var dic:Object = that.getDict();
			for(var dis:* in dic) echo("\t\t\t" +(dis.hasOwnProperty("name")?dis["name"]:"(NAME N/A)") + "   "+ dis,_OLOG);
			echo("=======================\n=======================");
	
		}
		
		
		public function _oLog(o:Object,ref:Object):void{
			var indent:String="\t";
			var objRef:Object = ref[false];
			echo("=======================\n--  "+(o.hasOwnProperty("name")?o["name"]:"(NAME N/A)") + "  " +o+ "  -----------------------");
			echo(indent + "\t\tobj\t\ttype\t\tlistener\t\t\t\tuseCapture"); 
			echo("------------------------------------------------------------------");
			for (var type:String in objRef)
				for (var listener:* in objRef[type])
					echo(indent + o +"\t"+ type+"\t\t"+ listener +"\t\t"+ false ,_OLOG); 
					
			objRef = ref[true];
			for (type in objRef)
				for (listener in objRef[type])
					echo(indent + o +"\t"+ type+"\t\t"+ listener +"\t\t"+ true ,_OLOG); 
			echo("=======================");
		}
		
		protected function echo(str:String,arr:*=null):void{
			trace(str);
		}
		
	}
	
	
	
}