package com.edgebee.atlas.util
{
   import com.edgebee.atlas.data.ArrayCollection;
   
   public class Cursor
   {
       
      
      private var _target:ArrayCollection;
      
      private var _current:uint = 0;
      
      public function Cursor(param1:ArrayCollection)
      {
         super();
         this._target = param1;
      }
      
      public function get current() : *
      {
         if(this.valid)
         {
            return this._target[this._current];
         }
         return null;
      }
      
      public function set current(param1:*) : void
      {
         if(this.valid)
         {
            this._current = this._target.getItemIndex(param1);
         }
      }
      
      public function get valid() : Boolean
      {
         return this._target && this._target.length > 0 && this._current >= 0 && this._current < this._target.length;
      }
      
      public function next() : void
      {
         ++this._current;
      }
      
      public function previous() : void
      {
         --this._current;
      }
      
      public function remove() : void
      {
         this._target.removeItemAt(this._current);
      }
      
      public function insert(param1:*) : void
      {
         this._target.addItemAt(param1,this._current);
      }
   }
}
