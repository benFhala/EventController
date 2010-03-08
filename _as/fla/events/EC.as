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
	public class EC{
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
		public static const add:Function = EventController.addEventListener; //shortcut
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
		public static const rem:Function = EventController.removeEventListener; 
		/**
		 * EC.log will output all current events and all current objects that are tracked by the EventController sorted based on clusters. 
		 * you can pass into the EC.log a cluster id. if a valid cluster id is passed the output will only output information related to the cluster tracked.
		 * you can pass in a regexp value as well and a break down related to clusters that mathc the regexp will output.
		 * @param clustID
		 * 
		 */		
		public static const log:Function = EventController.log; 
		
	}
	
}