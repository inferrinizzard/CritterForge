package com.edgebee.breedr.data.ladder
{
   import com.edgebee.atlas.data.*;
   import com.edgebee.atlas.data.l10n.*;
   
   public class Ladder extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"Ladder",
         "cls":Ladder
      };
       
      
      public var id:uint;
      
      public var name_id:uint;
      
      public var max_team_size:uint;
      
      public var max_challenge:uint;
      
      public function Ladder(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get name() : Asset
      {
         return Asset.getInstanceById(this.name_id);
      }
      
      override public function copyTo(param1:*) : void
      {
         param1.id = this.id;
         param1.name_id = this.name_id;
         param1.max_team_size = this.max_team_size;
         param1.max_challenge = this.max_challenge;
      }
   }
}
