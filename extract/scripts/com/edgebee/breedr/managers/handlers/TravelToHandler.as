package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.TravelToEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class TravelToHandler extends Handler
   {
      
      public static var TravelWav:Class = TravelToHandler_TravelWav;
      
      public static var greetings:Object = {};
       
      
      public var data:TravelToEvent;
      
      public var manager:EventProcessor;
      
      public function TravelToHandler(param1:TravelToEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new TravelFadeOut(this));
      }
   }
}

import com.edgebee.atlas.events.AnimationEvent;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.events.TravelToEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.TravelToHandler;

class TravelFadeOut extends HandlerState
{
    
   
   private var _faded:Boolean = false;
   
   public function TravelFadeOut(param1:TravelToHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:TravelToEvent = (machine as TravelToHandler).data;
      if(!_loc2_.instant)
      {
         UIGlobals.playSound(TravelToHandler.TravelWav);
         this._faded = false;
         gameView.fadeOverlay.visible = true;
         gameView.fadeInInstance.addEventListener(AnimationEvent.STOP,this.onAnimationComplete);
         gameView.fadeInInstance.speed = 3;
         gameView.fadeInInstance.gotoEndAndPlayReversed();
         UIGlobals.root.startProgressIndicator();
      }
      else
      {
         this._faded = true;
      }
   }
   
