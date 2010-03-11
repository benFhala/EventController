/**
 * VERSION: 1.2.10
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
 *     EventController long hand with all methods exposed.  offering exactly the same functionality plus useful
 *  (but non-essential)  extra features to the AS3 event dispatching system. It doesn't come to replace the EventController
 *  but to hide the lower level details of managing the Events enabling quicker development with less memory leaks that are easier to find/control
 *
 *  We recomend using the EC as everything you can do directly with the EventController can be done with less code on EC.
 *
 *  You can:
 *  <p><li> stop worrying about events and memory leaks </li>
 *  <li> manage events without extra code and without changing your style of coding. </li>
 *  <li> create cluster names to events for quicker monitoring and removal </li>
 *  <li> remove and add single events the same old and good way without worries if the event has been added already.
 *          the manager will validate that you can not add the same event more then once with the same prams. </li>
 *  <li> remove all events of an object with one simple line of code </li>
 *  <li> remove all events of a cluster of objects with one simple line of code </li></p>
    **/
	public class EventController{
		/**
         *  unclosered objects are by defult asosiated with this id. if you do not add a cluster id to an event one 
		 *  will automatically be generated as - EventController.UNCLUSTRED(a cluster of all unclustered items)
         * 
         *
		 **/
		public static const UNCLUSTERED:String = "UNCLUSTERED";
		
		/**
		 * @private  
		 */		
		public function EventController(key:Narf){}
		
		/**
         *  The main method to add events. <br/>
         * <p>the EventController.addEventListener and EC.as are the same method. the shorthand was creating to make it quicker and easier but both classes are
         * referencing the the same global scope manager. when you want to create local managers create a new LEC(local event controller).</p>
         *  the classic development style in AS3 for adding events is:<br/>
         *  <p>obj.addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0.0, useWeakReference:Boolean = false):void</p>
         *
         * <p> please reffer to the information on addEventListerner at Adobes documentation for full information on Events.</p><p> working with the event controller
         *  you would instead add the object a the first parameter and the last parameter(non mandatory cluster id for the object - but its the power house) for example:
         *
         *  <p>EC.add(obj,type,listener,false,0,false,"myCluster");</p>
         *
         *  as most of the time you will use the fefult settings for useCapture,priority and useWeakRefrence you can skip these parameters and quickly type:
         *
         * <p> EC.add(obj,type,listener,"myCluster");</p>
         *
         *  <p>the method reruns a Boolean value. true if th event has been added to the Que of events and false if the event is
         *  already in the Que.</p>
         *
         *  <p>if you do not pass a cluster ID one will be assigned automatically (EventController.UNCLUSTERED)</p>
         *  
		 *
         * @param _obj - an EventDispatcher
         * @param type - the type of Event (see Adobe docuementation)
         * @param listener - the listener function (see Adobe documentation)
         * @param useCapture - use Captuer(see Adobe documentation)
         * @param priority - priority (see Adobe documentation)
         * @param useWeakReference - use weak refrence (see Adobe docuementation)
         * @param clusterID - a uniqe id for a cluster of events to be be used to removed items as a group when using EC.rem
         * @return  returns a boolean value.
		 * @see _as.fla.events.EC#add()
		 * @see #UNCLUSTERED
		 * @see flash.events.EventDispatcher#addEventListener()
		 * @throws TypeError if you send an object that is not an eventdispatcher a TypeError will trigger
         *
         */		
		
		public static function addEventListener(_obj:Object,type:String, listener:Function, useCapture:* = false, priority:int = 0, useWeakReference:Boolean = false,clusterID:String=UNCLUSTERED):Boolean{
			return EC.getLEC().add(_obj,type,listener,useCapture,priority,useWeakReference,clusterID);
		}
		
		/**
         *  <p>The only method you would need to remove events. This is where the fun starts. This function holds all the logic you will 
         *  ever need to remove events. The standard way of removing one event is the same as the regular way you are used to coding
		 *   the syntax with a small twist - The first parameter is an EventDispatcher object.</p>
         *
         *  In the standard way you would:<br/>
         *  <p>obj.removeEventListener(type,listner,false);</p>
         *
         *  With EC you send the object as the first param(all other params are the same as in the adobe docuemtnation):<br/>
         *  <p>EC.rem(obj,type,listener,false);</p>
         *
         *  useCapture by defult would be false so you can remove an event, as long as it was added with the defult settings of flase for useCapture) this way:
         *  <p>EC.rem(obj,type,listener);</p>
         *
         *  <p>EC will then return a boolean value if it manages to delete the event(if its can't find the event it will return a false value any other option it would return true).</p>
         *
         *  The nice more hiden powers here are if you want to remove all events for an object your code to removing events has never looked more simple:</br>
         *
         *  <p>EC.rem(obj);</p>
         *
         *  <p>if you're skilled in the powers of regexp(and even if not - now is a great time to start) you are going to love this feature.
         *  Its the most powerful one and most used one our end. Get ready for it, here it goes: you can pass a regexp value instead
         *  of a string and it will find all clusters that match that rule and get rid of them enabling you to create smart dynamic clustering
         *  to clusters. in other words why should we limit your creative develpment style instead we gave you the driver seat all we are doing
		 *  is enabling you to do what ever you want with events without the need to tinker with low level management
		 *  of single events (you can still do it, but why would you?).</p>

         *  <p>in that way you can get rid of a full project/section in one line.</p>
         *
         * <p>// some random events with a variety of clusters<br/>
         *  EC.add(mc,MouseEvent.CLICK,onClick,"project_mc");<br/>
         *  EC.add(menu,Event.CHANGE, onChange,"project_menu");<br/>
         *  EC.add(menu,Event.RESIZE, onResize,"project_menu");<br/>
         *  EC.add(this,Event.RESIZE, onStageResize, "project_stage");<br/><br/>
         *
         *  //now that you have a few objects and varuis clusters <br/>
		 *  //lets get rid of all the clusters that contain the word 'project_'<br/>
         *  EC.rem(/project_/); /done eveything will be deleted.<br/><br/>
         *
         *  EC will then find all events related to that object and remove them from the que.<br/><br/>
         *
         *  if you wish to remove all events asisiated with a cluster pass as the first param the clusterID:<br/><br/>
         * 
         *  EC.rem("clusterID");
         *
         * @param _obj - eventDispatcher or a cluster ID string
         * @param type - the event type (only if using en eventDispatcher) else this param is ignored
         * @param listener - the listener (only if using en eventDispatcher) else this param is ignored
         * @param useCapture - the useCapture Boolean value (only if using en eventDispatcher) else this param is ignored
         * @return Boolean value returned if an event was removed.
         * @see _as.fla.events.EC#rem()
		 * @see #removeObjEvents()
		 * @see #removeClusterEvents()
		 * @see flash.events.EventDispatcher#removeEventListener()
		 *
         */
		public static function removeEventListener(_obj:*,type:String=null, listener:Function=null, useCapture:Boolean = false):Boolean{
			return EC.getLEC().remove(_obj,type,listener,useCapture);
		}
		
		
		/**
         * Removes object events.this is not part of the public EC methods as it is encapsulated in the EC.rem.
         * if you wish to optimize your code and work directly with the EventController this method will remove object events. it will take only one parameter
         * the EventDispatcher object to be removed from the Que.
         * @param _obj - EventDispatcher
         * @see _as.fla.events.EC#rem()
		 * @see #removeClusterEvents()
		 *
         */                
		public static function removeObjEvents(_obj:Object):void{
			return EC.getLEC().removeObjEvents(_obj);
		}
		
		
		/**
         * Removes cluster events.this is not part of the public EC methods as it is encapsulated in the EC.rem.
         * if you wish to optimize your code and work directly with the EventController this method will remove cluster events. it will take only one param
         * the cluster id(String value) to be removed from the Que. 
         * @param clusterID
         * @see _as.fla.events.EC#rem()
		 * @see #removeObjEvents()
		 *
         */       
		public static function removeClusterEvents(clusterID:*):void{
			return EC.getLEC().removeClusterEvents(clusterID);
		}
				
		/**
         * output of all the current events/clusters/objects. Through the log you can track all that the EventController knows sorted based on cluster ids.
         * you can pass into the EC.log a cluster id. if a valid cluster id is passed the output will only output information related to the cluster tracked.
         * you can pass in a regexp value as well and a break down related to clusters that match the regexp will output.
         * or you can pass in an EventDispatcher to get a full break down of all the events associated with that object.
         * @param clustID
         * @see _as.fla.events.EC#log()
		 *
         */         
		public static function log(clustID:*="clusters"):void{
			EC.getLEC().log(clustID);
		}
	}
}
class Narf{}