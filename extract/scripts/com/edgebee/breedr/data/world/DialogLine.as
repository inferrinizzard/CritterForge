package com.edgebee.breedr.data.world
{
   import com.edgebee.atlas.data.*;
   import com.edgebee.atlas.data.l10n.*;
   
   public class DialogLine extends Data
   {
      
      public static const EXPRESSIONS_MASK:Number = 255;
      
      public static const REQUIRES_PARAM:Number = 256;
      
      public static const HIGHLIGHT_COMPONENT:Number = 512;
      
      public static const SWAP_NPC:Number = 1024;
      
      public static const EVENT_ON_COMPLETE:Number = 2048;
      
      public static const HAS_TTL:Number = 4096;
      
      public static const PAUSE_ON_COMPLETE:Number = 8192;
      
      public static const NO_CLICK:Number = 16384;
      
      public static const USE_BG:Number = 32768;
      
      public static const ALT_POSITION:Number = 65536;
      
      private static const _classinfo:Object = {
         "name":"DialogLine",
         "cls":DialogLine
      };
       
      
      public var id:uint;
      
      public var uid:String;
      
      public var flags:Number;
      
      public var data:Object;
      
      public var text_id:uint;
      
      public var dialog_id:uint;
      
      public function DialogLine(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      override public function get classinfo() : Object
      {
         return DialogLine.classinfo;
      }
      
      public function get text() : Asset
      {
         return Asset.getInstanceById(this.text_id);
      }
      
      public function get dialog() : Dialog
      {
         return Dialog.getInstanceById(this.dialog_id);
      }
      
      public function get npc() : NonPlayerCharacter
      {
         if(this.flags & SWAP_NPC)
         {
            if(!this.data.hasOwnProperty("npc"))
            {
               throw new Error("Missing NPC id in line data");
            }
            return NonPlayerCharacter.getInstanceByCodename(this.data.npc);
         }
         return this.dialog.npc;
      }
      
      public function get bg() : String
      {
         if(this.flags & USE_BG)
         {
            if(!this.data.hasOwnProperty("bg"))
            {
               throw new Error("Missing bg key line data");
            }
            return this.data.bg;
         }
         return null;
      }
   }
}
