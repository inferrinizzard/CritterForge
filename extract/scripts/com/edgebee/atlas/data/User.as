package com.edgebee.atlas.data
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   
   public class User extends Data
   {
      
      public static const TYPE_NORMAL:int = 0;
      
      public static const TYPE_NO_ADDS:int = 1;
      
      public static const TYPE_CHEATER:int = 2;
      
      public static const STATE_ANONYMOUS:int = 0;
      
      public static const STATE_NAMED_EMAIL_NOT_SENT:int = 1;
      
      public static const STATE_NAMED_EMAIL_SENT:int = 2;
      
      public static const STATE_NAMED_INVALID:int = 3;
      
      public static const STATE_REGISTERED:int = 4;
      
      public static const FREELOADER:int = 0;
      
      public static const CONTRIBUTOR:int = 1;
      
      public static const SUPPORTER:int = 2;
      
      public static const FANATIC:int = 3;
       
      
      public var id:uint;
      
      public var type:int;
      
      public var name:String;
      
      private var _nicename:String;
      
      public var password:String;
      
      public var email:String;
      
      public var online:Boolean;
      
      private var _state:uint;
      
      public var locale:String;
      
      public var friends:Array;
      
      public var level:uint;
      
      private var _tokens:uint;
      
      public function User(param1:Object = null)
      {
         super(param1);
      }
      
      public function get showAdvertisements() : Boolean
      {
         return !(this.type & TYPE_NO_ADDS);
      }
      
      public function get canCheat() : Boolean
      {
         return Boolean(this.type & TYPE_CHEATER);
      }
      
      public function get nicename() : String
      {
         if(this._nicename)
         {
            return this._nicename;
         }
         return this.name;
      }
      
      public function set nicename(param1:String) : void
      {
         this._nicename = param1;
      }
      
      public function get state() : uint
      {
         return this._state;
      }
      
      public function set state(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._state != param1)
         {
            _loc2_ = this._state;
            this._state = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"state",_loc2_,param1));
         }
      }
      
      public function get anonymous() : Boolean
      {
         return this.state == STATE_ANONYMOUS;
      }
      
      public function get registered() : Boolean
      {
         return this.state == STATE_REGISTERED;
      }
      
      public function get tokens() : uint
      {
         return this._tokens;
      }
      
      public function set tokens(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._tokens != param1)
         {
            _loc2_ = this._tokens;
            this._tokens = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"tokens",_loc2_,param1));
         }
      }
   }
}
