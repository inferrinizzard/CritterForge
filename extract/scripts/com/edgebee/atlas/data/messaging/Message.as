package com.edgebee.atlas.data.messaging
{
   import com.edgebee.atlas.data.*;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   
   public class Message extends Data
   {
      
      public static var ATTACHMENT_TYPES:Array;
      
      private static const _classinfo:Object = {
         "name":"Message",
         "cls":Message
      };
       
      
      public var id:uint;
      
      public var flags:int;
      
      public var sender:Player;
      
      public var npc_sender:String;
      
      public var date:Date;
      
      public var subject:String;
      
      public var body:String;
      
      private var _is_read:Boolean;
      
      private var _is_archived:Boolean;
      
      public var recipients:String;
      
      public var attachments:DataArray;
      
      public function Message(param1:Object = null)
      {
         var _loc2_:* = undefined;
         this.sender = new Player();
         this.date = new Date();
         this.attachments = new DataArray();
         for each(_loc2_ in ATTACHMENT_TYPES)
         {
            this.attachments.addType(_loc2_.classinfo);
         }
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get is_read() : Boolean
      {
         return this._is_read;
      }
      
      public function set is_read(param1:Boolean) : void
      {
         if(this._is_read != param1)
         {
            this._is_read = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"is_read",!param1,param1));
         }
      }
      
      public function get is_archived() : Boolean
      {
         return this._is_archived;
      }
      
      public function set is_archived(param1:Boolean) : void
      {
         if(this._is_archived != param1)
         {
            this._is_archived = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"is_archived",!param1,param1));
         }
      }
      
      public function get canDelete() : Boolean
      {
         var _loc2_:Attachment = null;
         var _loc1_:Boolean = true;
         for each(_loc2_ in this.attachments)
         {
            if(!_loc2_.canDelete)
            {
               _loc1_ = false;
               break;
            }
         }
         return !this.is_archived && _loc1_;
      }
   }
}
