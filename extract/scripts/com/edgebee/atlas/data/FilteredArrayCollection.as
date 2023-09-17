package com.edgebee.atlas.data
{
   import com.edgebee.atlas.events.CollectionEvent;
   import flash.events.Event;
   
   public class FilteredArrayCollection extends ArrayCollection
   {
       
      
      private var _filter:Function;
      
      public function FilteredArrayCollection(param1:Array = null)
      {
         super(param1);
      }
      
      public function get filter() : Function
      {
         return this._filter;
      }
      
      public function set filter(param1:Function) : void
      {
         this._filter = param1;
         this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,CollectionEvent.RESET,this.source,-1));
      }
      
      override public function get source() : Array
      {
         return this.filter(super.source);
      }
      
      override public function dispatchEvent(param1:Event) : Boolean
      {
         if(param1 is CollectionEvent)
         {
            param1 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,CollectionEvent.RESET,this.source,-1);
         }
         return super.dispatchEvent(param1);
      }
   }
}
