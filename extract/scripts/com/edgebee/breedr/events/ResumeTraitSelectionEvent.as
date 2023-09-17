package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.breedr.data.skill.TraitInstance;
   
   public class ResumeTraitSelectionEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"ResumeTraitSelectionEvent",
         "cls":ResumeTraitSelectionEvent
      };
       
      
      public var creature_instance_id:uint;
      
      public var trait_choices:DataArray;
      
      public function ResumeTraitSelectionEvent(param1:Object = null)
      {
         this.trait_choices = new DataArray(TraitInstance.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
