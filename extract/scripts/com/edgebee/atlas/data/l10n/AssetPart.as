package com.edgebee.atlas.data.l10n
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import flash.events.Event;
   
   public class AssetPart extends FormattedAssetPart
   {
      
      private static const _classinfo:Object = {
         "name":"AssetPart",
         "cls":AssetPart
      };
       
      
      public var value:uint;
      
      public function AssetPart(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      override public function get text() : String
      {
         return Asset.getInstanceById(this.value).value;
      }
      
      override protected function finalize() : void
      {
         Asset.getInstanceById(this.value).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onAssetChange);
      }
      
      private function onAssetChange(param1:PropertyChangeEvent) : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}
