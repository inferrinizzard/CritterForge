package com.edgebee.breedr.ui.creature
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.GradientLabel;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.data.skill.SkillInstance;
   import com.edgebee.breedr.ui.skill.MiniSkillView;
   
   public class SkillStatusView extends Box
   {
       
      
      private var _skill:WeakReference;
      
      public var index:uint = 0;
      
      public var indexLbl:GradientLabel;
      
      public var skillView:MiniSkillView;
      
      public var skillName:GradientLabel;
      
      public var ruleLbl:Label;
      
      public var ppCostLbl:GradientLabel;
      
      private var _layout:Array;
      
      public function SkillStatusView()
      {
         this._skill = new WeakReference(null,SkillInstance);
         this._layout = [{
            "CLASS":GradientLabel,
            "ID":"indexLbl",
            "alpha":0.5,
            "filters":UIGlobals.fontOutline,
            "STYLES":{
               "FontWeight":"bold",
               "FontSize":UIGlobals.relativizeFont(48)
            }
         },{
            "CLASS":Spacer,
            "width":UIGlobals.relativize(10)
         },{
            "CLASS":MiniSkillView,
            "ID":"skillView",
            "size":UIGlobals.relativize(32)
         },{
            "CLASS":Spacer,
            "percentWidth":1
         },{
            "CLASS":Box,
            "direction":Box.VERTICAL,
            "percentHeight":1,
            "horizontalAlign":Box.ALIGN_RIGHT,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "filters":UIGlobals.fontOutline,
            "CHILDREN":[{
               "CLASS":Box,
               "CHILDREN":[{
                  "CLASS":GradientLabel,
                  "ID":"skillName",
                  "colors":[11184810,16777215],
                  "STYLES":{
                     "FontWeight":"bold",
                     "FontSize":UIGlobals.relativizeFont(20)
                  }
               },{
                  "CLASS":GradientLabel,
                  "ID":"ppCostLbl",
                  "colors":[UIGlobals.getStyle("PPColor"),UIUtils.adjustBrightness2(UIGlobals.getStyle("PPColor"),85)],
                  "STYLES":{
                     "FontWeight":"bold",
                     "FontSize":UIGlobals.relativizeFont(20)
                  }
               }]
            },{
               "CLASS":Label,
               "ID":"ruleLbl",
               "useHtml":true,
               "STYLES":{"FontColor":16777215}
            }]
         }];
         super(Box.HORIZONTAL,Box.ALIGN_LEFT,Box.ALIGN_MIDDLE);
         setStyle("Gap",0);
         setStyle("Padding",2);
         setStyle("BackgroundAlpha",0.25);
         setStyle("CornerRadius",5);
         spreadProportionality = false;
      }
      
      public function get skill() : SkillInstance
      {
         return this._skill.get() as SkillInstance;
      }
      
      public function set skill(param1:SkillInstance) : void
      {
         if(this.skill != param1)
         {
            if(this.skill)
            {
               this.skill.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onSkillChange);
            }
            this._skill.reset(param1);
            if(this.skill)
            {
               this.skill.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onSkillChange);
            }
            this.update();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.update();
      }
      
      private function onSkillChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(childrenCreated || childrenCreating)
         {
            if(this.skill)
            {
               visible = true;
               this.indexLbl.text = this.index.toString();
               this.skillView.skill = this.skill;
               this.skillName.text = this.skill.name;
               this.ppCostLbl.text = Utils.formatString(Asset.getInstanceByName("PP_COST").value,{"cost":this.skill.dynamicPPCost});
               _loc1_ = this.skill.rule_targets_enemy ? Asset.getInstanceByName("RULE_WHEN_ENEMY").value : Asset.getInstanceByName("RULE_WHEN_SELF").value;
               if(this.skill.rule_id > 0)
               {
                  _loc2_ = String(this.skill.rule.description.value);
               }
               else
               {
                  _loc2_ = Asset.getInstanceByName("RULE_NOT_SET").value;
               }
               this.ruleLbl.text = Utils.htmlWrap(Utils.formatString("{target} : {rule}",{
                  "target":Utils.htmlWrap(_loc1_,null,this.skill.rule_targets_enemy ? 16764057 : 10079487,0,true,true),
                  "rule":_loc2_
               }),null,14540253,UIGlobals.relativize(16));
            }
            else
            {
               visible = false;
               this.skillView.skill = null;
            }
         }
      }
   }
}
