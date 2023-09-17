package com.edgebee.breedr.data.ladder
{
   import com.edgebee.atlas.data.*;
   import com.edgebee.atlas.data.l10n.*;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   
   public class Team extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"Team",
         "cls":Team
      };
       
      
      public var id:uint;
      
      public var name:String;
      
      public var position:uint;
      
      public var ladder:com.edgebee.breedr.data.ladder.Ladder;
      
      public var members:DataArray;
      
      public var frozen_until:Number;
      
      public var wins:int;
      
      public var losses:int;
      
      public var ties:int;
      
      public var challenge:com.edgebee.breedr.data.ladder.Challenge;
      
      private var _active:Boolean;
      
      public var activateTime:Date;
      
      private var _disbanded_until:Number;
      
      public function Team(param1:Object = null)
      {
         this.ladder = new com.edgebee.breedr.data.ladder.Ladder();
         this.members = new DataArray(CreatureInstance.classinfo);
         this.challenge = new com.edgebee.breedr.data.ladder.Challenge();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      override public function copyTo(param1:*) : void
      {
         var _loc3_:CreatureInstance = null;
         var _loc4_:CreatureInstance = null;
         param1.id = this.id;
         param1.name = this.name;
         param1.position = this.position;
         param1.challenge = this.challenge;
         param1.wins = this.wins;
         param1.losses = this.losses;
         param1.ties = this.ties;
         param1.frozen_until = this.frozen_until;
         param1.active = this.active;
         param1.disbanded_until = this.disbanded_until;
         this.ladder.copyTo(param1.ladder);
         var _loc2_:Array = [];
         for each(_loc4_ in this.members)
         {
            _loc3_ = new CreatureInstance();
            _loc4_.copyTo(_loc3_);
            _loc2_.push(_loc3_);
         }
         param1.members.source = _loc2_;
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         if(this.active != param1)
         {
            this._active = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"active",!param1,param1));
         }
      }
      
      public function get disbanded_until() : Number
      {
         return this._disbanded_until;
      }
      
      public function set disbanded_until(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Date = null;
         if(this.disbanded_until != param1)
         {
            _loc2_ = this._disbanded_until;
            this._disbanded_until = param1;
            _loc3_ = new Date();
            if(this._disbanded_until)
            {
               this.activateTime = new Date(_loc3_.time + Math.max(0,this._disbanded_until + 10) * 1000);
            }
            else
            {
               this.activateTime = null;
            }
         }
      }
   }
}
