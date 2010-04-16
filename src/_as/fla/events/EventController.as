/**
 * VERSION: 1.3.01
 * DATE: 04/09/2009
 * MOD: 03/17/2010
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
	import flash.events.IEventDispatcher;
	
	/**
	 *  The EventController main goal is to cut down the effort involved with managing events in as3 and a leak proff way of managing events. Yes you've heard right 
	 *  its practicly imposible to lose an event working with the EventController. If you've been working for a while with the standard addEventListener the EventController will
	 *  with very minimal changes to your work flow will make leaks a thing of the past.<br/><br/>
	 *
	 *  We are hopping after you get your feet wet you will want to have more power and we are ready for that need with a list of features that is only limited by how
	 *  you choise to work with them. We know that there are many development styles out there but we did our best to create 3 uniqe classes that will help most developers find 
	 *  There favoriate style of working with the same engine in the back enabling multiple developers to work with seperate classes and still maintain the same global control unless
	 *  you choose to lock your event information from other developers by using the LEC local event instances.<br/><br/>
	 * 
	 *  EventController used to be the center hub(in vertion 1.0) but since then many things changed now in vertion 1.3 it turned more into an historic
	 *  landmark and an indexing item. EventController is a way for you to take control over as3 event leaks. We recommend working with the EC/LEC as there 
	 *  more short hand. The EventController class offers the same functionality plus we expose you to more methods the the hub of the aplication LEC manages. <br/><br/>
	 * 
	 *  Here is a break down on who are the right users for EventController/EC and LEC.<br/>
	 * 
	 *  <p><b>EventController</b> - The naming conventions on the EventController are the same as in the built in flash IDE to help you transition more quickly to work with our class.
	 *  There are a nice list of exposed extra methods that are not avilable on the EC(methods that are not needed to do the work but enable more detailed development work).</p>
	 *  <p><b>EC</b> - Is the smaller counter part of the EventController. Enabling real short hand development ideal for banner and small one man projects.</p>
	 *  <p><b>LEC</b> - Is really the hub of everything if we could recommend it we would get everyone working directly with the LEC. The LEC enables you to create a global EventController
	 *  that leans on the same controller that the EC/EventController are working with by calling - LEC.getGlobal(), or enabling you to create  a stand alone EventManager with a local scope
	 *  Enabling you to protect yourself and others from your events ( to work with local events you would create a new LEC ( new LEC());</p><br/>
	 *  We recomend using the EC as everything you can do directly with the EventController can be done with less code on EC.
	 *
	 *  You can:
	 *  <p><li> Stop worrying about events and memory leaks </li>
	 *  <li> Manage events without extra code and with minimal change to your style of coding. </li>
	 *  <li> Create cluster names to events for quicker monitoring and removal </li>
	 *  <li> Remove and add single events the same old and good way without worries if the event has been added already.
	 *          The manager will validate that you can not add the same event more then once with the same prams. </li>
	 *  <li> Remove all events of an object with one simple line of code </li>
	 *  <li> Remove all events of a cluster of objects with one simple line of code </li>
	 *  <li> Log and follow your events using our built in logging system or with your favorate debugger tool. </li>
	 *  <li> Pause events</li>
	 *  <li> Resume events</li></p>
    **/
	public class EventController{
		/**
		 * @copy _as.fla.events.LEC#UNCLUSTERED
		**/
		public static const UNCLUSTERED:String = "UNCLUSTERED";
		private static var g:LEC;
		/**
		 * @private  
		 */		
		public function EventController(key:Narf){}
		
		/**
         * @copy _as.fla.events.LEC#plug() 
         **/		
		public static function plug(item:Class):void{
			LEC.plug(item);
		}
		
		/**
         * @copy _as.fla.events.LEC#add() 
         **/		
		public static function addEventListener(_obj:Object,type:String, listener:Function, useCapture:* = false, priority:int = 0, useWeakReference:Boolean = false,clusterID:String=UNCLUSTERED):Boolean{
			return global.add(_obj as IEventDispatcher,type,listener,useCapture,priority,useWeakReference,clusterID);
		}
		
		
		/**
		* @copy _as.fla.events.LEC#addGroup() 
		**/
		public static function addGroup(aEvents:Array):void{
			global.addGroup(aEvents);
		}
		
		/**
		* @copy _as.fla.events.LEC#remove() 
		**/
		public static function removeEventListener(_obj:*,type:String=null, listener:Function=null, useCapture:Boolean = false):Array{
			return global.remove(_obj,type,listener,useCapture);
		}
		
		/**
		* @copy _as.fla.events.LEC#removeEvent() 
		**/
		public static function removeEvent(obj:IEventDispatcher,type:String, listener:Function, useCapture:Boolean = false):Object{
			return global.removeEvent(obj,type,listener,useCapture);
		}
		
		/**
		* @copy _as.fla.events.LEC#removeObjEvents() 
		**/ 
		public static function removeObjEvents(_obj:Object):Array{
			return global.removeObjEvents(_obj as IEventDispatcher);
		}
		
		
		/**
		* @copy _as.fla.events.LEC#removeClusterEvents() 
		**/ 
		public static function removeClusterEvents(clusterID:*):Array{
			return global.removeClusterEvents(clusterID);
		}
				
		/**
		* @copy _as.fla.events.LEC#log() 
		**/ 
		public static function log(clustID:*="clusters"):void{
			global.log(clustID);
		}
		
		private static function get global():LEC{
			if(!g) g = LEC.getGlobal();
			
			return g;
		}
	}
}
class Narf{}