package com.edgebee.breedr.ui.combat
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.data.combat.CombatResult;
   import com.edgebee.breedr.ui.creature.CreatureView;
   import flash.events.MouseEvent;
   
   public class CombatResultDisplay extends Box implements Listable
   {
      
      public static const DO_PLAY:String = "DO_PLAY";
      
      public static const HEIGHT:Number = UIGlobals.relativize(48);
       
      
      private var _result:CombatResult;
      
      public var challengerView:CreatureView;
      
      public var defenderView:CreatureView;
      
      public var resultLbl:Label;
      
      public var replayBtn:Button;
      
      private var _layout:Array;
      
      public function CombatResultDisplay()
      {
         this._layout = [{
            "CLASS":Box,
            "percentWidth":1,
            "autoSizeChildren":true,
            "CHILDREN":[{
               "CLASS":Box,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "CHILDREN":[{
                  "CLASS":CreatureView,
                  "ID":"challengerView",
                  "height":HEIGHT,
                  "width":HEIGHT,
                  "layered":false
               },{
                  "CLASS":Label,
                  "text":"vs"
               },{
                  "CLASS":CreatureView,
                  "ID":"defenderView",
                  "height":HEIGHT,
                  "width":HEIGHT,
                  "layered":false
               }]
            },{
               "CLASS":Spacer,
               "percentWidth":0.5
            },{
               "CLASS":Box,
               "horizontalAlign":Box.ALIGN_CENTER,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "CHILDREN":[{
                  "CLASS":Label,
                  "ID":"resultLbl",
                  "visible":false
               }]
            },{
               "CLASS":Spacer,
               "percentWidth":0.5
            },{
               "CLASS":Box,
               "horizontalAlign":Box.ALIGN_RIGHT,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "CHILDREN":[{
                  "CLASS":Button,
                  "ID":"replayBtn",
                  "label":Asset.getInstanceByName("PLAY"),
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":this.onPlayClick
                  }]
               }]
            }]
         }];
         super();
         height = HEIGHT;
         percentWidth = 1;
      }
      
      public function get listElement() : Object
      {
         return this._result;
      }
      
      public function set listElement(param1:Object) : void
      {
         if(this._result)
         {
            this._result.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onResultChange);
         }
         this._result = param1 as CombatResult;
         if(this._result)
         {
            this._result.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onResultChange);
         }
         this.reset();
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
      
      public function set showResults(param1:Boolean) : void
      {
         if(this.resultLbl)
         {
            this.resultLbl.visible = param1;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.reset();
      }
      
      private function reset() : void
      {
         var _loc1_:String = null;
         if(childrenCreated || childrenCreating)
         {
            if(this._result)
            {
               this.challengerView.creature = this._result.challenger.ref;
               this.defenderView.creature = this._result.defender.ref;
               if(this._result.winner == -1)
               {
                  _loc1_ = String(this._result.defender.ref.name);
               }
               else if(this._result.winner == 1)
               {
                  _loc1_ = String(this._result.challenger.ref.name);
               }
               else
               {
                  _loc1_ = Asset.getInstanceByName("CHALLENGE_RESULTS_TIE").value;
               }
               this.resultLbl.text = Utils.formatString(Asset.getInstanceByName("CHALLENGE_RESULTS").value,{"winner":_loc1_});
               this.resultLbl.visible = this._result.resultVisible;
               this.replayBtn.visible = this._result.replay_id != 0 || this._result.events.length > 0;
               visible = true;
            }
            else
            {
               visible = false;
            }
         }
      }
      
      private function onResultChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "resultVisible")
         {
            this.showResults = param1.newValue;
         }
      }
      
      public function onPlayClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(DO_PLAY,this._result,true));
      }
   }
}
