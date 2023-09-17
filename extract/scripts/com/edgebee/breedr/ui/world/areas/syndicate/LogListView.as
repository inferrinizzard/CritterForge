package com.edgebee.breedr.ui.world.areas.syndicate
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Log;
   import com.edgebee.breedr.data.player.Player;
   
   public class LogListView extends Box implements Listable
   {
       
      
      private var _selected:Boolean = false;
      
      private var _highlighted:Boolean = false;
      
      private var _log:WeakReference;
      
      private var _mouseDown:Boolean = false;
      
      public var textLbl:Label;
      
      public var dateLbl:Label;
      
      private var _layout:Array;
      
      public function LogListView()
      {
         this._log = new WeakReference(null,Log);
         this._layout = [{
            "CLASS":Label,
            "ID":"textLbl",
            "useHtml":true
         },{
            "CLASS":Spacer,
            "percentWidth":1
         },{
            "CLASS":Label,
            "ID":"dateLbl",
            "STYLES":{
               "FontColor":16776960,
               "FontSize":UIGlobals.relativizeFont(12)
            }
         }];
         super(Box.HORIZONTAL,Box.ALIGN_LEFT,Box.ALIGN_MIDDLE);
         percentWidth = 1;
         filters = UIGlobals.fontOutline;
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get listElement() : Object
      {
         return this.log;
      }
      
      public function set listElement(param1:Object) : void
      {
         this.log = param1 as Log;
      }
      
      public function get log() : Log
      {
         return this._log.get() as Log;
      }
      
      public function set log(param1:Log) : void
      {
         if(this.log != param1)
         {
            if(this.log)
            {
               this.log.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onLogChange);
            }
            this._log.reset(param1);
            if(this.log)
            {
               this.log.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onLogChange);
            }
            if(childrenCreated)
            {
               this.update();
            }
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
      }
      
      public function get highlighted() : Boolean
      {
         return this._highlighted;
      }
      
      public function set highlighted(param1:Boolean) : void
      {
         this._highlighted = param1;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         visible = false;
         this.update();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
      }
      
      private function onLogChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         if(this.log)
         {
            visible = true;
            this.textLbl.text = Utils.htmlWrap(this.log.text.text,null,16777215,UIGlobals.relativizeFont(12));
            this.dateLbl.text = Utils.dateToElapsed(this.log.date);
            toolTip = this.log.text.text + "<br>" + Utils.getLocalDateTimeString(this.log.date);
         }
         else
         {
            visible = false;
            toolTip = "";
         }
      }
   }
}
