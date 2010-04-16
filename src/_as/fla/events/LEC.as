﻿/**
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

package _as.fla.events{
	import flash.utils.Dictionary;
	import flash.events.IEventDispatcher;
	
	/**
	 * <p>Local Event Controller, enabling you to create local managers or interact with the global controller. The LEC is the hub where all the operations of
	 * the EventController happen. <i>Why and when should you use the LEC or EC?</i> The answer is simple if you are an experienced developer we recommend always
	 * working with the LEC. The LEC is everything EC is + more. To accesses the global scope(of the EC) its as simple as calling the LEC.getGloabal() method and
	 * it would return the global object working this way will cut down the amount of static method calls(we recommend storing this item in a local variable when working with it).</p>
	 * <p>Most of the time you would want to create a local event controller to protect your events from other developers and from yourself to do so all you
	 * need to do is create a new LEC and you have a new event management system in your hands. Empowering you with quick control and flexible designs without
	 * the leaky worries of the past. You're in control over your events more then you ever where before - what you do with that is really up to you.
	 * We put in all the bells and whistles to enable you to control your events if through clusters/regexp/single events or objects. we are leaving the power in your hands and cutting out
	 * the manual monitoring you had to do in the traditional AS3 event system to single line commands that can imagine them to do.</p>
	 * <p> With so much power you might be asking yourself <i>"why should i ever work with any other management system for events?"</i> <br/>
	 * The answer to this question is hidden in the question, what if you don't want to have that power? What if your creating a component
	 * and you don't want other team members removing your events, what if you want to adhere to the OOP encapsulation guide lines?
	 * We thought these are good concerns and that's why we wanted to give you even more power enabling you to limit your power by creating multiple event
	 * controllers enabling you to put a scope around your EventController protecting it from others and yourself...<br/><br/>
	 * So the LEC is the local implementation of the global EventController. Enabling you to create smaller managers and protect them from being accessed by unauthorized members.</p>
	 *
	 * <p> All the implementation methods that are available on the EventController are available on the LEC. Only instead of interacting with a static class you are
	 * working with your local object if in the global scope (using the LEC.getGlobal() or your localized event managers(new LEC()). </p>
	 * working with the EC you would call static methods, this way:
	 * <pre name="code" class="js">
	 * import _as.fla.events.EC;
	 *
	 * EC.add(obj,type,listener); 
	 * EC.rem(obj); // removing all object events
	 *
	 * </pre><p>With the LEC you will first create a location variable or capture the global object and then work with local objects:<br/><pre name="code" class="js">
	 * import _as.fla.events.LEC;
	 * 
	 * var lec:LEC = new LEC(); //if you want a self contained manager
	 * var global:LEC = LEC.getGlobal();//if you want to work with the main gloabal event scope
	 * lec.add(obj,type,listener);
	 * lec.remove(obj); // removing all object events
	 * </pre><br/>
	 * @copy _as.fla.events.EventController
	 */  
	public class LEC{
		/**
         *  Unclosered objects are by defult asosiated with this id. If you do not add a cluster id to an event one<br/> 
		 *  will automatically be generated as - UNCLUSTRED(a cluster of all unclustered items)<br/>
         * 
         *
		 **/
		public static const UNCLUSTERED:String = "UNCLUSTERED";
		private static var global:LEC;
		private var _d:Dictionary;
		private var _c:Object;//clusters
		private static var _p:Object;//plug
		
		/**
		* @private
		**/
		public var rem:Function=remove;
		
		/**
		 * LEC constructor method. by creating local controls you get the power to decide how you want to manage you event system .<br/><br/>
		 *
		 * To create a local LEC you will first create a new LCE instance:<br/>
		 * <pre name="code" class="js">import _as.fla.events.LEC;
		 *
		 * var lec:LEC = new LEC();
		 * lec.add(obj,type,listener);
		 * lec.remove(obj); // removing all object events
		 * </pre>
		 **/
		public function LEC(){}
		
		/**
		 * Returns the global scope(the same that is used in EC/EventController). <br/>
		 * Ideal for advance developers but recommened to all as it improves performence in run time.<br/>
		 * 
		 * <pre name="code" class="js">import _as.fla.events.LEC;
		 *
		 * var ec:LEC = LEC.getGlobal();
		 * ec.add(obj,type,listener);
		 * ec.remove(obj); // removing all object events   
		 * </pre>
		 * @return  returns a global LEC (same as EventController/LEC scope) .
		 */
		public static function getGlobal():LEC{
			if(!global) global = new LEC();
			return global;
		}
		
		/**
		* Enables you to add plugins in to the application. currently the supported plugin option is "log"
		* to setup the plugin all you need to do is send to the plug method the plugin class. to get the 
		* classic debugging featured that was introduced in EventController 1.1 you would :
		* <br/> <br/>
		* <pre name="code" class="js">import _as.fla.events.LEC;
		* import _as.fla.events.log.ClassicLog
		*
		* LEC.plug(ClassicLog); </pre>
		*
		* <p>for more informaion on how to create custom logs that can work with your favorate debuggin tool 
		* please reffer to the log package documentation.</p>
		* @param item - a plugin class
        * @see _as.fla.events.log.DelegateLog
		*/
		public static function plug(item:Class):void{
			if(!_p) _p={};
			var obj:Object = new item();
			_p[obj.TYPE] = obj;
		}
		
		
		 /**
         *  The main method to add events. <br/>
         * <p>The EventController.addEventListener and EC.add  have  the same functionality as they lean on - LEC.getGlobal().add. The shorthand was creating to make it quicker to build.
         * As both the EventController and the EC are in the same scope they are referencing the the same global scope manager(LEC.getGlobal). When you want to create local managers create a new LEC(local event controller).</p>
         *  The classic development style in AS3 for adding events is:<br/>
         *  <pre name="code" class="js">obj.addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0.0, useWeakReference:Boolean = false):void</pre>
         *
         * <p>Please refer to the information on addEventListerner at Adobes documentation for full information on Events.</p><p> Working with the Event Controller
         *  you would instead add the object a the first parameter and the last parameter(non mandatory cluster id for the object - but its the power house) for example:<br/>
         *
         *  <pre name="code" class="js">EC.add(obj,type,listener,false,0,false,"myCluster");</pre>
         *
         *  As most of the time you will use the defult settings for useCapture,priority and useWeakRefrence you can skip these parameters and quickly type:
         *
         * <pre name="code" class="js"> EC.add(obj,type,listener,"myCluster");</pre>
         *
         *  <p>The method reruns a Boolean value. true if the event has been added to the Que of events and false if the event is
         *  already in the Que.</p>
         *
         *  <p>If you do not pass a cluster ID one will be assigned automatically (UNCLUSTERED)</p>
         *  
         * <p>With the LEC you will first create a new LCE object:</p>
         * <pre name="code" class="js">import _as.fla.events.LEC;
         *
         * var lec:LEC = new LEC();
         * lec.add(obj,type,listener);
         * lec.remove(obj); // removing all object events</pre>
         *
         * @param obj an IEventDispatcher
         * @param type the type of Event*
         * @param listener the listener function*
         * @param useCapture use Captuer*
         * @param priority priority*
         * @param useWeakReference use weak refrence*
         * @param clusterID a uniqe id for a cluster of events to be be used to removed items as a group when using EC.rem
         * @return  returns a boolean value.
         * @see #addGroup()
         * @see #UNCLUSTERED
         * @see http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/events/IEventDispatcher.html#addEventListener() * IEventDispatcher.addEventListener()
         */     
		
		public function add(obj:IEventDispatcher,type:String, listener:Function, useCapture:* = false, priority:int = 0, useWeakReference:Boolean = false,clusterID:String=UNCLUSTERED):Boolean{
			if(useCapture is String){ //to help skip filling the full form
				clusterID = useCapture;
				useCapture = false;
			}
			
			var objRef:Object = getORef(obj)[useCapture];
			if(!isEventSet(objRef,type,listener)){
				getORef(obj).count++;
				objRef[type][listener]={p:priority,w:useWeakReference,c:clusterID};
				
				obj.addEventListener(type, listener, useCapture, priority, useWeakReference);
				if(Boolean(clusterID)) addToCluster(obj,type, listener, useCapture,clusterID);
				
				return true; //event added
			}
			return false; // its in already not putting a new one in
		}
		
		
		/**
		 * Add a group of events using an Array of events. you can create your own array<br/>
		 * or store the returned values of the remove methods(they return arrays with removed items).<br/>
		 * the signiture of an object in the array is :
         * <pre name="code" class="js">[{obj:obj,type:type,listener:listener,useCapture:useCapture}];
         * lec.remove(obj); // removing all object events</pre>
		 * @param arr an Array with event detail objects
         * @see #add()
		 *
         */		
		public function addGroup(arr:Array):void{
			for each(var o:Object in arr) 
				add(o.obj,o.type,o.listener,o.useCapture,o.p,o.useWeakRefrence,o.clusterID);
		}
		
		/**
         *  The only method you would need to remove events. This is where the fun starts. This function holds all the logic you will 
         *  ever need to remove events. The standard way of removing one event is the same as the regular way you are used to coding
		 *  the syntax with a small twist - The first parameter is an IEventDispatcher object.<br/><br/>
         *
         *  In the standard way you would:<br/>
         *  <pre name="code" class="js">obj.removeEventListener(type,listner,false);</pre>
         *
         *  With EC you send the object as the first param(all other params are the same as in the adobe docuemtnation):<br/>
         *  <pre name="code" class="js">EC.remove(obj,type,listener,false);</pre>
         *
         *  useCapture by defult would be false so you can remove an event, as long as it was added with the defult settings of flase for useCapture) this way:
         *  <pre name="code" class="js">EC.remove(obj,type,listener);</pre>
         *
         *  <p>EC will then return an Array listing the removed event/events if it manages to delete the event or an empty array if not.</p>
         *
         *  The nice hiden powers here are if you want to remove all events for an object your code to removing events has never looked more simple:</br>
         *
         *  <pre name="code" class="js">EC.remove(obj);</pre>
         *
         *  <p>If you're skilled in the powers of regexp(and even if not - now is a great time to start) you are going to love this feature.
         *  Its the most powerful one and most used one our end. Get ready for it, here it goes: you can pass a regexp value instead
         *  of a string and it will find all clusters that match that rule and get rid of them enabling you to create smart dynamic clustering
         *  to clusters. in other words why should we limit your creative develpment style instead we gave you the driver seat all we are doing
		 *  is enabling you to do what ever you want with events without the need to tinker with low level management
		 *  of single events (you can still do it, but why would you?).</p>

         *  <p>In that way you can get rid of a full project/section in one line.</p>
         *
         * <pre name="code" class="js">// some random events with a variety of clusters
         *  EC.add(mc,MouseEvent.CLICK,onClick,"project_mc");
         *  EC.add(menu,Event.CHANGE, onChange,"project_menu");
         *  EC.add(menu,Event.RESIZE, onResize,"project_menu");
         *  EC.add(this,Event.RESIZE, onStageResize, "project_stage");
         *
         *  //now that you have a few objects and varuis clusters 
		 *  //lets get rid of all the clusters that contain the word 'project_'
         *  EC.remove(/project_/); /done eveything will be deleted.</pre>
         *
         *  EC will then find all events related to that object and remove them from the que.<br/><br/>
         *
         *  If you wish to remove all events asisiated with a cluster pass as the first param the clusterID:<br/><br/>
         * 
         *  <pre name="code" class="js">EC.remove("clusterID");
		 *  </pre>
		 *  Working with the LEC is the exact same way but instead of working with a static class you will work with the object directly:<br/><br/>
		 *  <pre name="code" class="js">import _as.fla.events.LEC;
		 *  var g:LEC = LEC.getGlobal(); // get the global manager
		 *  g.remove(obj); //all the same methods in the EC work the same way in LEC.
         *  var lec:LEC = new LEC();// create a new local manager
		 *  lec.add(obj,EVENT,listener);
		 *  lec.remove(obj);</pre>
         * @param _obj - eventDispatcher or a cluster ID string
         * @param type - the event type (only if using en eventDispatcher) else this param is ignored
         * @param listener - the listener (only if using en eventDispatcher) else this param is ignored
         * @param useCapture - the useCapture Boolean value (only if using en eventDispatcher) else this param is ignored
         * @return Boolean value returned if an event was removed.
         * @see _as.fla.events.EC#rem()
		 * @see #removeEvent()
		 * @see #removeObjEvents()
		 * @see #removeClusterEvents()
		 * @see flash.events.IEventDispatcher#removeEventListener()
		 *
         */
		public function remove(_obj:*,type:String=null, listener:Function=null, useCapture:Boolean = false):Array{
			var aEvents:Array=[];
			if(_obj is IEventDispatcher){
				var obj:IEventDispatcher = _obj as IEventDispatcher;
				if(type)	aEvents.push(removeEvent(obj,type,listener,useCapture));
					else	aEvents =aEvents.concat(removeObjEvents(obj));
				
			}else aEvents =aEvents.concat(removeClusterEvents(_obj));
			
			return aEvents;
		}
		
		/**
		* Removes one event and cut down the checking logic to find what type of removal(quicker removal).
		* @param _obj IEventDispatcher
		* @param type the event type
		* @param listener the listener
		* @param useCapture the useCapture Boolean value(defult value is false)
		* @return Object with event information of the removed event
		**/
		
		public function removeEvent(obj:IEventDispatcher,type:String, listener:Function, useCapture:Boolean = false):Object{
			var data:Object;
			var objRef:Object = getORef(obj)[useCapture];
			var isEvent:Boolean = isEventSet(objRef,type,listener);
			if(isEvent){
				getORef(obj).count--;
				data = {obj:obj,type:type,listener:listener,
							  useCapture:useCapture,
							  p:objRef[type][listener].p,
							  w:objRef[type][listener].w,
							  c:objRef[type][listener].c};
				
				delete objRef[type][listener];
				obj.removeEventListener(type,listener,useCapture);
				if(!getORef(obj).count) removeObjEvents(obj);//clear from memory it has no events
				
			}
			return data;
		}
		
		
		/**
		* Removes all evets of one object.
		* @param _obj IEventDispatcher
		* @return Object with event information of the removed event
		**/           
		public function removeObjEvents(obj:IEventDispatcher):Array{
			var aEvents:Array=[];
			var objRef:Object = getORef(obj)[false];
			
			for (var type:String in objRef)
				for (var listener:* in objRef[type])
					aEvents.push(removeEvent(obj,type,listener,false));
			
			objRef = getORef(obj)[true];
			for (type in objRef)
				for (listener in objRef[type])
					aEvents.push(removeEvent(obj,type,listener,true));
			
			uncluster(obj);
			
			delete getDict()[obj];
			return aEvents;
		}
		
		
		/**
		* Removes all evets asosiated with a UID you can pass a string or a RegExp value
		* @param clusterID - a string or a RegExp value 
		* @return Array a list of all events that have been removed from the system
		**/          
		public function removeClusterEvents(clusterID:*):Array{
			var aEvents:Array=[];
			var clusters:Object = getClusters();
			if(clusterID is RegExp) 
				for(var clust:String in clusters){
					if(clust.match(clusterID)!=null) aEvents.splice(0,0,removeClusterEvents(clust));
				}
			else{
				for each(var item:Object in clusters[clusterID]){
					aEvents.push(removeEvent(item.obj,item.type,item.listener,item.useCapture));
				}
				delete clusters[clusterID];
			}
			return aEvents;
		}
				
		 /**
         * Output of all the current events/clusters/objects. Through the log you can track all that the EventController knows sorted based on cluster ids.
         * You can pass into the EC.log a cluster id. If a valid cluster id is passed the output will only output information related to the cluster tracked.
		 * by defult since EC 1.3 the Event Logging is set to be off by defult to save on file size and enable much more robust debugging then ever posible. 
		 * To get your classic debugging running all you need to do is set it up by adding a new plug:<br/><br/>
		 * <pre name="code" class="js">import _as.fla.events.LEC;
		 * import _as.fla.events.log.ClassicLog;
		 *
		 * LEC.plug(ClassicLog); //turns on loging. Removing this line will disable logging
		 * lec.getGlobal().log();// will return all running events in the global scope</pre>
         * You can pass in a regexp value as well and a break down related to clusters that match the regexp will output*.<br/>
         * or you can pass in an IEventDispatcher to get a full break down of all the events associated with that object*.<br/>
		 * *The output would change based on the log class you plug into the application. Please reffer to the log package for more information on logging options.<br/><br/>
         * @param clustID/object or regexp value- the same type of results as expected from the remove method.
         * @see #remove()
		 * @see _as.fla.events.log.ClassicLog
		 * @see _as.fla.events.log.DelegateLog
		 * @see _as.fla.events.log.AlconLog
		 * @see _as.fla.events.log.ArthropodLog
		 * @see _as.fla.events.log.MonsterDebuggerLog
         **/         
		public function log(clustID:*="clusters"):void{
			var l:Object = getPlug("log");
			if(!l) return; //this is no log no point to continue
			var c:Object  = getClusters();
			var tmp:Object = {};
			if(clustID is RegExp){
				for(var item:String in c) if(item.match(clustID)!=null) tmp[item] = c[item]; 
			}else if(clustID is IEventDispatcher){
				l._oLog(clustID,getORef(clustID));
				return;//breaking out to a diffrent log function
			}
			c[clustID]? tmp[clustID] = c[clustID] :tmp = c;	
			l._log(getDict(),tmp,clustID);
			
		}
		
		private function uncluster(o:IEventDispatcher):void{
			var c:Object  = getClusters();
			var tmp:Object = {};
			var arr:Array;
			for (var uid:String in c){//loop through clusters and remove all of object refrences
				arr = [];
				for(var i:int=0; i<c[uid].length;i++)
					if(c[uid][i].obj!=o) arr.push(c[uid][i]);
				
				if(arr.length)tmp[uid] = arr.concat();
			}
			_c = tmp;
		}
		
		private function getDict():Dictionary{
			if(!Boolean(_d)) _d= new Dictionary();
			return _d;
		}
		
		private function getClusters():Object{
			if(!Boolean(_c)) _c= {};
			return _c;
		}
		
		private function getORef(o:IEventDispatcher):Object{
			var dic:Dictionary = getDict();
			if(!dic[o]){
				dic[o] = {};
				dic[o][true]={};
				dic[o][false]={};
				dic[o].count = 0;
			}
			
			return dic[o];
		}
		
		private function removeIfEmpty(o:IEventDispatcher):void{
			var dic:Dictionary = getDict();
			if(dic[o]){
				for each(var item:String in dic[o][false]) return;
				for each(item in dic[o][true]) return;
				dic[o]=null;
				delete dic[o];
			}
			
		}
		
		private function isEventSet(o:Object,type:String, listener:Function):Boolean{
			if(o[type]){
				return Boolean(o[type][listener]);
			}else{
				o[type] = new Dictionary();
			}
			return false;
		}
		
		private function addToCluster(o:IEventDispatcher,type:String, listener:Function, useCapture:Boolean,clusterID:String):void{
			var clusters:Object = getClusters();
			if(!Boolean(clusters[clusterID])) clusters[clusterID] = [];
			clusters[clusterID].push({obj:o,type:type,listener:listener,useCapture:useCapture});
		}
		
		private function getPlug(id:String):Object{
			try{
			  return _p[id];
			}catch(err:*){
				trace(this, "a '" + id + "' was not included. see LEC.plug");
			}
			return null;
		}
		
	}
}