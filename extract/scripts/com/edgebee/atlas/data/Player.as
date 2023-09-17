package com.edgebee.atlas.data
{
   import com.adobe.crypto.MD5;
   import com.edgebee.atlas.data.achievements.Achievement;
   import com.edgebee.atlas.data.achievements.AchievementInstance;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.data.messaging.Message;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.util.codec.Utf8;
   
   public class Player extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"Player",
         "cls":Player
      };
       
      
      public var messages:com.edgebee.atlas.data.DataArray;
      
      public var achievements:com.edgebee.atlas.data.DataArray;
      
      private var _id:uint;
      
      private var _name:String;
      
      private var _avatar_version:int;
      
      private var _is_anonymous:Boolean;
      
      private var _starter_kit:Boolean;
      
      public var user_level:uint;
      
      public var foreign_type:String;
      
      public var foreign_id:Number;
      
      private var _new_messages:Boolean;
      
      private var _new_news:Boolean;
      
      private var _new_achievements:Boolean;
      
      private var _new_whisper:Boolean;
      
      public function Player(param1:Object = null)
      {
         this.messages = new com.edgebee.atlas.data.DataArray(Message.classinfo);
         this.achievements = new com.edgebee.atlas.data.DataArray(AchievementInstance.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.id = 0;
         this.name = null;
         this.avatar_version = 0;
         this.messages.reset();
         this.achievements.reset();
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function set id(param1:uint) : void
      {
         var _loc2_:uint = this._id;
         this._id = param1;
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"id",_loc2_,this.id));
      }
      
      public function get name() : String
      {
         if(this.is_anonymous)
         {
            return Asset.getInstanceByName("GUEST").value;
         }
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:String = this._name;
         this._name = param1;
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"name",_loc2_,this.name));
      }
      
      public function get nicename() : String
      {
         if(UIGlobals.root.client.user.name == this.name)
         {
            return UIGlobals.root.client.user.nicename;
         }
         return this.name;
      }
      
      public function get avatar_version() : int
      {
         return this._avatar_version;
      }
      
      public function set avatar_version(param1:int) : void
      {
         var _loc2_:int = this._avatar_version;
         this._avatar_version = param1;
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"avatar_version",_loc2_,this.avatar_version));
      }
      
      public function get is_anonymous() : Boolean
      {
         return this._is_anonymous;
      }
      
      public function set is_anonymous(param1:Boolean) : void
      {
         var _loc2_:Boolean = this._is_anonymous;
         this._is_anonymous = param1;
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"is_anonymous",_loc2_,this.is_anonymous));
      }
      
      public function get starter_kit() : Boolean
      {
         return this._starter_kit;
      }
      
      public function set starter_kit(param1:Boolean) : void
      {
         var _loc2_:Boolean = this._starter_kit;
         this._starter_kit = param1;
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"starter_kit",_loc2_,this.starter_kit));
      }
      
      public function get avatarUrl() : String
      {
         if(this.foreign_type == "facebook" && this.avatar_version == 0)
         {
            return "http://graph.facebook.com/" + this.foreign_id.toString() + "/picture?type=square";
         }
         if(this.avatar_version > 0)
         {
            return UIGlobals.getAssetPath("avatars/" + MD5.hash(Utf8.encode(this.name)) + this.avatar_version.toString() + ".png",false,"portal");
         }
         return UIGlobals.getAssetPath("avatars/default.png",false,"portal");
      }
      
      public function get avatarUrlSmall() : String
      {
         if(this.foreign_type == "facebook" && this.avatar_version == 0)
         {
            return "http://graph.facebook.com/" + this.foreign_id.toString() + "/picture?type=square";
         }
         if(this.avatar_version > 0)
         {
            return UIGlobals.getAssetPath("avatars/" + MD5.hash(Utf8.encode(this.name)) + "_small_" + this.avatar_version.toString() + ".png",false,"portal");
         }
         return UIGlobals.getAssetPath("avatars/default_small.png",false,"portal");
      }
      
      public function get new_messages() : Boolean
      {
         return this._new_messages;
      }
      
      public function set new_messages(param1:Boolean) : void
      {
         if(param1 != this.new_messages)
         {
            this._new_messages = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"new_messages",!param1,param1));
         }
      }
      
      public function get new_news() : Boolean
      {
         return this._new_news;
      }
      
      public function set new_news(param1:Boolean) : void
      {
         if(param1 != this.new_news)
         {
            this._new_news = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"new_news",!param1,param1));
         }
      }
      
      public function get new_achievements() : Boolean
      {
         return this._new_achievements;
      }
      
      public function set new_achievements(param1:Boolean) : void
      {
         if(param1 != this.new_achievements)
         {
            this._new_achievements = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"new_achievements",!param1,param1));
         }
      }
      
      public function get new_whisper() : Boolean
      {
         return this._new_whisper;
      }
      
      public function set new_whisper(param1:Boolean) : void
      {
         if(this.new_whisper != param1)
         {
            this._new_whisper = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"new_whisper",!param1,param1));
         }
      }
      
      override public function copyTo(param1:*) : void
      {
         param1.id = this.id;
         param1.name = this.name;
         param1.avatar_version = this.avatar_version;
         param1.foreign_type = this.foreign_type;
         param1.foreign_id = this.foreign_id;
         param1.user_level = this.user_level;
      }
      
      public function getAchievementProgress(param1:Achievement) : Number
      {
         return 0;
      }
   }
}
