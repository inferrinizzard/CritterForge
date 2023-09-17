package com.edgebee.atlas.managers.processors
{
   import com.edgebee.atlas.interfaces.IExecutable;
   import com.edgebee.atlas.util.Cursor;
   
   public class ParallelProcessor extends BaseProcessor
   {
       
      
      public function ParallelProcessor()
      {
         super();
      }
      
      override public function execute() : void
      {
         var _loc1_:Cursor = null;
         var _loc2_:IExecutable = null;
         if(active)
         {
            _loc1_ = new Cursor(executables);
            while(_loc1_.valid)
            {
               _loc2_ = _loc1_.current as IExecutable;
               _loc2_.execute();
               if(!_loc2_.active)
               {
                  _loc1_.remove();
               }
               else
               {
                  _loc1_.next();
               }
            }
         }
      }
   }
}
