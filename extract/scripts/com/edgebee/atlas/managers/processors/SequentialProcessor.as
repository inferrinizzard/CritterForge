package com.edgebee.atlas.managers.processors
{
   import com.edgebee.atlas.interfaces.IExecutable;
   import com.edgebee.atlas.util.Cursor;
   
   public class SequentialProcessor extends BaseProcessor
   {
       
      
      public function SequentialProcessor()
      {
         super();
      }
      
      override public function execute() : void
      {
         var _loc1_:Cursor = null;
         var _loc2_:* = false;
         var _loc3_:IExecutable = null;
         if(active)
         {
            _loc1_ = new Cursor(executables);
            _loc2_ = false;
            while(!_loc2_ && _loc1_.valid)
            {
               _loc3_ = _loc1_.current as IExecutable;
               _loc3_.execute();
               if(!_loc3_.active)
               {
                  _loc1_.remove();
                  _loc2_ = executables.length == 0;
               }
               else
               {
                  _loc2_ = true;
               }
            }
         }
      }
   }
}
