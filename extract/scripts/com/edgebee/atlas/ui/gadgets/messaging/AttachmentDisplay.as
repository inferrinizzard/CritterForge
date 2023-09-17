package com.edgebee.atlas.ui.gadgets.messaging
{
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.data.messaging.Attachment;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   
   public class AttachmentDisplay extends Box implements Listable
   {
      
      public static const START_EXECUTE_ATTACHMENT:String = "START_EXECUTE_ATTACHMENT";
      
      public static const STOP_EXECUTE_ATTACHMENT:String = "STOP_EXECUTE_ATTACHMENT";
      
      public static var ATTACHMENT_DISPLAYS:Object = {};
       
      
      private var _attachment:Attachment;
      
      public function AttachmentDisplay()
      {
         super();
      }
      
      public function get listElement() : Object
      {
         return this._attachment;
      }
      
      public function set listElement(param1:Object) : void
      {
         if(param1 != this._attachment)
         {
            this._attachment = param1 as Attachment;
            invalidateSize();
            this.reset();
         }
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get selected() : Boolean
      {
         return false;
      }
      
      public function set selected(param1:Boolean) : void
      {
      }
      
      public function get highlighted() : Boolean
      {
         return false;
      }
      
      public function set highlighted(param1:Boolean) : void
      {
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.reset();
      }
      
      protected function reset() : void
      {
         var _loc1_:Class = null;
         var _loc2_:BaseAttachmentDisplay = null;
         if(childrenCreated || childrenCreating)
         {
            if(this._attachment)
            {
               removeAllChildren();
               _loc1_ = ATTACHMENT_DISPLAYS[this._attachment.type];
               if(!_loc1_)
               {
                  throw new Error("No attachment display configured for attachment type " + this._attachment.type);
               }
               _loc2_ = new _loc1_();
               _loc2_.attachment = this._attachment;
               addChild(_loc2_);
               visible = true;
            }
            else
            {
               visible = false;
            }
         }
      }
   }
}
