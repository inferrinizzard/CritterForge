package com.edgebee.breedr.data.news
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.l10n.FormattedAsset;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import flash.events.Event;
   
   public class News extends Data
   {
      
      public static const TYPE_PLAYER:int = 0;
      
      public static const TYPE_GUILD:int = 1;
      
      public static const TYPE_ZONE:int = 2;
      
      public static const TYPE_WORLD:int = 3;
      
      private static const _classinfo:Object = {
         "name":"News",
         "cls":News
      };
       
      
      public var id:uint;
      
      public var type:int;
      
      public var date:Date;
      
      public var title:FormattedAsset;
      
      public var body:FormattedAsset;
      
      public function News(param1:Object = null)
      {
         this.title = new FormattedAsset();
         this.title.addEventListener(Event.CHANGE,this.onTitleChange);
         this.body = new FormattedAsset();
         this.body.addEventListener(Event.CHANGE,this.onBodyChange);
         this.date = new Date();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      private function onTitleChange(param1:Event) : void
      {
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"title",null,this.title));
      }
      
      private function onBodyChange(param1:Event) : void
      {
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"body",null,this.body));
      }
   }
}