   private function onAnimationComplete(param1:AnimationEvent) : void
   {
      gameView.fadeInInstance.removeEventListener(AnimationEvent.STOP,this.onAnimationComplete);
      this._faded = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._faded)
      {
         return new Result(Result.TRANSITION,new DoTravelTo(machine as TravelToHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Area;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.TravelToEvent;
import com.edgebee.breedr.managers.TutorialManager;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.TravelToHandler;
import flash.events.Event;

class DoTravelTo extends HandlerState
{
    
   
   private var _loaded:Boolean = false;
   
   public function DoTravelTo(param1:TravelToHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:TravelToEvent = (machine as TravelToHandler).data;
      player.area = Area.getInstanceById(_loc2_.destination_id);
      var _loc3_:Area = player.area;
      if(client.tutorialManager.state == TutorialManager.STATE_COMPLETED || client.tutorialManager.state == TutorialManager.STATE_FEED || client.tutorialManager.state == TutorialManager.STATE_GREETING)
      {
         gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      }
      this._loaded = false;
      gameView.backgroundImage.addEventListener(Event.COMPLETE,this.onBgLoaded);
      gameView.backgroundImage.source = UIGlobals.getAssetPath(player.area.getImageForPlayer(player));
      gameView.hideAreaViews();
      if(client.tutorialManager.state == 0)
      {
         gameView.navigationBar.visible = true;
      }
      switch(_loc3_.type)
      {
         case Area.TYPE_RANCH:
            gameView.ranchView.visible = true;
            gameView.inventoryView.visible = true;
            break;
         case Area.TYPE_LABORATORY:
            gameView.labView.visible = true;
            gameView.inventoryView.visible = true;
            break;
         case Area.TYPE_SHOP:
            if(client.tutorialManager.state != TutorialManager.STATE_SHOP)
            {
               gameView.shopView.visible = true;
               gameView.inventoryView.visible = true;
            }
            break;
         case Area.TYPE_ARENA:
            gameView.arenaView.visible = true;
            gameView.inventoryView.visible = true;
            break;
         case Area.TYPE_SAFARI:
            gameView.safariView.visible = true;
            gameView.inventoryView.visible = true;
            gameView.navigationBar.visible = false;
            break;
         case Area.TYPE_TRAVEL:
            gameView.travelView.visible = true;
            break;
         case Area.TYPE_AUCTION:
            gameView.auctionView.visible = true;
            break;
         case Area.TYPE_SYNDICATE:
            gameView.syndicateView.visible = true;
            break;
         case Area.TYPE_QUEST:
            gameView.questView.visible = true;
            gameView.inventoryView.visible = true;
      }
   }
   
   private function onBgLoaded(param1:Event) : void
   {
      gameView.backgroundImage.removeEventListener(Event.COMPLETE,this.onBgLoaded);
      this._loaded = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._loaded)
      {
         return new Result(Result.TRANSITION,new TravelFadeIn(machine as TravelToHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      var _loc2_:TravelToEvent = (machine as TravelToHandler).data;
      if(!_loc2_.is_stealth)
      {
         --client.criticalComms;
      }
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.events.AnimationEvent;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.player.Player;
import com.edgebee.breedr.data.world.Area;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.TravelToEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.TravelToHandler;
import com.edgebee.breedr.ui.world.areas.ranch.RanchView;
import com.edgebee.breedr.ui.world.areas.ranch.StallView;
import flash.events.Event;

class TravelFadeIn extends HandlerState
{
    
   
   private var _faded:Boolean = false;
   
   public function TravelFadeIn(param1:TravelToHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:TravelToEvent = (machine as TravelToHandler).data;
      var _loc3_:Area = player.area;
      if(!_loc2_.instant)
      {
         loggingBox.print(Utils.formatString(Asset.getInstanceByName("TRAVEL_TO_LOG").value,{"destination":_loc3_.name.value}));
         this._faded = false;
         gameView.fadeInInstance.speed = 3;
         gameView.fadeInInstance.addEventListener(AnimationEvent.STOP,this.onAnimationStop);
         gameView.fadeInInstance.gotoStartAndPlay();
      }
      else
      {
         this._faded = true;
      }
      client.sndManager.playMusic(_loc3_.music,0,int.MAX_VALUE);
   }
   
   private function onAnimationStop(param1:AnimationEvent) : void
   {
      gameView.fadeInInstance.removeEventListener(AnimationEvent.STOP,this.onAnimationStop);
      this._faded = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(Boolean(this._faded) && !gameView.fadeInInstance.playing)
      {
         return Result.STOP;
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      var _loc4_:String = null;
      var _loc5_:String = null;
      var _loc6_:StallView = null;
      super.transitionOut(param1);
      if(!gameView.fadeInInstance.playing)
      {
         gameView.fadeOverlay.visible = false;
      }
      var _loc2_:TravelToEvent = (machine as TravelToHandler).data;
      var _loc3_:Area = player.area;
      if(!_loc2_.instant)
      {
         UIGlobals.root.stopProgressIndicator();
      }
      if(!gameView.cutsceneView.visible && !client.tutorialManager.currentTutorial)
      {
         if(_loc3_.type == Area.TYPE_RANCH && !(player.event_flags & Player.EV_LEVEL_UP) && Boolean(player.hasCreatureWithSkillPoints) && player.firstCreatureWithSkillPoints.level > 1)
         {
            ++client.criticalComms;
            player.event_flags |= Player.EV_LEVEL_UP;
            _loc4_ = String(player.firstCreatureWithSkillPoints.name);
            for each(_loc5_ in RanchView.views)
            {
               if(Boolean((_loc6_ = gameView.ranchView[_loc5_]).creature) && _loc6_.creature.name == _loc4_)
               {
                  gameView.ranchView.selectedView = _loc6_;
                  gameView.statusWindow.creature = _loc6_.creature;
                  break;
               }
            }
            gameView.dialogView.dialog = Dialog.getInstanceByName("tut_levelup_dialog");
            gameView.dialogView.globalParams = {"name":_loc4_};
            gameView.dialogView.addEventListener(Event.COMPLETE,this.onLevelUpDialogComplete,false,0,false);
            gameView.dialogView.step();
         }
         else if(_loc3_.type == Area.TYPE_RANCH && !(player.event_flags & Player.EV_MAX_LEVEL_CREATURE) && Boolean(player.hasMaxedLevelCreature))
         {
            ++client.criticalComms;
            player.event_flags |= Player.EV_MAX_LEVEL_CREATURE;
            gameView.dialogView.dialog = Dialog.getInstanceByName("tut_elder_dialog");
            gameView.dialogView.globalParams = {"name":player.maxedLevelCreature.name};
            gameView.dialogView.addEventListener(Event.COMPLETE,this.onElderDialogComplete,false,0,false);
            gameView.dialogView.step();
         }
         else if(_loc3_.type == Area.TYPE_RANCH && !(player.event_flags & Player.EV_OUT_OF_STAMINA) && Boolean(player.hasCreatureWithoutStamina))
         {
            ++client.criticalComms;
            player.event_flags |= Player.EV_OUT_OF_STAMINA;
            gameView.dialogView.dialog = Dialog.getInstanceByName("tut_stamina_dialog");
            gameView.dialogView.globalParams = {"name":player.firstCreatureWithoutStamina.name};
            gameView.dialogView.addEventListener(Event.COMPLETE,this.onStaminaDialogComplete,false,0,false);
            gameView.dialogView.step();
         }
         else if(_loc3_.type == Area.TYPE_RANCH && !(player.event_flags & Player.EV_FIRST_BREED) && Boolean(player.hasSeedsOfEachGender))
         {
            ++client.criticalComms;
            player.event_flags |= Player.EV_FIRST_BREED;
            gameView.dialogView.dialog = Dialog.getInstanceByName("tut_breed_dialog");
            gameView.dialogView.addEventListener(Event.COMPLETE,this.onBreedDialogComplete,false,0,false);
            gameView.dialogView.step();
         }
         else if(_loc3_.type == Area.TYPE_RANCH && !(player.event_flags & Player.EV_EXPANSION_RANCH))
         {
            ++client.criticalComms;
            player.event_flags |= Player.EV_EXPANSION_RANCH;
            gameView.dialogView.dialog = Dialog.getInstanceByName("tut_new_stalls_dialog");
            gameView.dialogView.addEventListener(Event.COMPLETE,this.onRanchExpansionDialogComplete,false,0,false);
            gameView.dialogView.globalParams = {"player":client.player.name};
            gameView.dialogView.step();
         }
         else if(_loc3_.type == Area.TYPE_TRAVEL && !(player.event_flags & Player.EV_TRAVEL_VISIT))
         {
            ++client.criticalComms;
            player.event_flags |= Player.EV_TRAVEL_VISIT;
            gameView.dialogView.dialog = Dialog.getInstanceByName("tut_travel_dialog");
            gameView.dialogView.addEventListener(Event.COMPLETE,this.onTravelDialogComplete,false,0,false);
            gameView.dialogView.step();
         }
         else if(_loc3_.type == Area.TYPE_QUEST && !(player.event_flags & Player.EV_QUEST_VISIT))
         {
            ++client.criticalComms;
            player.event_flags |= Player.EV_QUEST_VISIT;
            gameView.dialogView.dialog = Dialog.getInstanceByName("tut_quest_dialog");
            gameView.dialogView.addEventListener(Event.COMPLETE,this.onQuestDialogComplete,false,0,false);
            gameView.dialogView.step();
         }
         else if(_loc3_.type == Area.TYPE_AUCTION && !(player.event_flags & Player.EV_AUCTION_VISIT))
         {
            ++client.criticalComms;
            player.event_flags |= Player.EV_AUCTION_VISIT;
            gameView.dialogView.dialog = Dialog.getInstanceByName("tut_auction_dialog");
            gameView.dialogView.addEventListener(Event.COMPLETE,this.onAuctionDialogComplete,false,0,false);
            gameView.dialogView.step();
         }
         else if(_loc3_.type == Area.TYPE_AUCTION && !(player.event_flags & Player.EV_EXPANSION_AUCTION))
         {
            ++client.criticalComms;
            player.event_flags |= Player.EV_EXPANSION_AUCTION;
            gameView.dialogView.dialog = Dialog.getInstanceByName("tut_new_auction_dialog");
            gameView.dialogView.addEventListener(Event.COMPLETE,this.onAuctionExpansionDialogComplete,false,0,false);
            gameView.dialogView.step();
         }
         else if(_loc3_.type == Area.TYPE_LABORATORY && !(player.event_flags & Player.EV_LABORATORY_VISIT))
         {
            ++client.criticalComms;
            player.event_flags |= Player.EV_LABORATORY_VISIT;
            gameView.dialogView.dialog = Dialog.getInstanceByName("tut_laboratory");
            gameView.dialogView.addEventListener(Event.COMPLETE,this.onLaboratoryDialogComplete,false,0,false);
            gameView.dialogView.step();
         }
         else if(_loc3_.type == Area.TYPE_LABORATORY && !(player.event_flags & Player.EV_EXPANSION_LAB))
         {
            ++client.criticalComms;
            player.event_flags |= Player.EV_EXPANSION_LAB;
            gameView.dialogView.dialog = Dialog.getInstanceByName("tut_expansion_dialog");
            gameView.dialogView.addEventListener(Event.COMPLETE,this.onLaboratoryExpansionDialogComplete,false,0,false);
            gameView.dialogView.step();
         }
         else if(_loc3_.type == Area.TYPE_SYNDICATE && !(player.event_flags & Player.EV_SYNDICATE_VISIT))
         {
            ++client.criticalComms;
            player.event_flags |= Player.EV_SYNDICATE_VISIT;
            gameView.dialogView.dialog = Dialog.getInstanceByName("tut_syndicate1_dialog");
            gameView.dialogView.addEventListener(Event.COMPLETE,this.onSyndicateDialogComplete,false,0,false);
            gameView.dialogView.step();
         }
         else if(_loc3_.type == Area.TYPE_SYNDICATE && !(player.event_flags & Player.EV_SYNDICATE_VISIT2) && player.syndicate.id > 0)
         {
            ++client.criticalComms;
            player.event_flags |= Player.EV_SYNDICATE_VISIT2;
            gameView.dialogView.dialog = Dialog.getInstanceByName("tut_syndicate2_dialog");
            gameView.dialogView.addEventListener(Event.COMPLETE,this.onSyndicate2DialogComplete,false,0,false);
            gameView.dialogView.step();
         }
         else if(_loc3_.type == Area.TYPE_SYNDICATE && !(player.event_flags & Player.EV_EXPANSION_SYNDICATE))
         {
            ++client.criticalComms;
            player.event_flags |= Player.EV_EXPANSION_SYNDICATE;
            gameView.dialogView.dialog = Dialog.getInstanceByName("tut_ladder_activation_dialog");
            gameView.dialogView.addEventListener(Event.COMPLETE,this.onSyndicateExpansionDialogComplete,false,0,false);
            gameView.dialogView.step();
         }
         else if(player.area.welcome_id > 0 && !TravelToHandler.greetings.hasOwnProperty(_loc3_.type))
         {
            TravelToHandler.greetings[_loc3_.type] = true;
            gameView.dialogView.dialog = player.area.welcome;
            gameView.dialogView.globalParams = {"player":player.nicename};
            gameView.dialogView.step();
         }
      }
   }
   
   private function onLevelUpDialogComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onLevelUpDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      gameView.statusWindow.visible = false;
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_LEVEL_UP;
      client.service.SetPlayerEventFlag(_loc2_);
   }
   
   private function onElderDialogComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onElderDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_MAX_LEVEL_CREATURE;
      client.service.SetPlayerEventFlag(_loc2_);
   }
   
   private function onStaminaDialogComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onStaminaDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_OUT_OF_STAMINA;
      client.service.SetPlayerEventFlag(_loc2_);
   }
   
   private function onBreedDialogComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onBreedDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_FIRST_BREED;
      client.service.SetPlayerEventFlag(_loc2_);
   }
   
   private function onRanchExpansionDialogComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onRanchExpansionDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_EXPANSION_RANCH;
      client.service.SetPlayerEventFlag(_loc2_);
   }
   
   private function onFridgeDialogComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onFridgeDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_FRIDGE_FULL;
      client.service.SetPlayerEventFlag(_loc2_);
   }
   
   private function onTravelDialogComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onTravelDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_TRAVEL_VISIT;
      client.service.SetPlayerEventFlag(_loc2_);
   }
   
   private function onQuestDialogComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onQuestDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_QUEST_VISIT;
      client.service.SetPlayerEventFlag(_loc2_);
   }
   
   private function onAuctionDialogComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onAuctionDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_AUCTION_VISIT;
      client.service.SetPlayerEventFlag(_loc2_);
   }
   
   private function onAuctionExpansionDialogComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onAuctionExpansionDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_EXPANSION_AUCTION;
      client.service.SetPlayerEventFlag(_loc2_);
   }
   
   private function onLaboratoryDialogComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onLaboratoryDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_LABORATORY_VISIT;
      client.service.SetPlayerEventFlag(_loc2_);
   }
   
   private function onLaboratoryExpansionDialogComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onLaboratoryExpansionDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_EXPANSION_LAB;
      client.service.SetPlayerEventFlag(_loc2_);
   }
   
   private function onSyndicateDialogComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onSyndicateDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_SYNDICATE_VISIT;
      client.service.SetPlayerEventFlag(_loc2_);
   }
   
   private function onSyndicate2DialogComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onSyndicate2DialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_SYNDICATE_VISIT2;
      client.service.SetPlayerEventFlag(_loc2_);
   }
   
   private function onSyndicateExpansionDialogComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onSyndicateExpansionDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_EXPANSION_SYNDICATE;
      client.service.SetPlayerEventFlag(_loc2_);
   }
}
