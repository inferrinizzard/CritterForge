package com.edgebee.atlas.managers.processors
{
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.data.ArrayCollection;
   import com.edgebee.atlas.interfaces.IDisposable;
   import com.edgebee.atlas.interfaces.IExecutable;
   import com.edgebee.atlas.ui.UIGlobals;
   import flash.events.EventDispatcher;
   
   public class BaseProcessor extends EventDispatcher implements IExecutable, IDisposable
   {
       
      
      protected var executables:ArrayCollection;
      
      public function BaseProcessor()
      {
         super();
         this.executables = new ArrayCollection();
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client;
      }
      
      public function add(param1:IExecutable) : void
      {
         this.executables.addItem(param1);
      }
      
      public function dispose() : void
      {
         this.clear();
      }
      
      public function clear() : void
      {
         this.executables.removeAll();
      }
      
      public function execute() : void
      {
         throw Error("Not implemented.");
      }
      
      public function get active() : Boolean
      {
         return this.executables.length > 0;
      }
   }
}
