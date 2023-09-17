package com.edgebee.atlas.animation
{
   public class Keyframe extends TrackItem
   {
       
      
      public var id:String;
      
      public var value:Number;
      
      public function Keyframe(param1:Number, param2:Number = 0)
      {
         super(param1);
         this.id = param1.toString();
         this.value = param2;
      }
   }
}
