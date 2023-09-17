package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.SkillEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class SkillHandler extends Handler
   {
      
      public static var AttackWav:Class = SkillHandler_AttackWav;
      
      public static var DirectWav:Class = SkillHandler_DirectWav;
      
      public static var ElementalWav:Class = SkillHandler_ElementalWav;
      
      public static var ActionWav:Class = SkillHandler_ActionWav;
       
      
      public var data:SkillEvent;
      
      public var manager:EventProcessor;
      
      public function SkillHandler(param1:SkillEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoSkill(this));
      }
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.skill.SkillInstance;
import com.edgebee.breedr.events.combat.SkillEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.SkillHandler;
import com.edgebee.breedr.ui.combat.ActorView;
import com.edgebee.breedr.ui.combat.CombatView;

class DoSkill extends CombatHandlerState
{
    
   
   public function DoSkill(param1:SkillHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc7_:SkillLog = null;
      var _loc8_:String = null;
      super.transitionInto(param1);
      var _loc2_:SkillEvent = (machine as SkillHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance = _loc3_.getCreatureById(_loc2_.user_id);
      var _loc5_:ActorView = _loc3_.getViewById(_loc2_.user_id);
      var _loc6_:SkillInstance;
      if((_loc6_ = _loc4_.findSkill(_loc2_.skill_id)).originalIndex)
      {
         (_loc7_ = new SkillLog()).text = Utils.htmlWrap(Utils.formatString(Asset.getInstanceByName("USE_SKILL_LOG").value,{"name":decorateName(_loc4_.name)}),loggingBox.getStyle("FontFamily"),loggingBox.getStyle("FontColor"),loggingBox.getStyle("FontSize"));
         _loc7_.skill = _loc6_;
         if(_loc2_.chances > -1)
         {
            _loc7_.chancesText = Utils.htmlWrap("(" + int(_loc2_.chances * 100).toString() + "%)",loggingBox.getStyle("FontFamily"),16775808,loggingBox.getStyle("FontSize"),false,true);
         }
         _loc7_.validateNow(false);
         loggingBox.print(_loc7_);
      }
      else
      {
         _loc8_ = (_loc8_ = Utils.formatString(Asset.getInstanceByName("USE_ATTACK_LOG").value,{"name":decorateName(_loc4_.name)})) + Utils.htmlWrap(" (" + int(_loc2_.chances * 100) + "%)",loggingBox.getStyle("FontFamily"),16775808,loggingBox.getStyle("FontSize"),false,true);
         loggingBox.print(_loc8_);
      }
      if(_loc2_.lucky)
      {
         _loc5_.showLucky();
         loggingBox.print(Utils.formatString(Asset.getInstanceByName("BREED_LUCKY_HALF_COST_LOG").value,{"name":decorateName(_loc4_.name)}));
      }
      _loc4_.pp = _loc2_.creature_pp;
      _loc5_.showAction(_loc6_);
      _loc5_.showSkillIcons(_loc6_);
      switch(_loc6_.soundType)
      {
         case SkillInstance.SOUND_TYPE_ACTION:
            UIGlobals.playSound(SkillHandler.ActionWav);
            break;
         case SkillInstance.SOUND_TYPE_ATTACK:
            UIGlobals.playSound(SkillHandler.AttackWav);
            break;
         case SkillInstance.SOUND_TYPE_DAMAGE:
            UIGlobals.playSound(SkillHandler.DirectWav);
            break;
         case SkillInstance.SOUND_TYPE_ELEMENTAL:
            UIGlobals.playSound(SkillHandler.ElementalWav);
      }
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

class SkillLog extends Box
{
    
   
   public var text:String;
   
   public var chancesText:String;
   
   public var skill:SkillInstance;
   
   public var userLbl:Label;
   
   public var chancesLbl:Label;
   
   public var skillView:MiniSkillView;
   
   private var _layout:Array;
   
   public function SkillLog()
   {
      this._layout = [{
         "CLASS":Label,
         "ID":"userLbl",
         "useHtml":true,
         "filters":UIGlobals.fontOutline
      },{
         "CLASS":Spacer,
         "width":3
      },{
         "CLASS":MiniSkillView,
         "ID":"skillView",
         "size":UIGlobals.relativize(18)
      },{
         "CLASS":Spacer,
         "width":5
      },{
         "CLASS":Label,
         "ID":"chancesLbl",
         "useHtml":true,
         "visible":false,
         "filters":UIGlobals.fontOutline
      }];
      super(Box.HORIZONTAL,Box.ALIGN_LEFT,Box.ALIGN_MIDDLE);
      layoutInvisibleChildren = false;
   }
   
   override protected function createChildren() : void
   {
      super.createChildren();
      UIUtils.performLayout(this,this,this._layout);
      this.userLbl.text = this.text;
      if(this.chancesText)
      {
         this.chancesLbl.visible = true;
         this.chancesLbl.text = this.chancesText;
      }
      this.skillView.skill = this.skill;
   }
}
