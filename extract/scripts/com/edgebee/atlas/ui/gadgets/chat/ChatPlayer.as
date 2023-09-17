package com.edgebee.atlas.ui.gadgets.chat
{
   import com.edgebee.atlas.data.Player;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.PlayerLabel;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import flash.events.MouseEvent;
   
   public class ChatPlayer extends Box implements Listable
   {
      
      public static const PLAYER_DBCLICK:String = "PLAYER_DBCLICK";
       
      
      public var playerLbl:PlayerLabel;
      
      private var _player:WeakReference;
      
      private var _layout:Array;
      
      public function ChatPlayer()
      {
         this._player = new WeakReference(Player);
         this._layout = [{
            "CLASS":PlayerLabel,
            "ID":"playerLbl",
            "percentWidth":1
         }];
         super();
         doubleClickEnabled = true;
         verticalAlign = Box.ALIGN_MIDDLE;
         height = 18;
         addEventListener(MouseEvent.DOUBLE_CLICK,this.onDoubleClick);
      }
      
      public function get listElement() : Object
      {
         return this.player;
      }
      
      public function set listElement(param1:Object) : void
      {
         this.player = param1 as Player;
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
      
      public function get player() : Player
      {
         return this._player.get() as Player;
      }
      
      public function set player(param1:Player) : void
      {
         if(this.player != param1)
         {
            this._player.reset(param1);
            this.update();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.update();
      }
      
      private function update() : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(this.player)
            {
               this.playerLbl.player = this.player;
            }
            else
            {
               this.playerLbl.player = null;
            }
         }
      }
      
      private function onDoubleClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(PLAYER_DBCLICK,this.player,true));
      }
   }
}
