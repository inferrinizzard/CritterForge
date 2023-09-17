package com.edgebee.atlas.events
{
   import com.edgebee.atlas.animation.AnimationInstance;
   import flash.events.Event;
   
   public class AnimationEvent extends Event
   {
      
      public static const START:String = "START";
      
      public static const PAUSE:String = "PAUSE";
      
      public static const UNPAUSE:String = "UNPAUSE";
      
      public static const STOP:String = "STOP";
      
      public static const LOOP:String = "LOOP";
      
      public static const CALLBACK:String = "CALLBACK";
      
      public static const POST_FRAME:String = "POST_FRAME";
       
      
      private var _data:Object;
      
      private var _instance:AnimationInstance;
      
      public function AnimationEvent(param1:String, param2:AnimationInstance, param3:Object = null, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this._instance = param2;
         this._data = param3;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function get instance() : AnimationInstance
      {
         return this._instance;
      }
   }
}
