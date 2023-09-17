package com.edgebee.atlas.data.chat
{
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.data.Player;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.util.Utils;
   import flash.events.TimerEvent;
   
   public class Channel extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"Channel",
         "cls":Channel
      };
       
      
      public var type:uint;
      
      public var name:String;
      
      public var nicename_id:uint;
      
      public var creator_id:uint;
      
      public var members:DataArray;
      
      private var _membersDirty:Boolean;
      
      public function Channel(param1:Object = null)
      {
         this.members = new DataArray(Player.classinfo);
         super(param1);
         UIGlobals.oneSecTimer.addEventListener(TimerEvent.TIMER,this.refreshMembersList);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      private static function sortChannelMembers(param1:Player, param2:Player) : int
      {
         var _loc3_:Client = UIGlobals.root.client as Client;
         if(param1.name == param2.name)
         {
            return 0;
         }
         if(_loc3_.basePlayer.name == param1.name)
         {
            return -1;
         }
         if(_loc3_.basePlayer.name == param2.name)
         {
            return 1;
         }
         if(_loc3_.user.friends.indexOf(param1.name) >= 0 && _loc3_.user.friends.indexOf(param2.name) < 0)
         {
            return -1;
         }
         if(_loc3_.user.friends.indexOf(param2.name) >= 0 && _loc3_.user.friends.indexOf(param1.name) < 0)
         {
            return 1;
         }
         return param1.name.toLocaleLowerCase().localeCompare(param2.name.toLocaleLowerCase());
      }
      
      public function get displayName() : *
      {
         return !!this.nicename ? this.nicename : this.name;
      }
      
      public function getChatMemberById(param1:uint) : Player
      {
         var _loc3_:Player = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.members.length)
         {
            _loc3_ = this.members[_loc2_];
            if(_loc3_.id == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function addMember(param1:Player) : void
      {
         this.members.addItem(param1);
         this._membersDirty = true;
      }
      
      public function get nicename() : Asset
      {
         return Asset.getInstanceById(this.nicename_id);
      }
      
      public function sortMembers() : void
      {
         this._membersDirty = false;
         Utils.quicksort(this.members.source,sortChannelMembers);
         this.members.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,CollectionEvent.RESET,null,0));
      }
      
      override protected function finalize() : void
      {
         super.finalize();
         this.sortMembers();
      }
      
      private function refreshMembersList(param1:TimerEvent) : void
      {
         if(this._membersDirty)
         {
            this.sortMembers();
         }
      }
   }
}
