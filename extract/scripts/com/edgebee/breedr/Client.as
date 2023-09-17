package com.edgebee.breedr
{
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.data.messaging.Message;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.SWFLoader;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.gadgets.messaging.AttachmentDisplay;
   import com.edgebee.breedr.data.combat.Replay;
   import com.edgebee.breedr.data.creature.Accessory;
   import com.edgebee.breedr.data.creature.Category;
   import com.edgebee.breedr.data.creature.Creature;
   import com.edgebee.breedr.data.creature.Element;
   import com.edgebee.breedr.data.creature.StaminaLevel;
   import com.edgebee.breedr.data.effect.Effect;
   import com.edgebee.breedr.data.item.Item;
   import com.edgebee.breedr.data.message.Attachment;
   import com.edgebee.breedr.data.player.PersonalAchievement;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.player.TokenPackage;
   import com.edgebee.breedr.data.skill.EffectPiece;
   import com.edgebee.breedr.data.skill.ModifierPiece;
   import com.edgebee.breedr.data.skill.Rule;
   import com.edgebee.breedr.data.skill.Trait;
   import com.edgebee.breedr.data.world.Area;
   import com.edgebee.breedr.data.world.Dialog;
   import com.edgebee.breedr.data.world.FeederLevel;
   import com.edgebee.breedr.data.world.FridgeLevel;
   import com.edgebee.breedr.data.world.Link;
   import com.edgebee.breedr.data.world.NonPlayerCharacter;
   import com.edgebee.breedr.data.world.RanchLevel;
   import com.edgebee.breedr.data.world.SyndicateLevel;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.GlobalActionDispatcher;
   import com.edgebee.breedr.managers.TutorialManager;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.messaging.ChallengeResultsDisplay;
   import com.edgebee.breedr.ui.messaging.CreatureAttachmentDisplay;
   import com.edgebee.breedr.ui.messaging.CreditDisplay;
   import com.edgebee.breedr.ui.messaging.InvitationDisplay;
   import com.edgebee.breedr.ui.messaging.ItemAttachmentDisplay;
   import com.edgebee.breedr.ui.messaging.ReplayDisplay;
   import flash.events.Event;
   
   public class Client extends com.edgebee.atlas.Client
   {
      
      public static const COMBAT_SPEED_INCREMENT:Number = 0.25;
      
      public static const MIN_COMBAT_SPEED:Number = 1;
      
      public static const MAX_COMBAT_SPEED:Number = 5;
       
      
      public var currentReplay:Replay;
      
      public var eventProcessor:EventProcessor;
      
      public var tutorialManager:TutorialManager;
      
      public var hatchedCreatureIds:Array;
      
      private var _player:Player;
      
      public var actionDispatcher:GlobalActionDispatcher;
      
      public function Client()
      {
         this.hatchedCreatureIds = [];
         super("breedr",breedr_flash.StaticDataTxt);
         this.player = new Player();
         Message.ATTACHMENT_TYPES = [Attachment];
         AttachmentDisplay.ATTACHMENT_DISPLAYS = {
            1:ReplayDisplay,
            2:CreditDisplay,
            3:ItemAttachmentDisplay,
            4:InvitationDisplay,
            5:ChallengeResultsDisplay,
            6:CreatureAttachmentDisplay
         };
      }
      
      public function get player() : Player
      {
         return this._player;
      }
      
      public function set player(param1:Player) : void
      {
         var _loc2_:Player = this._player;
         this._player = param1;
         basePlayer = param1;
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"player",_loc2_,this.player));
      }
      
      public function get npcCache() : SWFLoader
      {
         return (UIGlobals.root as breedr_flash).npcCache;
      }
      
      public function get creatureCache() : Object
      {
         return (UIGlobals.root as breedr_flash).creatureCache;
      }
      
      public function get combatSpeedMultiplier() : Number
      {
         if(!userCookie.hasOwnProperty("combatSpeedMultiplier"))
         {
            userCookie.combatSpeedMultiplier = MIN_COMBAT_SPEED;
            saveCookie();
         }
         return userCookie.combatSpeedMultiplier;
      }
      
      public function set combatSpeedMultiplier(param1:Number) : void
      {
         if(param1 < MIN_COMBAT_SPEED)
         {
            param1 = MIN_COMBAT_SPEED;
         }
         if(param1 > MAX_COMBAT_SPEED)
         {
            param1 = MAX_COMBAT_SPEED;
         }
         if(userCookie.combatSpeedMultiplier != param1)
         {
            userCookie.combatSpeedMultiplier = param1;
            saveCookie();
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"combatSpeedMultiplier",!param1,param1));
         }
      }
      
      public function get auctionFilters() : Number
      {
         if(!userCookie.hasOwnProperty("auctionFilters"))
         {
            userCookie.auctionFilters = Number(4294967295);
            saveCookie();
         }
         return userCookie.auctionFilters;
      }
      
      public function set auctionFilters(param1:Number) : void
      {
         if(userCookie.auctionFilters != param1)
         {
            userCookie.auctionFilters = param1;
            saveCookie();
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"auctionFilters",!param1,param1));
         }
      }
      
      override public function initialize() : void
      {
         super.initialize();
         this.actionDispatcher = new GlobalActionDispatcher();
         this.tutorialManager = new TutorialManager(this);
      }
      
      override public function handleGameEvents(param1:Array) : void
      {
         this.actionDispatcher.actions = param1;
      }
      
      override public function reset() : void
      {
         this.player = null;
         this.actionDispatcher.reset();
         if(this.eventProcessor)
         {
            this.eventProcessor.dispose();
         }
         this.eventProcessor = null;
         super.reset();
      }
      
      override protected function onLogin(param1:ServiceEvent) : void
      {
         super.onLogin(param1);
         this.player.update(param1.data.player);
         this.eventProcessor = new EventProcessor(this);
         if(param1.data.hasOwnProperty("news"))
         {
            this.player.news.reset();
            this.player.news.update(param1.data.news);
         }
         if(param1.data.hasOwnProperty("events"))
         {
            this.actionDispatcher.actions = param1.data["events"];
         }
         var _loc2_:ServiceEvent = new ServiceEvent(param1.type,param1.data);
         dispatchEvent(_loc2_);
      }
      
      override protected function onLogout(param1:ServiceEvent) : void
      {
         this.reset();
         super.onLogout(param1);
         var _loc2_:ServiceEvent = new ServiceEvent(param1.type,param1.data);
         dispatchEvent(_loc2_);
      }
      
      override protected function onPiggyBack(param1:ExtendedEvent) : void
      {
         var _loc3_:String = null;
         super.onPiggyBack(param1);
         if(param1.data.hasOwnProperty("user_tokens"))
         {
            user.tokens = param1.data.user_tokens;
         }
         var _loc2_:uint = 2;
         while(_loc2_ < 12)
         {
            _loc3_ = "syndicate_wins_l" + _loc2_.toString();
            if(param1.data.hasOwnProperty(_loc3_))
            {
               this.player.setSyndicateWins(_loc2_,param1.data[_loc3_]);
            }
            _loc2_++;
         }
         if(param1.data.hasOwnProperty("new_messages"))
         {
            this.player.new_messages = param1.data.new_messages;
         }
         if(param1.data.hasOwnProperty("new_news"))
         {
            this.player.new_news = param1.data.new_news;
         }
         if(param1.data.hasOwnProperty("events"))
         {
            this.actionDispatcher.actions = param1.data.events;
         }
      }
      
      public function onSessionExpiredOk(param1:Event) : void
      {
         (UIGlobals.root as breedr_flash).rootView.gameView.logout();
      }
      
      override protected function onException(param1:ExceptionEvent) : void
      {
         var _loc2_:Window = null;
         super.onException(param1);
         if(!param1.handled && param1.exception.cls == "SessionExpired")
         {
            param1.handled = true;
            _loc2_ = AlertWindow.show(Asset.getInstanceByName("SESSION_EXPIRED_EXPLAINED"),Asset.getInstanceByName("SESSION_EXPIRED"),UIGlobals.root,true,{"ALERT_WINDOW_OK":this.onSessionExpiredOk},true,true);
         }
         else if(!param1.handled && param1.exception.cls == "CannotInteract")
         {
            param1.handled = true;
            _loc2_ = AlertWindow.show(Asset.getInstanceByName("CANNOT_INTERACT_EXPLAINED"),Asset.getInstanceByName("CANNOT_INTERACT"),UIGlobals.root,true,{"ALERT_WINDOW_OK":this.onExceptionWindowOk},true,true);
         }
         else if(!param1.handled && param1.exception.cls == "PlayerOutOfTime")
         {
            param1.handled = true;
            _loc2_ = AlertWindow.show(Asset.getInstanceByName("PLAYER_OUT_OF_TIME_EXPLAINED"),Asset.getInstanceByName("PLAYER_OUT_OF_TIME"),UIGlobals.root,true,{"ALERT_WINDOW_OK":this.onOutOfTimeWindowOk},true,true);
         }
      }
      
      override protected function initCookie() : void
      {
         super.initCookie();
      }
      
      override protected function onStaticDumpReceived(param1:ServiceEvent, param2:Boolean = true) : void
      {
         var _loc3_:Object = null;
         super.onStaticDumpReceived(param1,false);
         for each(_loc3_ in param1.data["creatures"])
         {
            new Creature(_loc3_);
         }
         for each(_loc3_ in param1.data["accessories"])
         {
            new Accessory(_loc3_);
         }
         for each(_loc3_ in param1.data["elements"])
         {
            new Element(_loc3_);
         }
         for each(_loc3_ in param1.data["areas"])
         {
            new Area(_loc3_);
         }
         for each(_loc3_ in param1.data["links"])
         {
            new Link(_loc3_);
         }
         for each(_loc3_ in param1.data["ranches"])
         {
            new RanchLevel(_loc3_);
         }
         for each(_loc3_ in param1.data["feeders"])
         {
            new FeederLevel(_loc3_);
         }
         for each(_loc3_ in param1.data["syndicates"])
         {
            new SyndicateLevel(_loc3_);
         }
         for each(_loc3_ in param1.data["fridges"])
         {
            new FridgeLevel(_loc3_);
         }
         for each(_loc3_ in param1.data["items"])
         {
            new Item(_loc3_);
         }
         for each(_loc3_ in param1.data["staminas"])
         {
            new StaminaLevel(_loc3_);
         }
         for each(_loc3_ in param1.data["npcs"])
         {
            new NonPlayerCharacter(_loc3_);
         }
         for each(_loc3_ in param1.data["dialogs"])
         {
            new Dialog(_loc3_);
         }
         for each(_loc3_ in param1.data["modifier_pieces"])
         {
            new ModifierPiece(_loc3_);
         }
         for each(_loc3_ in param1.data["effect_pieces"])
         {
            new EffectPiece(_loc3_);
         }
         for each(_loc3_ in param1.data["traits"])
         {
            new Trait(_loc3_);
         }
         for each(_loc3_ in param1.data["effects"])
         {
            new Effect(_loc3_);
         }
         for each(_loc3_ in param1.data["token_packages"])
         {
            new TokenPackage(_loc3_);
         }
         for each(_loc3_ in param1.data["personal_achievements"])
         {
            new PersonalAchievement(_loc3_);
         }
         for each(_loc3_ in param1.data["rules"])
         {
            new Rule(_loc3_);
         }
         for each(_loc3_ in param1.data["categories"])
         {
            new Category(_loc3_);
         }
         dispatchEvent(new Event(Event.INIT));
      }
      
      override protected function onKongregateLogin(param1:Event) : void
      {
         super.onKongregateLogin(param1);
         (UIGlobals.root as breedr_flash).rootView.gameView.logout();
         AlertWindow.show(Asset.getInstanceByName("KONGREGATE_LOGIN_DURING_PLAY"),Asset.getInstanceByName("KONGREGATE_LOGIN_DURING_PLAY_TITLE"),null,true,null,false,true,false,false,false,true);
      }
      
      private function onOutOfTimeWindowOk(param1:Event) : void
      {
         (param1.currentTarget as AlertWindow).doClose();
         var _loc2_:GameView = (UIGlobals.root as breedr_flash).rootView.gameView;
         if(_loc2_)
         {
            _loc2_.logout();
         }
      }
      
      private function onExceptionWindowOk(param1:Event) : void
      {
         (param1.currentTarget as AlertWindow).doClose();
      }
   }
}
