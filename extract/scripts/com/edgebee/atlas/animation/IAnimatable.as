package com.edgebee.atlas.animation
{
   public interface IAnimatable
   {
       
      
      function get controller() : Controller;
      
      function getProperty(param1:String) : *;
      
      function setProperty(param1:String, param2:*) : void;
   }
}
