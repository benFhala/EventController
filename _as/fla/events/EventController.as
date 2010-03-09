/**
 * VERSION: 1.2
 * DATE: 04/09/2009
 * AS3 (AS2 version is also available)
 * UPDATES AND DOCUMENTATION AT: http://fla.as/ec
 * ...
 * @author Ben Fhala with support by Core ASS team @Everything Nice inc.
 * @site http://fla.as/ec
 * @date 03/01/2009
 * Copyright (c) 2009-2010 Everything Nice Inc.
 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php 
 **/ 

package _as.fla.events{
	import flash.utils.Dictionary;
	import flash.events.EventDispatcher;
	/**
 * 	EventController is the hart of EC.  offering exactly the same functionality plus useful 
 *  (but non-essential)  extra features to the AS3 event dispatching system. It doesn't come to replace the EventController
 *  but to hide the lower level details of managing the Events enabling quicker development with less memory leaks that are easier to find/control
 * 
 *  We recomend using the EC as everything you can do directly with the EventController can be done with less code on EC. 
 * 
 *  You can:
 *  <li> stop worriing about events and memory leaks </li>
 *  <li> mamange events without extra code and without changing your style of coding. </li>
 *  <li> create cluster names to events for quicker monitoring and removal </li> 
 *  <li> remove and add single events the same old and good way without worries if the event has been added already. 
 *		  the manager will validate that you can not add the same event more then once with the same params. </li>
 *  <li> remove all events of an object with one simple line of code </li>
 *  <li> remove all events of a cluster of objects with one simple line of code </li>
	**/
	public class EventController{
		public static const UNCLOSTERED:String = "unclostered";
		private static var _dic:Dictionary;
		private static var _clusters:Object;
		
		/**
		 * @private  
		 */		
		public function EventController(key:Narf){}
		
		/**
		 *  The main method to add events. For more Rapid development us EC.add
		 *  the classic development style in AS3 for adding events is:
		 *  obj.addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0.0, useWeakReference:Boolean = false):void
		 * 
		 *  please reffer to the information on addEventListerner at Adobes documentation for full imformation on Events. working with the event controller
		 *  you would instead padd the ojbect a the first param and the last param is a non mandatory cluster id for the object for example:
		 *  
		 *  EC.add(obj,type,listener,flase,0,false,"myCluster");
		 * 
		 *  as most of the time you will use the fefult settings for useCapture,priority and useWeakRefrence you can skip these params and quickly type:
		 * 
		 *  EC.add(obj,type,listener,"myCluster");
		 * 
		 *  the method retuns a Boolean value. true if th event has been added to the Que of events and flase if the event is 
		 *  already in the que. (like that it prevents you from adding the same listener to an object more then once).
		 * 
		 *  if you do not pass a cluster ID one will be assigned automaticly (EventController.UNCLUSTERED)
		 * 
		 * @param _obj - an EventDispatcher
		 * @param type - the type of Event (see Adobe docuementation)
		 * @param listener - the listener function (see Adobe documentation)
		 * @param useCapture - use Captuer(see Adobe documentation)
		 * @param priority - priority (see Adobe documentation)
		 * @param useWeakReference - use weak refrence (see Adobe docuementation)
		 * @param clusterID - a uniqe id for a cluster of events to be be used to removed items as a group when using EC.rem
		 * @return  returns a boolean value. 
		 * 
		 */		
		
		public static function addEventListener(_obj:Object,type:String, listener:Function, useCapture:* = false, priority:int = 0, useWeakReference:Boolean = false,clusterID:String=UNCLOSTERED):Boolean{
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
			return false; // its in allready not putting a new one in
		}
		
		/**
		 *  this is where the fun starts. this function holds all the logic you will ever need to remove events. the standard way of removing one event is the same as 
		 *  the regular way you are used to coding the sintax is a bit diffrent as the first param is the eventDispatcher object.
		 * 
		 *  in the standard way you would:
		 *  obj.removeEventListener(type,listner,false);
		 * 
		 * 	with EC you send the object as the first param(all other params are the same as in the adobe docuemtnation):
		 *  EC.rem(obj,type,listener,false);
		 * 
		 *  useCapture by defult would be false so you can remove an event, as long as it was added with the defult settings of flase for useCapture) this way:
		 *  EC.rem(obj,type,listener);
		 * 
		 *  EC will then return a boolean value if it manage to delete the event. if it couldn't find it it will return false.
		 * 
		 *  the nice more hiden powers here are if you want to remove all events for an object all you need to do is send the object:
		 * 
		 *  EC.rem(obj);
		 * 
		 *  if you're skilledin the powers of regexp and even if not you are going to love this feature and i think its the most powerful one in this baby. you can pass
		 *  a regexp value instead of a string and it will find all clusters that match that rule and get rid of them enabling you to create smart dynamic clustering to clusters.
		 *  in that way you can get rid of a full project/section in one line.
		 * 
		 *  EC.add(mc,MouseEvent.CLICK,onClick,"project_mc");
		 *  EC.add(menu,Event.CHANGE, onChange,"project_menu");
		 *  EC.add(menu,Event.RESIZE, onResize,"project_menu");
		 *  EC.add(this,Event.RESIZE, onStageResize, "project_stage");
		 *
		 *  //now that you have a few objects and varuis clusters lets get rid of all the clusters that contain the word 'project_'
		 *  EC.rem(/project_/); /done eveything will be deleted.
		 * 
		 *  EC will then find all events related to that object and remove them from the que.
		 * 
		 *  if you wish to remove all events asisiated with a cluster pass as the first param the clusterID:
		 *  
		 *  EC.rem("clusterID");
		 * 
		 * @param _obj - eventDispatcher or a cluster ID string
		 * @param type - the event type (only if using en eventDispatcher) else this param is ignored
		 * @param listener - the listener (only if using en eventDispatcher) else this param is ignored
		 * @param useCapture - the useCapture Boolean value (only if using en eventDispatcher) else this param is ignored
		 * @return Boolean value returned if an event was removed.
		 * 
		 */		
		public static function removeEventListener(_obj:*,type:String=null, listener:Function=null, useCapture:Boolean = false):Boolean{
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
		 * this is not part of the public EC methods as it is encapsualted in the EC.rem.
		 * if you wish to optimize your code and work directly with the EventController this method will remove object events. it will take only one param 
		 * the eventDispatcher object to be removed from the Que. 
		 * @param _obj - EventDispatcher
		 * 
		 */		
		public static function removeObjEvents(_obj:Object):void{
			var obj:EventDispatcher = _obj as EventDispatcher;
			var objRef:Object = getObjRef(obj)[false];
			
			for (var type:String in objRef)
				for (var listener:* in objRef[type])
					removeEventListener(obj,type,listener,false);
			
			objRef = getObjRef(obj)[true];
			for (type in objRef)
				for (listener in objRef[type])
					removeEventListener(obj,type,listener,true);
			
			removeFromClusters(obj);
			
			var dic:Dictionary = getDict();
			delete getDict()[obj];
		}
		
		
		/**
		 * this is not part of the public EC methods as it is encapsualted in the EC.rem.
		 * if you wish to optimize your code and work directly with the EventController this method will remove cluster events. it will take only one param 
		 * the cluster id(String value) to be removed from the Que.  
		 * @param clusterID
		 * 
		 */		
		public static function removeClusterEvents(clusterID:*):void{
			var clusters:Object = getClusters();
			if(clusterID is RegExp) 
				for(var clust:String in clusters){
					if(clust.match(clusterID)!=null) removeClusterEvents(clust);
				}
			else{
				for each(var item:Object in clusters[clusterID]){
					removeEventListener(item.obj,item.type,item.listener,item.useCapture);
				}
				delete clusters[clusterID];
			}
		}
				
		/**
		 * EC.log will output all current events and all current objects that are tracked by the EventController sorted based on clusters. 
		 * you can pass into the EC.log a cluster id. if a valid cluster id is passed the output will only output information related to the cluster tracked.
		 * you can pass in a regexp value as well and a break down related to clusters that mathc the regexp will output.
		 * @param clustID
		 * 
		 */		
		public static function log(clustID:*="clusters"):void{
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
		
		private static function removeFromClusters(obj:EventDispatcher):void{
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
		
		private static function getDict():Dictionary{
			if(!Boolean(_dic)) _dic= new Dictionary();
			return _dic;
		}
		
		private static function getClusters():Object{
			if(!Boolean(_clusters)) _clusters= {};
			return _clusters;
		}
		
		private static function getObjRef(obj:EventDispatcher):Object{
			var dic:Dictionary = getDict();
			if(!dic[obj]){
				dic[obj] = {};
				dic[obj][true]={};
				dic[obj][false]={};
				dic[obj].count = 0;
			}
			
			return dic[obj];
		}
		
		private static function removeIfEmpty(obj:EventDispatcher):void{
			var dic:Dictionary = getDict();
			if(dic[obj]){
				for each(var item:String in dic[obj][false]) return;
				for each(item in dic[obj][true]) return;
				dic[obj]=null;
				delete dic[obj];
			}
			
		}
		
		private static function isEventSet(obj:Object,type:String, listener:Function):Boolean{
			if(obj[type]){
				return Boolean(obj[type][listener]);
			}else{
				obj[type] = new Dictionary();
			}
			
			return false;
		}
		
		private static function addToCluster(obj:EventDispatcher,type:String, listener:Function, useCapture:Boolean,clusterID:String):void{
			var clusters:Object = getClusters();
			if(!Boolean(clusters[clusterID])) clusters[clusterID] = [];
			clusters[clusterID].push({obj:obj,type:type,listener:listener,useCapture:useCapture});
			
		}
		
		private static function _log(obj:*,title:String):* {
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
		
		
		private static function _oLog(_obj:Object):void{
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
class Narf{}