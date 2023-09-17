package com.edgebee.breedr.managers
{
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.events.AchievementUpdateEvent;
   import com.edgebee.breedr.events.ActivateTeamEvent;
   import com.edgebee.breedr.events.AddFeedEvent;
   import com.edgebee.breedr.events.AddTeamEvent;
   import com.edgebee.breedr.events.BidEvent;
   import com.edgebee.breedr.events.BuyItemEvent;
   import com.edgebee.breedr.events.ChallengeEvent;
   import com.edgebee.breedr.events.ChangeRightsSyndicateEvent;
   import com.edgebee.breedr.events.CreateAuctionEvent;
   import com.edgebee.breedr.events.CreateSyndicateEvent;
   import com.edgebee.breedr.events.CreatureRankingsEvent;
   import com.edgebee.breedr.events.CreatureUpdateEvent;
   import com.edgebee.breedr.events.CreditsUpdateEvent;
   import com.edgebee.breedr.events.DeactivateTeamEvent;
   import com.edgebee.breedr.events.DelegateSyndicateEvent;
   import com.edgebee.breedr.events.EatingEvent;
   import com.edgebee.breedr.events.ElementInjectionEvent;
   import com.edgebee.breedr.events.ExtractSeedEvent;
   import com.edgebee.breedr.events.GiveItemsEvent;
   import com.edgebee.breedr.events.HappinessEvent;
   import com.edgebee.breedr.events.HatchingEvent;
   import com.edgebee.breedr.events.HealthEvent;
   import com.edgebee.breedr.events.InvitePlayerEvent;
   import com.edgebee.breedr.events.ItemRemoveEvent;
   import com.edgebee.breedr.events.ItemUseEvent;
   import com.edgebee.breedr.events.LeaveSyndicateEvent;
   import com.edgebee.breedr.events.LoginEvent;
   import com.edgebee.breedr.events.MoveCreatureToStallEvent;
   import com.edgebee.breedr.events.NewAchievementEvent;
   import com.edgebee.breedr.events.NewCreatureEvent;
   import com.edgebee.breedr.events.NewEggEvent;
   import com.edgebee.breedr.events.PlayerCreaturesDirtyEvent;
   import com.edgebee.breedr.events.PlayerItemsDirtyEvent;
   import com.edgebee.breedr.events.QuestCompleteEvent;
   import com.edgebee.breedr.events.QuestQuitEvent;
   import com.edgebee.breedr.events.RefreshSyndicateEvent;
   import com.edgebee.breedr.events.RemovePlayerEvent;
   import com.edgebee.breedr.events.RemoveTeamEvent;
   import com.edgebee.breedr.events.ReplayStartEvent;
   import com.edgebee.breedr.events.ResetSkillsEvent;
   import com.edgebee.breedr.events.ResumeTraitSelectionEvent;
   import com.edgebee.breedr.events.RetireCreatureEvent;
   import com.edgebee.breedr.events.SafariPreyEvent;
   import com.edgebee.breedr.events.SafariSlotRevealEvent;
   import com.edgebee.breedr.events.SafariStartEvent;
   import com.edgebee.breedr.events.SafariStopEvent;
   import com.edgebee.breedr.events.SellItemEvent;
   import com.edgebee.breedr.events.SexChangeEvent;
   import com.edgebee.breedr.events.SkillUpdateEvent;
   import com.edgebee.breedr.events.StaminaEvent;
   import com.edgebee.breedr.events.TraitsUpdateEvent;
   import com.edgebee.breedr.events.TrashItemEvent;
   import com.edgebee.breedr.events.TravelToEvent;
   import com.edgebee.breedr.events.TutorialEvent;
   import com.edgebee.breedr.events.UpgradeFeederEvent;
   import com.edgebee.breedr.events.UpgradeFridgeEvent;
   import com.edgebee.breedr.events.UpgradeRanchEvent;
   import com.edgebee.breedr.events.UpgradeSyndicateEvent;
   import com.edgebee.breedr.events.combat.AttackEvent;
   import com.edgebee.breedr.events.combat.BlockEvent;
   import com.edgebee.breedr.events.combat.CombatEndEvent;
   import com.edgebee.breedr.events.combat.CombatStartEvent;
   import com.edgebee.breedr.events.combat.ConditionAgeEvent;
   import com.edgebee.breedr.events.combat.ConditionEvent;
   import com.edgebee.breedr.events.combat.CreditEvent;
   import com.edgebee.breedr.events.combat.DamageEvent;
   import com.edgebee.breedr.events.combat.DispelEvent;
   import com.edgebee.breedr.events.combat.DoNothingEvent;
   import com.edgebee.breedr.events.combat.ExperienceEvent;
   import com.edgebee.breedr.events.combat.FailedSkillEvent;
   import com.edgebee.breedr.events.combat.FizzleEvent;
   import com.edgebee.breedr.events.combat.LevelProgressEvent;
   import com.edgebee.breedr.events.combat.LevelUpEvent;
   import com.edgebee.breedr.events.combat.MissEvent;
   import com.edgebee.breedr.events.combat.QuickCombatEndEvent;
   import com.edgebee.breedr.events.combat.RemoveConditionEvent;
   import com.edgebee.breedr.events.combat.ResistedConditionEvent;
   import com.edgebee.breedr.events.combat.RestorationEvent;
   import com.edgebee.breedr.events.combat.RoundEndEvent;
   import com.edgebee.breedr.events.combat.SkillEvent;
   import com.edgebee.breedr.managers.handlers.AchievementUpdateHandler;
   import com.edgebee.breedr.managers.handlers.ActivateTeamHandler;
   import com.edgebee.breedr.managers.handlers.AddFeedHandler;
   import com.edgebee.breedr.managers.handlers.AddTeamHandler;
   import com.edgebee.breedr.managers.handlers.BidHandler;
   import com.edgebee.breedr.managers.handlers.BuyItemHandler;
   import com.edgebee.breedr.managers.handlers.ChallengeHandler;
   import com.edgebee.breedr.managers.handlers.ChangeRightsSyndicateHandler;
   import com.edgebee.breedr.managers.handlers.CreateAuctionHandler;
   import com.edgebee.breedr.managers.handlers.CreateSyndicateHandler;
   import com.edgebee.breedr.managers.handlers.CreatureRankingsHandler;
   import com.edgebee.breedr.managers.handlers.CreatureUpdateHandler;
   import com.edgebee.breedr.managers.handlers.CreditsUpdateHandler;
   import com.edgebee.breedr.managers.handlers.DeactivateTeamHandler;
   import com.edgebee.breedr.managers.handlers.DelegateSyndicateHandler;
   import com.edgebee.breedr.managers.handlers.EatingHandler;
   import com.edgebee.breedr.managers.handlers.ElementInjectionHandler;
   import com.edgebee.breedr.managers.handlers.ExtractSeedHandler;
   import com.edgebee.breedr.managers.handlers.GiveItemsHandler;
   import com.edgebee.breedr.managers.handlers.HappinessHandler;
   import com.edgebee.breedr.managers.handlers.HatchingHandler;
   import com.edgebee.breedr.managers.handlers.HealthHandler;
   import com.edgebee.breedr.managers.handlers.InvitePlayerHandler;
   import com.edgebee.breedr.managers.handlers.ItemRemoveHandler;
   import com.edgebee.breedr.managers.handlers.ItemUseHandler;
   import com.edgebee.breedr.managers.handlers.LeaveSyndicateHandler;
   import com.edgebee.breedr.managers.handlers.LoginHandler;
   import com.edgebee.breedr.managers.handlers.MoveCreatureToStallHandler;
   import com.edgebee.breedr.managers.handlers.NewAchievementHandler;
   import com.edgebee.breedr.managers.handlers.NewCreatureHandler;
   import com.edgebee.breedr.managers.handlers.NewEggHandler;
   import com.edgebee.breedr.managers.handlers.PlayerCreaturesDirtyHandler;
   import com.edgebee.breedr.managers.handlers.PlayerItemsDirtyHandler;
   import com.edgebee.breedr.managers.handlers.QuestCompleteHandler;
   import com.edgebee.breedr.managers.handlers.QuestQuitHandler;
   import com.edgebee.breedr.managers.handlers.RefreshSyndicateHandler;
   import com.edgebee.breedr.managers.handlers.RemovePlayerHandler;
   import com.edgebee.breedr.managers.handlers.RemoveTeamHandler;
   import com.edgebee.breedr.managers.handlers.ReplayStartHandler;
   import com.edgebee.breedr.managers.handlers.ResetSkillsHandler;
   import com.edgebee.breedr.managers.handlers.ResumeTraitSelectionHandler;
   import com.edgebee.breedr.managers.handlers.RetireCreatureHandler;
   import com.edgebee.breedr.managers.handlers.SafariPreyHandler;
   import com.edgebee.breedr.managers.handlers.SafariSlotRevealHandler;
   import com.edgebee.breedr.managers.handlers.SafariStartHandler;
   import com.edgebee.breedr.managers.handlers.SafariStopHandler;
   import com.edgebee.breedr.managers.handlers.SellItemHandler;
   import com.edgebee.breedr.managers.handlers.SexChangeHandler;
   import com.edgebee.breedr.managers.handlers.SkillUpdateHandler;
   import com.edgebee.breedr.managers.handlers.StaminaHandler;
   import com.edgebee.breedr.managers.handlers.TraitsUpdateHandler;
   import com.edgebee.breedr.managers.handlers.TrashItemHandler;
   import com.edgebee.breedr.managers.handlers.TravelToHandler;
   import com.edgebee.breedr.managers.handlers.TutorialHandler;
   import com.edgebee.breedr.managers.handlers.UpgradeFeederHandler;
   import com.edgebee.breedr.managers.handlers.UpgradeFridgeHandler;
   import com.edgebee.breedr.managers.handlers.UpgradeRanchHandler;
   import com.edgebee.breedr.managers.handlers.UpgradeSyndicateHandler;
   import com.edgebee.breedr.managers.handlers.combat.AttackHandler;
   import com.edgebee.breedr.managers.handlers.combat.BlockHandler;
   import com.edgebee.breedr.managers.handlers.combat.CombatEndHandler;
   import com.edgebee.breedr.managers.handlers.combat.CombatStartHandler;
   import com.edgebee.breedr.managers.handlers.combat.ConditionAgeHandler;
   import com.edgebee.breedr.managers.handlers.combat.ConditionHandler;
   import com.edgebee.breedr.managers.handlers.combat.CreditHandler;
   import com.edgebee.breedr.managers.handlers.combat.DamageHandler;
   import com.edgebee.breedr.managers.handlers.combat.DispelHandler;
   import com.edgebee.breedr.managers.handlers.combat.DoNothingHandler;
   import com.edgebee.breedr.managers.handlers.combat.ExperienceHandler;
   import com.edgebee.breedr.managers.handlers.combat.FailedSkillHandler;
   import com.edgebee.breedr.managers.handlers.combat.FizzleHandler;
   import com.edgebee.breedr.managers.handlers.combat.LevelProgressHandler;
   import com.edgebee.breedr.managers.handlers.combat.LevelUpHandler;
   import com.edgebee.breedr.managers.handlers.combat.MissHandler;
   import com.edgebee.breedr.managers.handlers.combat.QuickCombatEndHandler;
   import com.edgebee.breedr.managers.handlers.combat.RemoveConditionHandler;
   import com.edgebee.breedr.managers.handlers.combat.ResistedConditionHandler;
   import com.edgebee.breedr.managers.handlers.combat.RestorationHandler;
   import com.edgebee.breedr.managers.handlers.combat.RoundEndHandler;
   import com.edgebee.breedr.managers.handlers.combat.SkillHandler;
   
   public class EventProcessor extends BaseActionProcessor
   {
       
      
      public function EventProcessor(param1:Client)
      {
         var _loc2_:Object = {
            "login":{
               "data":LoginEvent,
               "machine":LoginHandler
            },
            "travel":{
               "data":TravelToEvent,
               "machine":TravelToHandler
            },
            "feed":{
               "data":AddFeedEvent,
               "machine":AddFeedHandler
            },
            "use_item":{
               "data":ItemUseEvent,
               "machine":ItemUseHandler
            },
            "buy_item":{
               "data":BuyItemEvent,
               "machine":BuyItemHandler
            },
            "sell_item":{
               "data":SellItemEvent,
               "machine":SellItemHandler
            },
            "trash_item":{
               "data":TrashItemEvent,
               "machine":TrashItemHandler
            },
            "extract_seed":{
               "data":ExtractSeedEvent,
               "machine":ExtractSeedHandler
            },
            "upgrade_feed":{
               "data":UpgradeFeederEvent,
               "machine":UpgradeFeederHandler
            },
            "upgrade_fridge":{
               "data":UpgradeFridgeEvent,
               "machine":UpgradeFridgeHandler
            },
            "upgrade_ranch":{
               "data":UpgradeRanchEvent,
               "machine":UpgradeRanchHandler
            },
            "move_to_stall":{
               "data":MoveCreatureToStallEvent,
               "machine":MoveCreatureToStallHandler
            },
            "level_up":{
               "data":LevelUpEvent,
               "machine":LevelUpHandler
            },
            "skill_update":{
               "data":SkillUpdateEvent,
               "machine":SkillUpdateHandler
            },
            "reset_skill":{
               "data":ResetSkillsEvent,
               "machine":ResetSkillsHandler
            },
            "update_traits":{
               "data":TraitsUpdateEvent,
               "machine":TraitsUpdateHandler
            },
            "resume_traits":{
               "data":ResumeTraitSelectionEvent,
               "machine":ResumeTraitSelectionHandler
            },
            "stamina":{
               "data":StaminaEvent,
               "machine":StaminaHandler
            },
            "happiness":{
               "data":HappinessEvent,
               "machine":HappinessHandler
            },
            "health":{
               "data":HealthEvent,
               "machine":HealthHandler
            },
            "update_creature":{
               "data":CreatureUpdateEvent,
               "machine":CreatureUpdateHandler
            },
            "item_remove":{
               "data":ItemRemoveEvent,
               "machine":ItemRemoveHandler
            },
            "element_inject":{
               "data":ElementInjectionEvent,
               "machine":ElementInjectionHandler
            },
            "new_creature":{
               "data":NewCreatureEvent,
               "machine":NewCreatureHandler
            },
            "new_egg":{
               "data":NewEggEvent,
               "machine":NewEggHandler
            },
            "hatching":{
               "data":HatchingEvent,
               "machine":HatchingHandler
            },
            "bid":{
               "data":BidEvent,
               "machine":BidHandler
            },
            "createauction":{
               "data":CreateAuctionEvent,
               "machine":CreateAuctionHandler
            },
            "replay_start":{
               "data":ReplayStartEvent,
               "machine":ReplayStartHandler
            },
            "credits_update":{
               "data":CreditsUpdateEvent,
               "machine":CreditsUpdateHandler
            },
            "sex_change":{
               "data":SexChangeEvent,
               "machine":SexChangeHandler
            },
            "retire_creature":{
               "data":RetireCreatureEvent,
               "machine":RetireCreatureHandler
            },
            "update_creature_rankings":{
               "data":CreatureRankingsEvent,
               "machine":CreatureRankingsHandler
            },
            "player_creatures_dirty":{
               "data":PlayerCreaturesDirtyEvent,
               "machine":PlayerCreaturesDirtyHandler
            },
            "player_items_dirty":{
               "data":PlayerItemsDirtyEvent,
               "machine":PlayerItemsDirtyHandler
            },
            "update_achievements":{
               "data":AchievementUpdateEvent,
               "machine":AchievementUpdateHandler
            },
            "new_achievement":{
               "data":NewAchievementEvent,
               "machine":NewAchievementHandler
            },
            "give_items":{
               "data":GiveItemsEvent,
               "machine":GiveItemsHandler
            },
            "eating":{
               "data":EatingEvent,
               "machine":EatingHandler
            },
            "safari_start":{
               "data":SafariStartEvent,
               "machine":SafariStartHandler
            },
            "safari_stop":{
               "data":SafariStopEvent,
               "machine":SafariStopHandler
            },
            "safari_prey":{
               "data":SafariPreyEvent,
               "machine":SafariPreyHandler
            },
            "safari_reveal":{
               "data":SafariSlotRevealEvent,
               "machine":SafariSlotRevealHandler
            },
            "create_synd":{
               "data":CreateSyndicateEvent,
               "machine":CreateSyndicateHandler
            },
            "upgrade_synd":{
               "data":UpgradeSyndicateEvent,
               "machine":UpgradeSyndicateHandler
            },
            "invite_player":{
               "data":InvitePlayerEvent,
               "machine":InvitePlayerHandler
            },
            "team_add":{
               "data":AddTeamEvent,
               "machine":AddTeamHandler
            },
            "team_rem":{
               "data":RemoveTeamEvent,
               "machine":RemoveTeamHandler
            },
            "team_act":{
               "data":ActivateTeamEvent,
               "machine":ActivateTeamHandler
            },
            "team_deact":{
               "data":DeactivateTeamEvent,
               "machine":DeactivateTeamHandler
            },
            "challenge":{
               "data":ChallengeEvent,
               "machine":ChallengeHandler
            },
            "refresh_synd":{
               "data":RefreshSyndicateEvent,
               "machine":RefreshSyndicateHandler
            },
            "leave_synd":{
               "data":LeaveSyndicateEvent,
               "machine":LeaveSyndicateHandler
            },
            "delegate_synd":{
               "data":DelegateSyndicateEvent,
               "machine":DelegateSyndicateHandler
            },
            "kick_synd":{
               "data":RemovePlayerEvent,
               "machine":RemovePlayerHandler
            },
            "changeRightsSyndicateHandler":{
               "data":ChangeRightsSyndicateEvent,
               "machine":ChangeRightsSyndicateHandler
            },
            "quest_complete":{
               "data":QuestCompleteEvent,
               "machine":QuestCompleteHandler
            },
            "quest_quit":{
               "data":QuestQuitEvent,
               "machine":QuestQuitHandler
            },
            "tutorial_event":{
               "data":TutorialEvent,
               "machine":TutorialHandler
            },
            "combat_start":{
               "data":CombatStartEvent,
               "machine":CombatStartHandler
            },
            "combat_end":{
               "data":CombatEndEvent,
               "machine":CombatEndHandler
            },
            "combat_round_end":{
               "data":RoundEndEvent,
               "machine":RoundEndHandler
            },
            "combat_nothing":{
               "data":DoNothingEvent,
               "machine":DoNothingHandler
            },
            "combat_attack":{
               "data":AttackEvent,
               "machine":AttackHandler
            },
            "combat_damage":{
               "data":DamageEvent,
               "machine":DamageHandler
            },
            "combat_block":{
               "data":BlockEvent,
               "machine":BlockHandler
            },
            "combat_fizzle":{
               "data":FizzleEvent,
               "machine":FizzleHandler
            },
            "combat_miss":{
               "data":MissEvent,
               "machine":MissHandler
            },
            "combat_restoration":{
               "data":RestorationEvent,
               "machine":RestorationHandler
            },
            "combat_skill":{
               "data":SkillEvent,
               "machine":SkillHandler
            },
            "combat_failed_skill":{
               "data":FailedSkillEvent,
               "machine":FailedSkillHandler
            },
            "combat_dispel":{
               "data":DispelEvent,
               "machine":DispelHandler
            },
            "combat_condition":{
               "data":ConditionEvent,
               "machine":ConditionHandler
            },
            "combat_condition_age":{
               "data":ConditionAgeEvent,
               "machine":ConditionAgeHandler
            },
            "combat_remvove_condition":{
               "data":RemoveConditionEvent,
               "machine":RemoveConditionHandler
            },
            "combat_resist_condition":{
               "data":ResistedConditionEvent,
               "machine":ResistedConditionHandler
            },
            "combat_credit":{
               "data":CreditEvent,
               "machine":CreditHandler
            },
            "combat_xp":{
               "data":ExperienceEvent,
               "machine":ExperienceHandler
            },
            "combat_level_progess":{
               "data":LevelProgressEvent,
               "machine":LevelProgressHandler
            },
            "combat_quick_end":{
               "data":QuickCombatEndEvent,
               "machine":QuickCombatEndHandler
            }
         };
         super(param1,_loc2_);
      }
      
      override public function dispose() : void
      {
      }
      
      override public function get client() : *
      {
         return _client as Client;
      }
   }
}
