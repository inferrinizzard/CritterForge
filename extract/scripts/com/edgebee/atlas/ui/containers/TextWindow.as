package com.edgebee.atlas.ui.containers
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.controls.TextArea;
   import flash.events.Event;
   
   public class TextWindow extends Window
   {
       
      
      private var _scrollableBox:com.edgebee.atlas.ui.containers.ScrollableBox;
      
      protected var textArea:TextArea;
      
      private var _text;
      
      public function TextWindow()
      {
         super();
      }
      
      public function get text() : *
      {
         return this._text;
      }
      
      public function set text(param1:*) : void
      {
         this._text = param1;
         this.update();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._scrollableBox = new com.edgebee.atlas.ui.containers.ScrollableBox();
         this._scrollableBox.percentWidth = 1;
         this._scrollableBox.percentHeight = 1;
         this._scrollableBox.addEventListener(Component.CHILDREN_CREATED,this.onSBChildrenCreated);
         content.addChild(this._scrollableBox);
      }
      
      protected function onSBChildrenCreated(param1:Event) : void
      {
         this.textArea = new TextArea();
         this.textArea.percentWidth = 1;
         this._scrollableBox.content.addChild(this.textArea);
         this.update();
      }
      
      protected function update() : void
      {
         if(this.text && Boolean(this.textArea))
         {
            this.textArea.text = this.text;
         }
      }
   }
}
