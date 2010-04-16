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
	 * Quick shorthand way to interact with the global event controller.
	 * @copy _as.fla.events.EventController
    **/
	public class EC{
		/**
		 * @copy _as.fla.events.LEC#UNCLUSTERED
		**/
		public static const UNCLUSTERED:String = "UNCLUSTERED";
		
		private static var g:LEC;
		
		/**
		* @private
		**/
		public static var rem:Function=remove;
		
		/**
		* @private
		**/
		public function EC():void{
			throw("do not insantiate the EC");
		}
		
		/**
         * @copy _as.fla.events.LEC#plug() 
         **/		
		public static function plug(item:Class):void{
			LEC.plug(item);
		}
		
		/**
		* @copy _as.fla.events.LEC#add() 
		**/
		public static function add(_obj:Object,type:String, listener:Function, useCapture:* = false, priority:int = 0, useWeakReference:Boolean = false,clusterID:String=UNCLUSTERED):Boolean{
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
		*/
		public static function remove(_obj:*,type:String=null, listener:Function=null, useCapture:Boolean = false):Array{
			return global.remove(_obj,type,listener,useCapture);
		}
		
		/**
       	 * @copy as.fla.events.LEC#log() 
         * @see _as.fla.events.EventController#log() EventController.log() - alias EC.log
		 *
         */		
		public static function log(clustID:*="clusters"):void{
			global.log(clustID);
		}
		
		private static function get global():LEC{
			if(!g) g = LEC.getGlobal();
			
			return g;
		}
		
	}
	
}