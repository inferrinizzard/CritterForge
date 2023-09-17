package com.edgebee.atlas.ui
{
   public interface IStylable
   {
       
      
      function get styleClassName() : String;
      
      function get inheritStyles() : Boolean;
      
      function getStyle(param1:String, param2:* = null, param3:Boolean = true) : *;
      
      function setStyle(param1:String, param2:*) : void;
   }
}
