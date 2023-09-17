package com.edgebee.atlas.ui.containers
{
   import com.edgebee.atlas.events.ScrollEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.Scrollable;
   import com.edgebee.atlas.ui.controls.ScrollBar;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.events.Event;
   
   public class ScrollableBox extends com.edgebee.atlas.ui.containers.Box implements Scrollable
   {
       
      
      public var content:com.edgebee.atlas.ui.containers.Box;
      
      public var holderCanvas:com.edgebee.atlas.ui.containers.Canvas;
      
      public var scrollBar:ScrollBar;
      
      private var _layout:Array;
      
      public function ScrollableBox()
      {
         this._layout = [{
            "CLASS":com.edgebee.atlas.ui.containers.Canvas,
            "ID":"holderCanvas",
            "percentWidth":1,
            "percentHeight":1,
            "EVENTS":[{
               "TYPE":Component.RESIZE,
               "LISTENER":"onContentResize"
            }],
            "CHILDREN":[{
               "CLASS":com.edgebee.atlas.ui.containers.Box,
               "ID":"content",
               "percentWidth":1,
               "EVENTS":[{
                  "TYPE":Component.RESIZE,
                  "LISTENER":"onContentResize"
               }]
            }]
         },{
            "CLASS":ScrollBar,
            "ID":"scrollBar",
            "percentHeight":1,
            "scrollable":"{this}"
         }];
         super();
         clipContent = true;
         direction = com.edgebee.atlas.ui.containers.Box.HORIZONTAL;
      }
      
      public function get scrollStepSize() : Number
      {
         return 30;
      }
      
      public function get scrollPosition() : Number
      {
         return this.content.y;
      }
      
      public function set scrollPosition(param1:Number) : void
      {
         this.content.y = param1;
      }
      
      public function get scrollMinPosition() : Number
      {
         return 0;
      }
      
      public function get scrollVisibleSize() : Number
      {
         return this.holderCanvas.height;
      }
      
      public function get scrollMaxPosition() : Number
      {
         return this.content.height;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
      }
      
      public function onContentResize(param1:Event) : void
      {
         dispatchEvent(new ScrollEvent(ScrollEvent.CONTENT_RESIZE));
      }
   }
}
