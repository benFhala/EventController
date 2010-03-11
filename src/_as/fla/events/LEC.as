/**
 * VERSION: 1.2.11
 * DATE: 04/09/2009
 * MOD: 03/11/2010
 * UPDATES AND DOCUMENTATION AT: http://fla.as/ec
 * ...
 * @author Ben Fhala 
 * contributors: Corban Baxter
 * @site http://fla.as/ec
 * @date 03/01/2009
 * Copyright (c) 2009-2010 Everything Nice Inc.
 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php 
 **/ 

package _as.fla.events{
	import flash.utils.Dictionary;
	import flash.events.EventDispatcher;
	/**
         * <p>Local Event Controller. enabling you to create local managers.The LocalEventController-LEC is the hub where all the operations of the EventController happen. why and when should you use the LEC or EC. the EC class is global,
         * enabling very quick and flexible designs without needing to worry about if an event is lost. you're control over your events are really up to you we put in all the
         * bells and whistles to enable you to control your events if through clusters/regex/single events or objects. we are leaving the power in your hands and cutting out
         * the manual monitoring you had to do in the traditional AS3 event system to single line commands that can do anything you want them to do.</p>
         * <p> with so much power you might be asking yourself why should i ever work with any other management system for events? <br/>
         * the answer to this question is hidden in the question, what if you don't want to have that power? what if your creating a component and you don't want other team memebers
         * removing your events, what if you want to adhere to the OOP encapsulation guides? we thought these are good concerns and thats why we wanted to give you even more power enabling you to limit your power
         * by creating multiple event controllers enabling you to put a scope around your EventController protecting it from others/yourself...
         * so the LEC is the local implementation of the global EventController. enabling you to create smaller managers and protect them from being accessed by other unauthorized members.</p>
         *
         * <p> all the implementation methods that are available on the EventController are available on the LEC. only instead of interacting direction with a static class you are
         * working with your local object. </p>
         * while you would work with the EC in this way:
         * <p>
         * import _as.fla.events.EC;<br/><br/>
         * EC.add(obj,type,listener); </p>
         * EC.rem(obj); // removing all object events</p>
         *
         * <p>with the LEC you will first create a new LCE object:<br/>
         * import _as.fla.events.LEC;<br/><br/>
         * var lec:LEC = new LEC();
         * lec.add(obj,type,listener); </p>
         * lec.remove(obj); // removing all object events</p>
         */  
	public class LEC{
		public static const UNCLUSTERED:String = "UNCLUSTERED";
		private var _dic:Dictionary;
		private var _clusters:Object;
		
		/**
		* @private
		*/
		public var rem:Function=remove;
		
		/**
		 * LEC constructor method. by creating local controls you get the power to decide how you want to manage you event system .
		 *
		 * with the LEC you will first create a new LCE object:
		 * <p>import _as.fla.events.LEC;<br/><br/>
		 * var lec:LEC = new LEC();<br/>
		 * lec.add(obj,type,listener);<br/>
		 * lec.remove(obj); // removing all object events</p>   
		 */
		public function LEC(){}
		
		/**
		 * @copy _as.fla.events.EventController#addEventListener() 
         * <p>with the LEC you will first create a new LCE object:<br/>
         * import _as.fla.events.LEC;<br/><br/>
         * var lec:LEC = new LEC();
         * lec.add(obj,type,listener); </p>
         * lec.remove(obj); // removing all object events</p>
		 * @param _obj an EventDispatcher
         * @param type the type of Event*
         * @param listener the listener function*
         * @param useCapture use Captuer*
         * @param priority priority*
         * @param useWeakReference use weak refrence*
         * @param clusterID a uniqe id for a cluster of events to be be used to removed items as a group when using EC.rem
         * @return  returns a boolean value.
		 * @see _as.fla.events.EC#add()
		 * @see #UNCLUSTERED
		 * @see http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/events/EventDispatcher.html#addEventListener() * EventDispatcher.addEventListener()
		 * @throws TypeError if you send an object that does't extend the EventDispatcher a TypeError will trigger
         *
         */		
		
		public function add(_obj:Object,type:String, listener:Function, useCapture:* = false, priority:int = 0, useWeakReference:Boolean = false,clusterID:String=UNCLUSTERED):Boolean{
			if(useCapture is String){ //to help skip filling the full form
				clusterID = useCapture;
				useCapture = false;
			}
			
			var obj:EventDispatcher = _obj as EventDispatcher;
			var objRef:Object = getObjRef(obj)[useCapture];
			if(!isEventSet(objRef,type,listener)){
				getObjRef(obj).count++;
				objRef[type][listener]=true;
				obj.addEventListener(type, listener, useCapture, priority, useWeakReference);
				if(Boolean(clusterID)) addToCluster(obj,type, listener, useCapture,clusterID);
				
				return true; //event added
			}
			return false; // its in already not putting a new one in
		}
		
		/**
         *
         * @copy _as.fla.events.EventController#addEventListener() 
         * <p>with the LEC you will first create a new LCE object:<br/>
         * import _as.fla.events.LEC;<br/><br/>
         * var lec:LEC = new LEC();
         * lec.add(obj,type,listener); </p>
         * lec.remove(obj); // removing all object events</p>
		 * @param _obj eventDispatcher or a cluster ID string
         * @param type the event type (only if using en eventDispatcher) else this param is ignored
         * @param listener the listener (only if using en eventDispatcher) else this param is ignored
         * @param useCapture the useCapture Boolean value (only if using en eventDispatcher) else this param is ignored
         * @return Boolean value returned if an event was removed.
         * @see _as.fla.events.EC#rem()
		 * @see #removeObjEvents()
		 * @see #removeClusterEvents()
		 * @see flash.events.EventDispatcher#removeEventListener()
		 *
         */
		public function remove(_obj:*,type:String=null, listener:Function=null, useCapture:Boolean = false):Boolean{
			if(_obj is EventDispatcher){
				if(type){
					var obj:EventDispatcher = _obj as EventDispatcher;
					var objRef:Object = getObjRef(obj)[useCapture];
					var isEvent:Boolean = isEventSet(objRef,type,listener);
					if(isEvent){
						getObjRef(obj).count--;
						delete objRef[type][listener];
						obj.removeEventListener(type,listener,useCapture);
						if(!getObjRef(obj).count) removeObjEvents(_obj);//clear from memory
					}
					
				}else removeObjEvents(_obj);
			}else removeClusterEvents(_obj);
			
			return isEvent;
		}
		
		
		/**
         * @private
         */                
		public function removeObjEvents(_obj:Object):void{
			var obj:EventDispatcher = _obj as EventDispatcher;
			var objRef:Object = getObjRef(obj)[false];
			
			for (var type:String in objRef)
				for (var listener:* in objRef[type])
					remove(obj,type,listener,false);
			
			objRef = getObjRef(obj)[true];
			for (type in objRef)
				for (listener in objRef[type])
					remove(obj,type,listener,true);
			
			removeFromClusters(obj);
			
			var dic:Dictionary = getDict();
			delete getDict()[obj];
		}
		
		
		/**
         * @private
		 *
         */       
		public function removeClusterEvents(clusterID:*):void{
			var clusters:Object = getClusters();
			if(clusterID is RegExp) 
				for(var clust:String in clusters){
					if(clust.match(clusterID)!=null) removeClusterEvents(clust);
				}
			else{
				for each(var item:Object in clusters[clusterID]){
					remove(item.obj,item.type,item.listener,item.useCapture);
				}
				delete clusters[clusterID];
			}
		}
				
		/**
         * @copy _as.fla.events.EventController#log() 
		 * to make a local log :
		 * <p>imoprt _as.fla.events.LEC;<br/><br/>
		 * var lec:LEC = new LEC();
		 * lec.add(obj,type,listener); 
		 * lec.log(); // the same params you can add in EC can be added to the LEC object</p>
         * @param clustID
         * @see _as.fla.events.EC#log()
		 *
         */         
		public function log(clustID:*="clusters"):void{
			var clusters:Object  = getClusters();
			var temp:Object = {};
			if(clustID is RegExp){
				for(var item:String in clusters) if(item.match(clustID)!=null) temp[item] = clusters[item]; 
			}else if(clustID is EventDispatcher){
				_oLog(clustID);
				return;//breaking out to a diffrent log function
			}if(clusters[clustID])
				temp[clustID] = clusters[clustID];
			else
				temp = clusters;
			
			_log(temp,clustID);
		}
		
		private function removeFromClusters(obj:EventDispatcher):void{
			var clusters:Object  = getClusters();
			var temp:Object = {};
			var arr:Array;
			for (var uid:String in clusters){//loop through clusters and remove all of object refrences
				arr = [];
				for(var i:int=0; i<clusters[uid].length;i++)
					if(clusters[uid][i].obj!=obj) arr.push(clusters[uid][i]);
				
				if(arr.length)temp[uid] = arr.concat();
			}
			_clusters = temp;
		}
		
		private function getDict():Dictionary{
			if(!Boolean(_dic)) _dic= new Dictionary();
			return _dic;
		}
		
		private function getClusters():Object{
			if(!Boolean(_clusters)) _clusters= {};
			return _clusters;
		}
		
		private function getObjRef(obj:EventDispatcher):Object{
			var dic:Dictionary = getDict();
			if(!dic[obj]){
				dic[obj] = {};
				dic[obj][true]={};
				dic[obj][false]={};
				dic[obj].count = 0;
			}
			
			return dic[obj];
		}
		
		private function removeIfEmpty(obj:EventDispatcher):void{
			var dic:Dictionary = getDict();
			if(dic[obj]){
				for each(var item:String in dic[obj][false]) return;
				for each(item in dic[obj][true]) return;
				dic[obj]=null;
				delete dic[obj];
			}
			
		}
		
		private function isEventSet(obj:Object,type:String, listener:Function):Boolean{
			if(obj[type]){
				return Boolean(obj[type][listener]);
			}else{
				obj[type] = new Dictionary();
			}
			
			return false;
		}
		
		private function addToCluster(obj:EventDispatcher,type:String, listener:Function, useCapture:Boolean,clusterID:String):void{
			var clusters:Object = getClusters();
			if(!Boolean(clusters[clusterID])) clusters[clusterID] = [];
			clusters[clusterID].push({obj:obj,type:type,listener:listener,useCapture:useCapture});
			
		}
		
		private function _log(obj:*,title:String):* {
			trace("=======================\n=======================\n"+title+"-----------------------");
			var indent:String="\t";
			for(var item:String in obj){
				trace(item );
				trace(indent + "\t\tobj\t\t\tname\t\t\ttype\t\tlistener\t\t\t\tuseCapture"); 
				for(var item2:String in obj[item]) trace(indent + obj[item][item2].obj +"\t\t"+
																  (obj[item][item2].obj.hasOwnProperty("name")?obj[item][item2].obj["name"]:"(NAME N/A)")+ "\t\t"+
																  obj[item][item2].type+"\t\t"+
																  obj[item][item2].listener +"\t\t"+
																  obj[item][item2].useCapture ); 
			}
			trace("-----------------------\nAll objects that are tracked by the EventController:");
			for(var dis:* in getDict()) trace("\t\t\t" +(dis.hasOwnProperty("name")?dis["name"]:"(NAME N/A)") + "   "+ dis);
			trace("=======================\n=======================");
	
		}
		
		
		private function _oLog(_obj:Object):void{
			var obj:EventDispatcher = _obj as EventDispatcher;
			var indent:String="\t";
			var objRef:Object = getObjRef(obj)[false];
			trace("=======================\n--  "+(obj.hasOwnProperty("name")?obj["name"]:"(NAME N/A)") + "  " +obj+ "  -----------------------");
			trace(indent + "\t\tobj\t\ttype\t\tlistener\t\t\t\tuseCapture"); 
			trace("------------------------------------------------------------------");
			for (var type:String in objRef)
				for (var listener:* in objRef[type])
					trace(indent + obj +"\t"+ type+"\t\t"+ listener +"\t\t"+ false ); 
					
			objRef = getObjRef(obj)[true];
			for (type in objRef)
				for (listener in objRef[type])
					trace(indent + obj +"\t"+ type+"\t\t"+ listener +"\t\t"+ true ); 
			trace("=======================");
		}
	}
}