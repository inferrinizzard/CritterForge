package com.edgebee.breedr.ui.combat
{
   import com.edgebee.atlas.data.ArrayCollection;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.List;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.data.combat.CombatResult;
   import flash.events.MouseEvent;
   
   public class CombatResultsView extends Box
   {
       
      
      private var _results:ArrayCollection;
      
      private var _resultsLabelText;
      
      public var resultsLbl:Label;
      
      public var resultList:List;
      
      private var _layout:Array;
      
      public function CombatResultsView()
      {
         this._layout = [{
            "CLASS":Box,
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
            "STYLES":{"Gap":3}
         }];
         super();
         percentWidth = 1;
         direction = Box.VERTICAL;
         setStyle("Gap",10);
         this._results = new ArrayCollection();
      }
      
      public function get results() : ArrayCollection
      {
         return this._results;
      }
      
      public function set results(param1:ArrayCollection) : void
      {
         this._results = param1;
         this.reset();
      }
      
      public function get resultsLabelText() : *
      {
         return this._resultsLabelText;
      }
      
      public function set resultsLabelText(param1:*) : void
      {
         this._resultsLabelText = param1;
         if(this.resultsLbl)
         {
            this.resultsLbl.text = this._resultsLabelText;
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
         if(childrenCreated || childrenCreating)
         {
            this.resultsLbl.text = this._resultsLabelText;
            this.resultList.dataProvider = this._results;
            this.resultList.heightInRows = this._results.length;
            invalidateSize();
         }
      }
      
      private function onRevealClick(param1:MouseEvent) : void
      {
         var _loc2_:CombatResult = null;
         (param1.currentTarget as Button).visible = false;
         this.resultsLbl.visible = true;
         for each(_loc2_ in this.results)
         {
            _loc2_.resultVisible = true;
         }
      }
   }
}
