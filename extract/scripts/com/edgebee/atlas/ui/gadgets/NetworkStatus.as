package com.edgebee.atlas.ui.gadgets
{
   import com.edgebee.atlas.net.JsonService;
   import com.edgebee.atlas.net.ServerConnection;
   import com.edgebee.atlas.ui.containers.Box;
   
   public class NetworkStatus extends Box
   {
       
      
      private var _service:JsonService;
      
      private var _connectionViews:Array;
      
      public function NetworkStatus()
      {
         super(Box.VERTICAL);
         setStyle("Gap",3);
         layoutInvisibleChildren = false;
      }
      
      public function get service() : JsonService
      {
         return this._service;
      }
      
      public function set service(param1:JsonService) : void
      {
         this.removeViews();
         this._service = param1;
         this.createViews();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.createViews();
      }
      
      private function removeViews() : void
      {
         var _loc1_:ServerConnectionView = null;
         if(this.service)
         {
            for each(_loc1_ in this._connectionViews)
            {
               _loc1_.connection = null;
               removeChild(_loc1_);
            }
            this._connectionViews = [];
         }
      }
      
      private function createViews() : void
      {
         var _loc1_:ServerConnectionView = null;
         var _loc2_:ServerConnection = null;
         if((childrenCreating || childrenCreated) && Boolean(this.service))
         {
            this._connectionViews = [];
            for each(_loc2_ in this.service.connections)
            {
               _loc1_ = new ServerConnectionView();
               _loc1_.percentWidth = 1;
               _loc1_.percentHeight = 1 / this.service.connections.length;
               _loc1_.connection = _loc2_;
               _loc1_.setStyle("FontSize",getStyle("FontSize"));
               addChild(_loc1_);
               this._connectionViews.push(_loc1_);
            }
         }
      }
   }
}
