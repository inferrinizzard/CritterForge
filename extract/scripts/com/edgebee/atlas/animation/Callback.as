package com.edgebee.atlas.animation
{
   public class Callback extends TrackItem
   {
       
      
      public var data:Object;
      
      public var skippable:Boolean;
      
      public function Callback(param1:Number, param2:Object, param3:Boolean = false)
      {
         super(param1);
         this.data = param2;
         this.skippable = param3;
      }
   }
}
