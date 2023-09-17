package com.edgebee.breedr.ui.messaging
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.gadgets.messaging.BaseAttachmentDisplay;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.data.combat.CombatResult;
   import com.edgebee.breedr.data.ladder.ChallengeResults;
   import com.edgebee.breedr.data.message.Attachment;
   import com.edgebee.breedr.ui.combat.CombatResultDisplay;
   import com.edgebee.breedr.ui.combat.CombatResultsView;
   
   public class ChallengeResultsDisplay extends BaseAttachmentDisplay
   {
       
      
      public var resultsView:CombatResultsView;
      
      private var _layout:Array;
      
      public function ChallengeResultsDisplay()
      {
         this._layout = [{
            "CLASS":CombatResultsView,
            "ID":"resultsView"
         }];
         super();
         percentWidth = 1;
         direction = Box.VERTICAL;
         setStyle("Gap",10);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.reset();
      }
      
      override protected function reset() : void
      {
         var _loc1_:Attachment = null;
         var _loc2_:ChallengeResults = null;
         var _loc3_:String = null;
         super.reset();
         if((childrenCreated || childrenCreating) && Boolean(attachment))
         {
            UIUtils.performLayout(this,this,this._layout);
            _loc1_ = attachment as Attachment;
            _loc2_ = _loc1_.challenge_results.ref as ChallengeResults;
            this.resultsView.results = _loc2_.results;
            this.resultsView.addEventListener(CombatResultDisplay.DO_PLAY,this.onDoPlay);
            if(_loc2_.winner == -1)
            {
               _loc3_ = _loc2_.defender_name;
            }
            else if(_loc2_.winner == 1)
            {
               _loc3_ = _loc2_.challenger_name;
            }
            else
            {
               _loc3_ = Asset.getInstanceByName("CHALLENGE_RESULTS_TIE").value;
            }
            this.resultsView.resultsLabelText = Utils.formatString(Asset.getInstanceByName("CHALLENGE_RESULTS").value,{"winner":_loc3_});
         }
      }
      
      override protected function update() : void
      {
      }
      
      public function onDoPlay(param1:ExtendedEvent) : void
      {
         (UIGlobals.root as breedr_flash).rootView.gameView.controlBar.inboxWindow.doClose();
         var _loc2_:CombatResult = param1.data as CombatResult;
         executeAttachment(_loc2_.replay_id);
         ++client.criticalComms;
      }
   }
}
