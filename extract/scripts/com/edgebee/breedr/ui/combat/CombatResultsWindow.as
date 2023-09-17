package com.edgebee.breedr.ui.combat
{
   import com.edgebee.atlas.data.ArrayCollection;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.List;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.data.combat.CombatResult;
   import com.edgebee.breedr.data.ladder.ChallengeResults;
   import com.edgebee.breedr.ui.GameView;
   import flash.events.MouseEvent;
   
   public class CombatResultsWindow extends Window
   {
       
      
      private var _showAfterReplay:Boolean = false;
      
      private var _challengeResults:ChallengeResults;
      
      private var _results:ArrayCollection;
      
      private var _resultsLabelText;
      
      public var resultsLbl:Label;
      
      public var resultList:List;
      
      public var resultBox:Box;
      
      public var revealBtn:Button;
      
      private var _contentLayout:Array;
      
      public function CombatResultsWindow()
      {
         this._contentLayout = [{
            "CLASS":Box,
            "ID":"resultBox",
            "percentWidth":1,
            "height":UIGlobals.relativize(64),
            "horizontalAlign":Box.ALIGN_CENTER,
            "layoutInvisibleChildren":false,
            "CHILDREN":[{
               "CLASS":Label,
               "ID":"resultsLbl",
               "visible":false
            },{
               "CLASS":Button,
               "ID":"revealBtn",
               "label":Asset.getInstanceByName("REVEAL_CHALLENGE_RESULTS"),
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":this.onRevealClick
               }]
            }]
         },{
            "CLASS":List,
            "ID":"resultList",
            "renderer":CombatResultDisplay,
            "percentWidth":1,
            "selectable":false,
            "STYLES":{"Gap":3},
            "EVENTS":[{
               "TYPE":CombatResultDisplay.DO_PLAY,
               "LISTENER":this.onDoPlay
            }]
         }];
         super();
         rememberPositionId = "CombatResultsWindow";
         showCloseButton = true;
         width = UIGlobals.relativizeX(500);
         super.visible = false;
         client.service.addEventListener("GetSyndicateChallengeResults",this.onGetSyndicateChallengeResults);
         client.service.addEventListener("GetReplay",this.onGetReplay);
         client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
      }
      
      public function set challengeResults(param1:ChallengeResults) : void
      {
         var _loc2_:String = null;
         if(param1.winner == -1)
         {
            _loc2_ = param1.defender_name;
         }
         else if(param1.winner == 1)
         {
            _loc2_ = param1.challenger_name;
         }
         else
         {
            _loc2_ = Asset.getInstanceByName("CHALLENGE_RESULTS_TIE").value;
         }
         this.resultsLabelText = Utils.formatString(Asset.getInstanceByName("CHALLENGE_RESULTS").value,{"winner":_loc2_});
         this._results = param1.results;
         this.reset();
      }
      
      public function get results() : ArrayCollection
      {
         return this._results;
      }
      
      public function set results(param1:ArrayCollection) : void
      {
         this._results = param1;
         this.resultsLabelText = null;
         this.reset();
      }
      
      public function get showAfterReplay() : Boolean
      {
         return this._showAfterReplay;
      }
      
      public function set showAfterReplay(param1:Boolean) : void
      {
         if(param1 != this._showAfterReplay)
         {
            this._showAfterReplay = param1;
         }
      }
      
      override protected function doSetVisible(param1:Boolean) : void
      {
         var _loc2_:Window = null;
         super.doSetVisible(param1);
         if(param1)
         {
            _loc2_ = (UIGlobals.root as breedr_flash).rootView.gameView.controlBar.newsWindow;
            if(Boolean(_loc2_) && _loc2_.visible)
            {
               _loc2_.doClose();
            }
         }
      }
      
      override public function doClose() : void
      {
         this.results = null;
         visible = false;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         content.setStyle("Gap",5);
         title = Asset.getInstanceByName("RESULTS");
         UIUtils.performLayout(this,content,this._contentLayout);
         content.layoutInvisibleChildren = false;
         this.reset();
      }
      
      private function get resultsLabelText() : *
      {
         return this._resultsLabelText;
      }
      
      private function set resultsLabelText(param1:*) : void
      {
         this._resultsLabelText = param1;
         if(this.resultsLbl)
         {
            this.resultsLbl.text = this._resultsLabelText;
         }
      }
      
      private function reset() : void
      {
         var _loc1_:CombatResult = null;
         var _loc2_:uint = 0;
         if(childrenCreated || childrenCreating)
         {
            for each(_loc1_ in this.results)
            {
               _loc1_.resultVisible = false;
            }
            this.revealBtn.visible = true;
            this.resultsLbl.visible = false;
            this.resultsLbl.text = this._resultsLabelText;
            this.resultList.dataProvider = this._results;
            this.resultBox.visible = this._resultsLabelText != null;
            if(this._resultsLabelText == null)
            {
               this.doRevealResults();
            }
            _loc2_ = 0;
            if(this.results)
            {
               _loc2_ = uint(this.results.length);
            }
            this.resultList.heightInRows = _loc2_;
            invalidateSize();
            if(this.results)
            {
               visible = true;
            }
         }
      }
      
      private function onRevealClick(param1:MouseEvent) : void
      {
         (param1.currentTarget as Button).visible = false;
         this.resultsLbl.visible = this._resultsLabelText != null;
         this.doRevealResults();
      }
      
      private function doRevealResults() : void
      {
         var _loc1_:CombatResult = null;
         for each(_loc1_ in this.results)
         {
            _loc1_.resultVisible = true;
         }
      }
      
      private function onGetSyndicateChallengeResults(param1:ServiceEvent) : void
      {
         this.challengeResults = new ChallengeResults(param1.data.challenge_results);
      }
      
      private function onGetReplay(param1:ServiceEvent) : void
      {
         client.handleGameEvents(param1.data.events);
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms" && childrenCreated)
         {
            enabled = client.criticalComms == 0;
         }
      }
      
      public function onDoPlay(param1:ExtendedEvent) : void
      {
         var _loc3_:GameView = null;
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         var _loc2_:CombatResult = param1.data as CombatResult;
         if(_loc2_.events.length > 0)
         {
            client.criticalComms += 1;
            _loc3_ = (UIGlobals.root as breedr_flash).rootView.gameView;
            if(_loc3_.combatResultsWindow.visible)
            {
               _loc3_.combatResultsWindow.showAfterReplay = true;
            }
            client.handleGameEvents(_loc2_.events);
         }
         else
         {
            _loc4_ = _loc2_.replay_id;
            (_loc5_ = client.createInput()).replay_id = _loc4_;
            client.service.GetReplay(_loc5_);
            client.criticalComms += 1;
         }
      }
   }
}
