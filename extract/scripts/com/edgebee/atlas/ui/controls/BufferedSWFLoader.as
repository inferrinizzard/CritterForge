package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.ui.containers.Canvas;
   import flash.events.Event;
   
   public class BufferedSWFLoader extends Canvas
   {
       
      
      private var _maintainAspectRatio:Boolean = false;
      
      private var _images:Array;
      
      private var _current:uint = 0;
      
      private const _bufferSize:uint = 10;
      
      public function BufferedSWFLoader()
      {
         this._images = [];
         super();
      }
      
      public function get source() : String
      {
         return this._images[this._current].source;
      }
      
      public function set source(param1:String) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ImageInfo = null;
         if(!param1)
         {
            this.current.image.visible = false;
         }
         else
         {
            this.current.image.visible = true;
         }
         if(this.current.image.source == param1)
         {
            dispatchEvent(new Event(Event.COMPLETE));
            return;
         }
         _loc2_ = 0;
         for each(_loc3_ in this._images)
         {
            if(_loc3_.image.source == param1)
            {
               this.current.image.visible = false;
               this._current = _loc2_;
               this.current.image.visible = true;
               ++this.current.useCount;
               dispatchEvent(new Event(Event.COMPLETE));
               return;
            }
            _loc2_++;
         }
         this.current.image.visible = false;
         this._current = this.getLeastUsed();
         this.current.image.source = param1;
         this.current.image.visible = true;
      }
      
      public function get maintainAspectRatio() : Boolean
      {
         return this._maintainAspectRatio;
      }
      
      public function set maintainAspectRatio(param1:Boolean) : void
      {
         var _loc2_:ImageInfo = null;
         if(this._maintainAspectRatio != param1)
         {
            this._maintainAspectRatio = param1;
            for each(_loc2_ in this._images)
            {
               _loc2_.image.maintainAspectRatio = param1;
            }
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:SWFLoader = null;
         super.createChildren();
         var _loc2_:uint = 0;
         while(_loc2_ < this._bufferSize)
         {
            _loc1_ = new SWFLoader();
            _loc1_.percentWidth = 1;
            _loc1_.percentHeight = 1;
            _loc1_.visible = false;
            _loc1_.maintainAspectRatio = this.maintainAspectRatio;
            _loc1_.addEventListener(Event.COMPLETE,this.onImageLoaded);
            addChild(_loc1_);
            this._images.push(new ImageInfo(_loc1_));
            _loc2_++;
         }
         if(shadowBorder)
         {
            removeChild(shadowBorder);
            addChild(shadowBorder);
         }
      }
      
      private function get current() : ImageInfo
      {
         return this._images[this._current];
      }
      
      private function onImageLoaded(param1:Event) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function getLeastUsed() : uint
      {
         var _loc3_:ImageInfo = null;
         var _loc4_:uint = 0;
         var _loc1_:uint = 0;
         var _loc2_:uint = uint.MAX_VALUE;
         while(_loc4_ < this._bufferSize)
         {
            if(_loc4_ != this._current)
            {
               _loc3_ = this._images[_loc4_] as ImageInfo;
               if(_loc3_.useCount < _loc2_)
               {
                  _loc2_ = _loc3_.useCount;
                  _loc1_ = _loc4_;
               }
            }
            _loc4_++;
         }
         return _loc1_;
      }
   }
}

import com.edgebee.atlas.ui.controls.SWFLoader;

class ImageInfo
{
    
   
   public var image:SWFLoader;
   
   public var useCount:uint = 0;
   
   public function ImageInfo(param1:SWFLoader)
   {
      super();
      this.image = param1;
   }
}
