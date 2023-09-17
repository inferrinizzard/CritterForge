package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.FailedSkillEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class FailedSkillHandler extends Handler
   {
       
      
      public var data:FailedSkillEvent;
      
      public var manager:EventProcessor;
      
      public function FailedSkillHandler(param1:FailedSkillEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoFailedSkill(this));
      }
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.skill.SkillInstance;
import com.edgebee.breedr.events.combat.FailedSkillEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.FailedSkillHandler;
import com.edgebee.breedr.ui.combat.ActorView;
import com.edgebee.breedr.ui.combat.CombatView;
import com.edgebee.breedr.ui.combat.IdleDisplay;

class DoFailedSkill extends CombatHandlerState
{
    
   
   public function DoFailedSkill(param1:FailedSkillHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc7_:String = null;
      super.transitionInto(param1);
      var _loc2_:FailedSkillEvent = (machine as FailedSkillHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance = _loc3_.getCreatureById(_loc2_.user_id);
      var _loc5_:ActorView = _loc3_.getViewById(_loc2_.user_id);
      var _loc6_:SkillInstance = _loc4_.findSkill(_loc2_.skill_id);
      if(_loc2_.reason == FailedSkillEvent.REASON_NOT_ENOUGH_PP)
      {
         _loc7_ = Asset.getInstanceByName("FAILED_SKILL_LOG_REASON_NOT_ENOUGH_PP").value;
         _loc5_.showIdle(IdleDisplay.NOT_ENOUGH_PP);
      }
      else if(_loc2_.reason == FailedSkillEvent.REASON_CANNOT_COUNTER)
      {
         _loc7_ = Asset.getInstanceByName("FAILED_SKILL_LOG_REASON_CANNOT_COUNTER").value;
      }
      else if(_loc2_.reason == FailedSkillEvent.REASON_NEEDS_MOVEMENT)
      {
         _loc7_ = Asset.getInstanceByName("FAILED_SKILL_LOG_REASON_NEEDS_MOVEMENT").value;
      }
      else if(_loc2_.reason == FailedSkillEvent.REASON_NEEDS_THINKING)
      {
         _loc7_ = Asset.getInstanceByName("FAILED_SKILL_LOG_REASON_NEEDS_THINKING").value;
      }
      else
      {
         _loc7_ = "but " + _loc2_.reason.toString();
      }
      var _loc8_:FailedSkillLog;
      (_loc8_ = new FailedSkillLog()).pre = Utils.htmlWrap(Utils.formatString(Asset.getInstanceByName("FAILED_SKILL_LOG_START").value,{"name":decorateName(_loc4_.name)}),loggingBox.getStyle("FontFamily"),loggingBox.getStyle("FontColor"),loggingBox.getStyle("FontSize"));
      _loc8_.skill = _loc6_;
      _loc8_.post = Utils.htmlWrap(_loc7_,loggingBox.getStyle("FontFamily"),loggingBox.getStyle("FontColor"),loggingBox.getStyle("FontSize"));
      loggingBox.print(_loc8_);
      _loc5_.showAction();
      timer.delay = 1000 / client.combatSpeedMultiplier;
      timer.start();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(timerComplete)
      {
         return Result.STOP;
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.ui.containers.Box;
import com.edgebee.atlas.ui.controls.Label;
import com.edgebee.atlas.ui.controls.Spacer;
import com.edgebee.atlas.ui.utils.UIUtils;
import com.edgebee.breedr.data.skill.SkillInstance;
import com.edgebee.breedr.ui.skill.MiniSkillView;

class FailedSkillLog extends Box
{
    
   
   public var pre:String;
   
   public var post:String;
   
   public var skill:SkillInstance;
   
   public var preLbl:Label;
   
   public var postLbl:Label;
   
   public var skillView:MiniSkillView;
   
   private var _layout:Array;
   
   public function FailedSkillLog()
   {
      this._layout = [{
         "CLASS":Label,
         "ID":"preLbl",
         "useHtml":true,
         "filters":UIGlobals.fontOutline
      },{
         "CLASS":Spacer,
         "width":3
      },{
         "CLASS":MiniSkillView,
         "ID":"skillView",
         "size":UIGlobals.relativize(12)
      },{
         "CLASS":Spacer,
         "width":3
      },{
         "CLASS":Label,
         "ID":"postLbl",
         "useHtml":true,
         "filters":UIGlobals.fontOutline
      }];
      super(Box.HORIZONTAL,Box.ALIGN_LEFT,Box.ALIGN_MIDDLE);
   }
   
   override protected function createChildren() : void
   {
      super.createChildren();
      UIUtils.performLayout(this,this,this._layout);
      this.preLbl.text = this.pre;
      this.skillView.skill = this.skill;
      this.postLbl.text = this.post;
   }
}
