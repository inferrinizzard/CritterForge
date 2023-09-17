package com.edgebee.breedr.data.player
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.breedr.data.ladder.Team;
   
   public class Syndicate extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"Syndicate",
         "cls":Syndicate
      };
      
      public static const RULE_ANY_CHALLENGE:Number = 1;
       
      
      public var id:uint;
      
      public var name:String;
      
      public var acronym:String;
      
      public var rules:Number;
      
      public var members:DataArray;
      
      public var teams:DataArray;
      
      public var activity:DataArray;
      
      private var _leader_id:uint;
      
      public function Syndicate(param1:Object = null)
      {
         this.members = new DataArray(Player.classinfo);
         this.teams = new DataArray(Team.classinfo);
         this.activity = new DataArray(Log.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get leader_id() : uint
      {
         return this._leader_id;
      }
      
      public function set leader_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._leader_id != param1)
         {
            _loc2_ = this._leader_id;
            this._leader_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"leader_id",_loc2_,param1));
         }
      }
      
      public function get leader() : Player
      {
         var _loc1_:Player = null;
         for each(_loc1_ in this.members)
         {
            if(_loc1_.id == this.leader_id)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function get capacity() : uint
      {
         return this.leader.syndicate_level.capacity;
      }
      
      override public function reset() : void
      {
         this.members.reset();
         this.teams.reset();
         this.activity.reset();
         super.reset();
      }
      
      override public function copyTo(param1:*) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Player = null;
         var _loc4_:Player = null;
         var _loc5_:Team = null;
         var _loc6_:Team = null;
         var _loc7_:Log = null;
         var _loc8_:Log = null;
         param1.copying = true;
         param1.id = this.id;
         param1.name = this.name;
         param1.acronym = this.acronym;
         param1.rules = this.rules;
         param1.leader_id = this.leader_id;
         _loc2_ = [];
         for each(_loc4_ in this.members)
         {
            _loc3_ = new Player({
               "name":_loc4_.name,
               "id":_loc4_.id,
               "avatar_version":_loc4_.avatar_version,
               "foreign_type":_loc4_.foreign_type,
               "foreign_id":_loc4_.foreign_id,
               "user_level":_loc4_.user_level,
               "syndicate_level_id":_loc4_.syndicate_level_id,
               "syndicate_flags":_loc4_.syndicate_flags,
               "last_activity":_loc4_.last_activity
            });
            _loc2_.push(_loc3_);
         }
         param1.members.source = _loc2_;
         _loc2_ = [];
         for each(_loc6_ in this.teams)
         {
            _loc5_ = new Team();
            _loc6_.copyTo(_loc5_);
            _loc2_.push(_loc5_);
         }
         param1.teams.source = _loc2_;
         _loc2_ = [];
         for each(_loc8_ in this.activity)
         {
            _loc7_ = new Log();
            _loc8_.copyTo(_loc7_);
            _loc2_.push(_loc7_);
         }
         param1.activity.source = _loc2_;
         param1.copying = false;
      }
   }
}
