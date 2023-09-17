package com.edgebee.atlas.managers
{
   import com.edgebee.atlas.Client;
   import flash.events.EventDispatcher;
   
   public class LocalizationManager extends EventDispatcher
   {
       
      
      private var _dispatchLocaleChanged:Boolean;
      
      private var _client:Client;
      
      public function LocalizationManager()
      {
         super();
         this._dispatchLocaleChanged = false;
      }
      
      public function initialize(param1:Client) : void
      {
         this._client = param1;
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
   }
}
