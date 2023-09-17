package com.edgebee.atlas.data.l10n
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.util.Utils;
   import flash.events.Event;
   
   public class FormattedAsset extends Data
   {
       
      
      public var id:uint;
      
      public var format_id:uint;
      
      public var parts:DataArray;
      
      public function FormattedAsset(param1:Object = null)
      {
         this.parts = new DataArray(AssetPart.classinfo,StringPart.classinfo);
         super(param1);
      }
      
      public function get format() : Asset
      {
         return Asset.getInstanceById(this.format_id);
      }
      
      public function get text() : String
      {
         var _loc2_:FormattedAssetPart = null;
         var _loc1_:Object = {};
         for each(_loc2_ in this.parts)
         {
            _loc1_[_loc2_.name] = _loc2_.text;
         }
         return Utils.formatString(this.format.value,_loc1_);
      }
      
      public function init(param1:Asset, param2:DataArray) : void
      {
         this.format_id = param1.id;
         this.parts = param2;
         this.finalize();
      }
      
      override protected function finalize() : void
      {
         var _loc1_:FormattedAssetPart = null;
         super.finalize();
         this.format.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onFormatChange);
         for each(_loc1_ in this.parts)
         {
            _loc1_.addEventListener(Event.CHANGE,this.onPartsChange);
         }
      }
      
      private function onFormatChange(param1:PropertyChangeEvent) : void
      {
         dispatchEvent(new Event(Event.CHANGE));
         dispatchEvent(PropertyChangeEvent.create(this,"text",this.text,this.text));
      }
      
      private function onPartsChange(param1:Event) : void
      {
         dispatchEvent(new Event(Event.CHANGE));
         dispatchEvent(PropertyChangeEvent.create(this,"text",this.text,this.text));
      }
   }
}
