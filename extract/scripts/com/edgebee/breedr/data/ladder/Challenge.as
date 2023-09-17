package com.edgebee.breedr.data.ladder
{
   import com.edgebee.atlas.data.*;
   import com.edgebee.atlas.data.l10n.*;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   
   public class Challenge extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"Challenge",
         "cls":Challenge
      };
       
      
      private var _id:uint;
      
      public var challenger_id:uint;
      
      public var challenger_name:String;
      
      public var challenger_position:uint;
      
      public var defender_id:uint;
      
      public var defender_name:String;
      
      public var defender_position:uint;
      
      public var fight_at:Number;
      
      public function Challenge(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function set id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this.id != param1)
         {
            _loc2_ = this._id;
            this._id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"id",_loc2_,param1));
         }
      }
      
      override public function copyTo(param1:*) : void
      {
         param1.challenger_id = this.challenger_id;
         param1.challenger_name = this.challenger_name;
         param1.challenger_position = this.challenger_position;
         param1.defender_id = this.defender_id;
         param1.defender_name = this.defender_name;
         param1.defender_position = this.defender_position;
         param1.fight_at = this.fight_at;
         param1.id = this.id;
      }
   }
}
