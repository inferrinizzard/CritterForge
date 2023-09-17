package com.edgebee.breedr.ui.creature
{
   import com.adobe.utils.StringUtil;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.containers.RadioButtonGroup;
   import com.edgebee.atlas.ui.containers.TileList;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.GradientLabel;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.ProgressBar;
   import com.edgebee.atlas.ui.controls.RadioButton;
   import com.edgebee.atlas.ui.controls.ScrollBar;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.gadgets.InputWindow;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.player.TokenPackage;
   import com.edgebee.breedr.data.skill.TraitInstance;
   import com.edgebee.breedr.data.world.FeederLevel;
   import com.edgebee.breedr.data.world.Stall;
   import com.edgebee.breedr.ui.ControlBar;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.item.ItemView;
   import com.edgebee.breedr.ui.skill.MiniSkillView;
   import com.edgebee.breedr.ui.skill.SkillEditorWindow;
   import com.edgebee.breedr.ui.skill.TraitListView;
   import com.edgebee.breedr.ui.skins.BreedrButtonSkin;
   import com.edgebee.breedr.ui.world.UpgradeWindow;
   import com.edgebee.breedr.ui.world.areas.ranch.FeederView;
   import com.edgebee.breedr.ui.world.areas.ranch.RanchView;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormatAlign;
   
   public class StatusWindow extends Window
   {
      
      private static const ICON_SIZE:Number = UIGlobals.relativize(20);
      
      public static const STATUS:String = "STATUS";
      
      public static const TRAITS:String = "TRAITS";
      
      public static const SKILLS:String = "SKILLS";
      
      private static const skillBoxes:Array = ["skillBox01","skillBox02","skillBox03","skillBox04","skillBox05"];
       
      
      private var _stall:WeakReference;
      
      private var _creature:WeakReference;
      
      private var _locked:Boolean;
      
      public var panelCvs:Canvas;
      
      public var infoBox:Box;
      
      public var nameLbl:Label;
      
      public var familyLbl:Label;
      
      public var ageLbl:Label;
      
      public var levelLbl:Label;
      
      public var maxHpLbl:Label;
      
      public var maxPpLbl:Label;
      
      public var levelProgress:ProgressBar;
      
      public var rankLbl:Label;
      
      public var seedCountLbl:Label;
      
      public var staminaLevelView:com.edgebee.breedr.ui.creature.LevelView;
      
      public var happinessLevelView:com.edgebee.breedr.ui.creature.LevelView;
      
      public var healthLevelView:com.edgebee.breedr.ui.creature.LevelView;
      
      public var genderLbl:Label;
      
      public var genderIcon:BitmapComponent;
      
      public var feederInfo:Box;
      
      public var feederView:FeederView;
      
      public var capacityLbl:Label;
      
      public var feederLevelLbl:Label;
      
      public var feederUpgradeBtn:Button;
      
      public var retireBtn:Button;
      
      public var renameBtn:Button;
      
      public var upgradeSkillsBtn:Button;
      
      public var skillPointsLbl:GradientLabel;
      
      public var resetBtn:Button;
      
      public var freeRespecBox:Box;
      
      public var traitsBox:Box;
      
      public var skillsBox:Box;
      
      public var familyBox:Box;
      
      public var tabGroup:RadioButtonGroup;
      
      public var toStatsBtn:RadioButton;
      
      public var toTraitsBtn:RadioButton;
      
      public var toSkillsBtn:RadioButton;
      
      public var traitsList:TileList;
      
      public var saveTraitsBtn:Button;
      
      public var skillBox01:com.edgebee.breedr.ui.creature.SkillStatusView;
      
      public var skillBox02:com.edgebee.breedr.ui.creature.SkillStatusView;
      
      public var skillBox03:com.edgebee.breedr.ui.creature.SkillStatusView;
      
      public var skillBox04:com.edgebee.breedr.ui.creature.SkillStatusView;
      
      public var skillBox05:com.edgebee.breedr.ui.creature.SkillStatusView;
      
      private var _tempRename:String = null;
      
      private var _contentLayout:Array;
      
      private var _statusBarLayout:Array;
      
      public function StatusWindow()
      {
         this._stall = new WeakReference(null,Stall);
         this._creature = new WeakReference(null,CreatureInstance);
         this._contentLayout = [{
            "CLASS":Canvas,
            "ID":"panelCvs",
            "percentWidth":1,
            "percentHeight":1,
            "CHILDREN":[{
               "CLASS":Box,
               "ID":"infoBox",
               "direction":Box.VERTICAL,
               "percentWidth":1,
               "percentHeight":1,
               "filters":UIGlobals.fontOutline,
               "layoutInvisibleChildren":false,
               "STYLES":{
                  "Gap":0,
                  "Padding":2
               },
               "spreadProportionality":false,
               "CHILDREN":[{
                  "CLASS":Box,
                  "direction":Box.HORIZONTAL,
                  "percentWidth":1,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "CHILDREN":[{
                     "CLASS":Label,
                     "percentWidth":0.4,
                     "text":Asset.getInstanceByName("FAMILY"),
                     "STYLES":{"FontColor":16777215}
                  },{
                     "CLASS":Label,
                     "percentWidth":0.6,
                     "ID":"familyLbl",
                     "STYLES":{
                        "FontColor":16777215,
                        "FontWeight":"bold"
                     }
                  }]
               },{
                  "CLASS":Box,
                  "direction":Box.HORIZONTAL,
                  "percentWidth":1,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "STYLES":{"BackgroundAlpha":0.05},
                  "spreadProportionality":false,
                  "CHILDREN":[{
                     "CLASS":Label,
                     "percentWidth":0.4,
                     "text":Asset.getInstanceByName("GENDER"),
                     "STYLES":{"FontColor":16777215}
                  },{
                     "CLASS":Box,
                     "percentWidth":0.6,
                     "percentHeight":1,
                     "verticalAlign":Box.ALIGN_MIDDLE,
                     "layoutInvisibleChildren":false,
                     "CHILDREN":[{
                        "CLASS":BitmapComponent,
                        "ID":"genderIcon",
                        "width":ICON_SIZE,
                        "height":ICON_SIZE
                     },{
                        "CLASS":Spacer,
                        "width":UIGlobals.relativize(2)
                     },{
                        "CLASS":Label,
                        "ID":"genderLbl",
                        "STYLES":{
                           "FontColor":16777215,
                           "FontWeight":"bold"
                        }
                     }]
                  }]
               },{
                  "CLASS":Box,
                  "direction":Box.HORIZONTAL,
                  "percentWidth":1,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "CHILDREN":[{
                     "CLASS":Label,
                     "percentWidth":0.4,
                     "text":Asset.getInstanceByName("LEVEL"),
                     "STYLES":{"FontColor":16777215}
                  },{
                     "CLASS":Label,
                     "percentWidth":0.6,
                     "ID":"levelLbl",
                     "STYLES":{
                        "FontColor":16777215,
                        "FontWeight":"bold"
                     }
                  }]
               },{
                  "CLASS":Box,
                  "direction":Box.HORIZONTAL,
                  "percentWidth":1,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "STYLES":{"BackgroundAlpha":0.05},
                  "CHILDREN":[{
                     "CLASS":Label,
                     "percentWidth":0.4,
                     "text":Asset.getInstanceByName("NEXT"),
                     "STYLES":{"FontColor":16777215}
                  },{
                     "CLASS":ProgressBar,
                     "percentWidth":0.6,
                     "ID":"levelProgress",
                     "height":ICON_SIZE - 4,
                     "STYLES":{
                        "BarOffset":3,
                        "ForegroundColor":UIGlobals.getStyle("XPColor")
                     }
                  }]
               },{
                  "CLASS":Box,
                  "direction":Box.HORIZONTAL,
                  "percentWidth":1,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "CHILDREN":[{
                     "CLASS":Label,
                     "percentWidth":0.4,
                     "text":Asset.getInstanceByName("points.max_hp"),
                     "STYLES":{"FontColor":16777215}
                  },{
                     "CLASS":Label,
                     "percentWidth":0.6,
                     "ID":"maxHpLbl",
                     "STYLES":{
                        "FontColor":16777215,
                        "FontWeight":"bold"
                     }
                  }]
               },{
                  "CLASS":Box,
                  "direction":Box.HORIZONTAL,
                  "percentWidth":1,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "STYLES":{"BackgroundAlpha":0.05},
                  "CHILDREN":[{
                     "CLASS":Label,
                     "percentWidth":0.4,
                     "text":Asset.getInstanceByName("points.max_pp"),
                     "STYLES":{"FontColor":16777215}
                  },{
                     "CLASS":Label,
                     "percentWidth":0.6,
                     "ID":"maxPpLbl",
                     "STYLES":{
                        "FontColor":16777215,
                        "FontWeight":"bold"
                     }
                  }]
               },{
                  "CLASS":Box,
                  "direction":Box.HORIZONTAL,
                  "percentWidth":1,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "CHILDREN":[{
                     "CLASS":Label,
                     "percentWidth":0.4,
                     "text":Asset.getInstanceByName("STAMINA"),
                     "STYLES":{"FontColor":16777215}
                  },{
                     "CLASS":com.edgebee.breedr.ui.creature.LevelView,
                     "percentWidth":0.6,
                     "ID":"staminaLevelView",
                     "height":ICON_SIZE,
                     "style":com.edgebee.breedr.ui.creature.LevelView.PROGRESS,
                     "property":"stamina",
                     "icon":RanchView.StaminaIconPng
                  }]
               },{
                  "CLASS":Box,
                  "direction":Box.HORIZONTAL,
                  "percentWidth":1,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "STYLES":{"BackgroundAlpha":0.05},
                  "CHILDREN":[{
                     "CLASS":Label,
                     "percentWidth":0.4,
                     "text":Asset.getInstanceByName("HAPPINESS"),
                     "STYLES":{"FontColor":16777215}
                  },{
                     "CLASS":com.edgebee.breedr.ui.creature.LevelView,
                     "percentWidth":0.6,
                     "ID":"happinessLevelView",
                     "height":ICON_SIZE,
                     "style":com.edgebee.breedr.ui.creature.LevelView.PROGRESS,
                     "property":"happiness",
                     "icon":RanchView.HappinessIconPng
                  }]
               },{
                  "CLASS":Box,
                  "direction":Box.HORIZONTAL,
                  "percentWidth":1,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "CHILDREN":[{
                     "CLASS":Label,
                     "percentWidth":0.4,
                     "text":Asset.getInstanceByName("HEALTH"),
                     "STYLES":{"FontColor":16777215}
                  },{
                     "CLASS":com.edgebee.breedr.ui.creature.LevelView,
                     "percentWidth":0.6,
                     "ID":"healthLevelView",
                     "height":ICON_SIZE,
                     "style":com.edgebee.breedr.ui.creature.LevelView.PROGRESS,
                     "property":"health",
                     "icon":RanchView.HealthIconPng
                  }]
               },{
                  "CLASS":Box,
                  "direction":Box.HORIZONTAL,
                  "percentWidth":1,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "STYLES":{"BackgroundAlpha":0.05},
                  "CHILDREN":[{
                     "CLASS":Label,
                     "percentWidth":0.4,
                     "text":Asset.getInstanceByName("RANK"),
                     "STYLES":{"FontColor":16777215}
                  },{
                     "CLASS":Label,
                     "percentWidth":0.6,
                     "ID":"rankLbl",
                     "STYLES":{
                        "FontColor":16777215,
                        "FontWeight":"bold"
                     }
                  }]
               },{
                  "CLASS":Box,
                  "direction":Box.HORIZONTAL,
                  "percentWidth":1,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "CHILDREN":[{
                     "CLASS":Label,
                     "percentWidth":0.4,
                     "text":Asset.getInstanceByName("SEED_COUNT"),
                     "STYLES":{"FontColor":16777215}
                  },{
                     "CLASS":Label,
                     "percentWidth":0.6,
                     "ID":"seedCountLbl",
                     "STYLES":{
                        "FontColor":16777215,
                        "FontWeight":"bold"
                     }
                  }]
               },{
                  "CLASS":Spacer,
                  "height":UIGlobals.relativize(5)
               },{
                  "CLASS":Box,
                  "ID":"feederInfo",
                  "direction":Box.HORIZONTAL,
                  "percentWidth":1,
                  "layoutInvisibleChildren":false,
                  "STYLES":{"BackgroundAlpha":0.05},
                  "CHILDREN":[{
                     "CLASS":Box,
                     "direction":Box.VERTICAL,
                     "percentWidth":0.4,
                     "CHILDREN":[{
                        "CLASS":Label,
                        "text":Asset.getInstanceByName("FEEDER"),
                        "STYLES":{"FontColor":16777215}
                     },{
                        "CLASS":Button,
                        "ID":"feederUpgradeBtn",
                        "label":Asset.getInstanceByName("UPGRADE"),
                        "STYLES":{
                           "FontSize":UIGlobals.relativizeFont(11),
                           "Padding":UIGlobals.relativize(2)
                        },
                        "EVENTS":[{
                           "TYPE":MouseEvent.CLICK,
                           "LISTENER":this.onFeederUpgradeClick
                        }]
                     }]
                  },{
                     "CLASS":Box,
                     "direction":Box.VERTICAL,
                     "percentWidth":0.6,
                     "CHILDREN":[{
                        "CLASS":Box,
                        "verticalAlign":Box.ALIGN_MIDDLE,
                        "CHILDREN":[{
                           "CLASS":Label,
                           "percentWidth":0.5,
                           "text":Asset.getInstanceByName("LEVEL"),
                           "STYLES":{"FontColor":16777215}
                        },{
                           "CLASS":Label,
                           "ID":"feederLevelLbl",
                           "alignment":TextFormatAlign.CENTER,
                           "STYLES":{"FontColor":16776960}
                        }]
                     },{
                        "CLASS":Box,
                        "verticalAlign":Box.ALIGN_MIDDLE,
                        "CHILDREN":[{
                           "CLASS":Label,
                           "percentWidth":0.5,
                           "text":Asset.getInstanceByName("CAPACITY"),
                           "STYLES":{"FontColor":16777215}
                        },{
                           "CLASS":Label,
                           "ID":"capacityLbl",
                           "alignment":TextFormatAlign.CENTER,
                           "STYLES":{"FontColor":16776960}
                        }]
                     }]
                  },{
                     "CLASS":FeederView,
                     "ID":"feederView",
                     "width":ICON_SIZE * 3,
                     "height":ICON_SIZE * 3
                  }]
               },{
                  "CLASS":Spacer,
                  "height":UIGlobals.relativizeY(5)
               },{
                  "CLASS":Box,
                  "ID":"freeRespecBox",
                  "percentWidth":1,
                  "height":UIGlobals.relativizeY(20),
                  "visible":false,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "horizontalAlign":Box.ALIGN_CENTER,
                  "STYLES":{
                     "BackgroundColor":16777164,
                     "BackgroundAlpha":0.1,
                     "CornerRadius":10,
                     "Padding":2,
                     "BorderThickness":1,
                     "BorderColor":16777164,
                     "BorderAlpha":1
                  },
                  "CHILDREN":[{
                     "CLASS":BitmapComponent,
                     "width":12,
                     "height":12,
                     "source":AlertWindow.WarningIconPng
                  },{
                     "CLASS":Spacer,
                     "width":5
                  },{
                     "CLASS":GradientLabel,
                     "text":Asset.getInstanceByName("FREE_RESPEC"),
                     "colors":[16777215,11184810],
                     "STYLES":{
                        "FontSize":UIGlobals.relativizeFont(11),
                        "FontColor":0
                     }
                  }]
               },{
                  "CLASS":Box,
                  "direction":Box.HORIZONTAL,
                  "percentWidth":1,
                  "percentHeight":1,
                  "horizontalAlign":Box.ALIGN_RIGHT,
                  "verticalAlign":Box.ALIGN_BOTTOM,
                  "STYLES":{
                     "Padding":UIGlobals.relativize(3),
                     "Gap":UIGlobals.relativize(5)
                  },
                  "CHILDREN":[{
                     "CLASS":Button,
                     "ID":"renameBtn",
                     "label":Asset.getInstanceByName("RENAME"),
                     "STYLES":{
                        "FontSize":UIGlobals.relativizeFont(13),
                        "Padding":UIGlobals.relativize(4)
                     },
                     "EVENTS":[{
                        "TYPE":MouseEvent.CLICK,
                        "LISTENER":this.onRenameClick
                     }]
                  },{
                     "CLASS":Button,
                     "ID":"resetBtn",
                     "label":Asset.getInstanceByName("RESET"),
                     "STYLES":{
                        "FontSize":UIGlobals.relativizeFont(13),
                        "Padding":UIGlobals.relativize(4)
                     },
                     "EVENTS":[{
                        "TYPE":MouseEvent.CLICK,
                        "LISTENER":this.onResetClick
                     }]
                  },{
                     "CLASS":Button,
                     "ID":"retireBtn",
                     "label":Asset.getInstanceByName("RETIRE"),
                     "STYLES":{
                        "FontSize":UIGlobals.relativizeFont(13),
                        "Padding":UIGlobals.relativize(4)
                     },
                     "EVENTS":[{
                        "TYPE":MouseEvent.CLICK,
                        "LISTENER":this.onRetireClick
                     }]
                  }]
               }]
            },{
               "CLASS":Box,
               "ID":"traitsBox",
               "direction":Box.VERTICAL,
               "horizontalAlign":Box.ALIGN_CENTER,
               "percentWidth":1,
               "percentHeight":1,
               "visible":false,
               "CHILDREN":[{
                  "CLASS":Box,
                  "direction":Box.HORIZONTAL,
                  "percentWidth":1,
                  "percentHeight":1,
                  "CHILDREN":[{
                     "CLASS":TileList,
                     "ID":"traitsList",
                     "direction":TileList.VERTICAL,
                     "selectable":false,
                     "highlightable":false,
                     "widthInColumns":5,
                     "heightInRows":5,
                     "renderer":TraitListView
                  },{
                     "CLASS":ScrollBar,
                     "name":"StatusWindow:TraitsScrollbar",
                     "percentHeight":1,
                     "scrollable":"{traitsList}"
                  }]
               },{
                  "CLASS":Button,
                  "ID":"saveTraitsBtn",
                  "label":Asset.getInstanceByName("SAVE"),
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":this.onSaveTraitsClick
                  }]
               }]
            },{
               "CLASS":Box,
               "ID":"skillsBox",
               "direction":Box.VERTICAL,
               "percentWidth":1,
               "percentHeight":1,
               "visible":false,
               "STYLES":{
                  "Gap":5,
                  "Padding":2
               },
               "spreadProportionality":false,
               "CHILDREN":[{
                  "CLASS":com.edgebee.breedr.ui.creature.SkillStatusView,
                  "ID":"skillBox01",
                  "index":1,
                  "percentWidth":1,
                  "percentHeight":0.2
               },{
                  "CLASS":com.edgebee.breedr.ui.creature.SkillStatusView,
                  "ID":"skillBox02",
                  "index":2,
                  "percentWidth":1,
                  "percentHeight":0.2
               },{
                  "CLASS":com.edgebee.breedr.ui.creature.SkillStatusView,
                  "ID":"skillBox03",
                  "index":3,
                  "percentWidth":1,
                  "percentHeight":0.2
               },{
                  "CLASS":com.edgebee.breedr.ui.creature.SkillStatusView,
                  "ID":"skillBox04",
                  "index":4,
                  "percentWidth":1,
                  "percentHeight":0.2
               },{
                  "CLASS":com.edgebee.breedr.ui.creature.SkillStatusView,
                  "ID":"skillBox05",
                  "index":5,
                  "percentWidth":1,
                  "percentHeight":0.2
               },{
                  "CLASS":Box,
                  "direction":Box.HORIZONTAL,
                  "percentWidth":1,
                  "verticalAlign":Box.ALIGN_BOTTOM,
                  "STYLES":{"Padding":UIGlobals.relativize(3)},
                  "CHILDREN":[{
                     "CLASS":Spacer,
                     "percentWidth":1
                  },{
                     "CLASS":Button,
                     "ID":"upgradeSkillsBtn",
                     "label":Asset.getInstanceByName("MODIFY_SKILLS"),
                     "EVENTS":[{
                        "TYPE":MouseEvent.CLICK,
                        "LISTENER":this.onEditSkills
                     }]
                  }]
               }]
            },{
               "CLASS":Box,
               "ID":"familyBox",
               "direction":Box.HORIZONTAL,
               "percentWidth":1,
               "percentHeight":1,
               "visible":false,
               "filters":UIGlobals.fontOutline,
               "STYLES":{
                  "Gap":UIGlobals.relativize(6),
                  "Padding":2
               },
               "CHILDREN":[]
            }]
         }];
         this._statusBarLayout = [{
            "CLASS":GradientLabel,
            "ID":"skillPointsLbl",
            "filters":UIGlobals.fontOutline,
            "colors":[16711680,16776960],
            "STYLES":{
               "FontWeight":"bold",
               "FontSize":UIGlobals.relativizeFont(20)
            }
         },{
            "CLASS":Box,
            "horizontalAlign":Box.ALIGN_CENTER,
            "STYLES":{"Gap":UIGlobals.relativize(6)},
            "CHILDREN":[{
               "CLASS":RadioButton,
               "ID":"toStatsBtn",
               "label":Asset.getInstanceByName("STATUS"),
               "userData":STATUS,
               "STYLES":{
                  "FontColor":0,
                  "Skin":BreedrButtonSkin,
                  "FontSize":UIGlobals.relativizeFont(12),
                  "Padding":UIGlobals.relativize(4)
               }
            },{
               "CLASS":RadioButton,
               "ID":"toTraitsBtn",
               "label":Asset.getInstanceByName("TRAITS"),
               "userData":TRAITS,
               "STYLES":{
                  "FontColor":0,
                  "Skin":BreedrButtonSkin,
                  "FontSize":UIGlobals.relativizeFont(12),
                  "Padding":UIGlobals.relativize(4)
               }
            },{
               "CLASS":RadioButton,
               "ID":"toSkillsBtn",
               "label":Asset.getInstanceByName("SKILLS"),
               "userData":SKILLS,
               "STYLES":{
                  "FontColor":0,
                  "Skin":BreedrButtonSkin,
                  "FontSize":UIGlobals.relativizeFont(12),
                  "Padding":UIGlobals.relativize(4)
               }
            }]
         }];
         super();
         width = UIGlobals.relativizeX(550);
         height = UIGlobals.relativizeY(600);
         rememberPositionId = "StatusWindow";
         visible = false;
         this.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         client.user.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onUserChange);
         client.service.addEventListener("UpgradeFeeder",this.onUpgradeFeeder);
         client.service.addEventListener("RetireCreature",this.onRetireCreature);
         client.service.addEventListener("LevelUpTraits",this.onLevelUpTraits);
         client.service.addEventListener("RenameCreature",this.onRenameCreature);
         client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
      }
      
      public function get gameClient() : Client
      {
         return client as Client;
      }
      
      public function get player() : Player
      {
         return (client as Client).player;
      }
      
      public function get gameView() : GameView
      {
         return (UIGlobals.root as breedr_flash).rootView.gameView;
      }
      
      public function get stall() : Stall
      {
         return this._stall.get() as Stall;
      }
      
      public function set stall(param1:Stall) : void
      {
         if(this.stall != param1)
         {
            if(this.stall)
            {
               this.stall.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onStallChange);
               this.stall.feeder.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onFeederChange);
               this.creature = null;
            }
            this._stall.reset(param1);
            if(this.stall)
            {
               this.stall.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onStallChange);
               this.stall.feeder.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onFeederChange);
               this.creature = this.stall.creature;
            }
            else
            {
               this.update();
            }
         }
      }
      
      public function get creature() : CreatureInstance
      {
         return this._creature.get() as CreatureInstance;
      }
      
      public function set creature(param1:CreatureInstance) : void
      {
         if(param1 != this.creature)
         {
            if(this.creature)
            {
               this.undoTraitsChanges();
               this.creature.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
            }
            this._creature.reset(param1);
            if(this.creature)
            {
               this.creature.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
            }
            this.update();
         }
      }
      
      public function get locked() : Boolean
      {
         return this._locked;
      }
      
      public function set locked(param1:Boolean) : void
      {
         if(this.locked != param1)
         {
            this._locked = param1;
            this.update();
         }
      }
      
      override public function doClose() : void
      {
         visible = false;
         this.undoTraitsChanges();
         this.stall = null;
         this.creature = null;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:BitmapComponent = null;
         super.createChildren();
         content.horizontalAlign = Box.ALIGN_LEFT;
         content.layoutInvisibleChildren = false;
         UIUtils.performLayout(this,content,this._contentLayout);
         statusBar.direction = Box.VERTICAL;
         statusBar.layoutInvisibleChildren = false;
         statusBar.horizontalAlign = Box.ALIGN_CENTER;
         statusBar.verticalAlign = Box.ALIGN_MIDDLE;
         UIUtils.performLayout(this,statusBar,this._statusBarLayout);
         this.tabGroup = new RadioButtonGroup();
         this.tabGroup.addButton(this.toStatsBtn);
         this.tabGroup.addButton(this.toTraitsBtn);
         this.tabGroup.addButton(this.toSkillsBtn);
         this.tabGroup.selected = this.toStatsBtn;
         this.tabGroup.addEventListener(Event.CHANGE,this.onPanelChange);
         _loc1_ = new BitmapComponent();
         _loc1_.width = UIGlobals.relativize(16);
         _loc1_.height = UIGlobals.relativize(16);
         _loc1_.source = RanchView.UpgradeIconPng;
         this.feederUpgradeBtn.icon = _loc1_;
         _loc1_ = new BitmapComponent();
         _loc1_.source = ControlBar.TokenIcon32Png;
         _loc1_.width = UIGlobals.relativize(16);
         _loc1_.height = UIGlobals.relativize(16);
         this.renameBtn.icon = _loc1_;
         _loc1_ = new BitmapComponent();
         _loc1_.source = ControlBar.TokenIcon32Png;
         _loc1_.width = UIGlobals.relativize(16);
         _loc1_.height = UIGlobals.relativize(16);
         this.resetBtn.icon = _loc1_;
         this.traitsList.addEventListener(TraitListView.TRAIT_CLICKED,this.onTraitClicked);
      }
      
      private function onStallChange(param1:PropertyChangeEvent) : void
      {
         this.update(param1.property);
      }
      
      private function onFeederChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function onCreatureChange(param1:PropertyChangeEvent) : void
      {
         if(!this.creature.copying)
         {
            this.update(param1.property);
         }
      }
      
      private function undoTraitsChanges() : void
      {
         var _loc1_:TraitInstance = null;
         if(this.traitsBox.visible)
         {
            for each(_loc1_ in this.creature.traits)
            {
               this.creature.skill_points_delta += _loc1_.spentSkillPoints;
               _loc1_.level_delta = 0;
            }
            this.updateSaveTraitsButton();
         }
      }
      
      private function onPanelChange(param1:ExtendedEvent) : void
      {
         this.undoTraitsChanges();
         switch(param1.data)
         {
            case STATUS:
               this.skillsBox.visible = false;
               this.traitsBox.visible = false;
               this.infoBox.visible = true;
               break;
            case TRAITS:
               this.infoBox.visible = false;
               this.traitsBox.visible = true;
               this.skillsBox.visible = false;
               break;
            case SKILLS:
               this.infoBox.visible = false;
               this.skillsBox.visible = true;
               this.traitsBox.visible = false;
         }
      }
      
      private function updateUpgradeButton() : void
      {
         var _loc1_:FeederLevel = null;
         var _loc2_:Asset = null;
         if(Boolean(this.feederUpgradeBtn) && Boolean(this.stall))
         {
            _loc1_ = FeederLevel.getInstanceByLevel(this.stall.feeder.level.level + 1);
            this.feederUpgradeBtn.enabled = client.criticalComms == 0 && Boolean(_loc1_) && (_loc1_.credits > 0 && this.player.credits >= _loc1_.credits || _loc1_.tokens > 0 && client.user.tokens >= _loc1_.tokens);
            if(_loc1_)
            {
               _loc2_ = Asset.getInstanceByName("FEEDER_UPGRADE_TIP");
               if(_loc1_.credits < 0)
               {
                  _loc2_ = Asset.getInstanceByName("FEEDER_UPGRADE_TIP_NO_CREDS");
               }
               this.feederUpgradeBtn.toolTip = Utils.formatString(_loc2_.value,{
                  "credits":_loc1_.credits,
                  "tokens":_loc1_.tokens,
                  "capacity":_loc1_.capacity
               });
               this.feederUpgradeBtn.visible = true;
            }
            else
            {
               this.feederUpgradeBtn.toolTip = "";
               this.feederUpgradeBtn.visible = false;
            }
         }
      }
      
      private function updateUpgradeSkillsButton() : void
      {
         this.upgradeSkillsBtn.enabled = client.criticalComms == 0 && Boolean(this.creature) && !this.creature.isEgg;
      }
      
      private function updateSaveTraitsButton() : void
      {
         var _loc1_:TraitInstance = null;
         if(this.creature)
         {
            for each(_loc1_ in this.creature.traits)
            {
               if(_loc1_.level_delta != 0)
               {
                  this.saveTraitsBtn.enabled = true;
                  return;
               }
            }
         }
         this.saveTraitsBtn.enabled = false;
      }
      
      private function updateResetRenameButton() : void
      {
         var _loc1_:TokenPackage = TokenPackage.getInstanceByType(TokenPackage.TYPE_RESET_SKILLS);
         this.resetBtn.enabled = client.criticalComms == 0 && this.creature && !this.creature.isEgg && (client.user.tokens >= _loc1_.tokens || this.creature.respec_count > 0);
         _loc1_ = TokenPackage.getInstanceByType(TokenPackage.TYPE_RENAME_CREATURE);
         this.renameBtn.enabled = client.criticalComms == 0 && this.creature && !this.creature.isEgg && client.user.tokens >= _loc1_.tokens;
      }
      
      private function update(param1:String = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:MiniSkillView = null;
         var _loc4_:GradientLabel = null;
         var _loc5_:com.edgebee.breedr.ui.creature.SkillStatusView = null;
         var _loc6_:int = 0;
         var _loc7_:Date = null;
         var _loc8_:int = 0;
         if(childrenCreated || childrenCreating)
         {
            this.retireBtn.enabled = false;
            this.updateResetRenameButton();
            if(Boolean(this.creature) && Boolean(this.creature.id))
            {
               if(!this.creature.isEgg)
               {
                  title = this.creature.name;
                  this.familyLbl.text = this.creature.creature.name;
                  this.genderLbl.text = this.creature.is_male ? Asset.getInstanceByName("CREATURE_MALE") : Asset.getInstanceByName("CREATURE_FEMALE");
                  this.genderIcon.visible = true;
                  this.genderIcon.source = this.creature.is_male ? RanchView.MaleIconPng : RanchView.FemaleIconPng;
                  this.levelLbl.visible = true;
                  this.levelLbl.text = this.creature.level.toString() + " / " + this.creature.max_level.toString();
                  this.levelProgress.setValueAndMaximum(this.creature.level_progress,1);
                  this.maxHpLbl.visible = true;
                  this.maxHpLbl.text = this.creature.max_hp.toString();
                  this.maxPpLbl.visible = true;
                  this.maxPpLbl.text = this.creature.max_pp.toString();
                  this.levelProgress.visible = true;
                  this.staminaLevelView.visible = true;
                  this.happinessLevelView.visible = true;
                  this.healthLevelView.visible = true;
                  this.rankLbl.visible = true;
                  this.rankLbl.text = this.creature.rank.toString();
                  this.seedCountLbl.visible = true;
                  this.seedCountLbl.text = this.creature.seed_count.toString();
                  this.staminaLevelView.creature = this.creature;
                  this.happinessLevelView.creature = this.creature;
                  this.healthLevelView.creature = this.creature;
                  if(this.creature)
                  {
                     this.skillPointsLbl.visible = !this.locked && this.creature.modifiedSkillPoints > 0;
                     if(this.creature.modifiedSkillPoints == 1)
                     {
                        this.skillPointsLbl.text = Asset.getInstanceByName("SKILL_POINT");
                     }
                     else
                     {
                        this.skillPointsLbl.text = Utils.formatString(Asset.getInstanceByName("SKILL_POINTS").value,{"points":this.creature.modifiedSkillPoints.toString()});
                     }
                  }
                  else
                  {
                     this.skillPointsLbl.visible = false;
                  }
                  this.updateUpgradeSkillsButton();
                  if(this.stall)
                  {
                     this.feederInfo.visible = true;
                     this.feederView.feeder = this.stall.feeder;
                     this.capacityLbl.text = this.stall.feeder.level.capacity.toString();
                     this.feederLevelLbl.text = this.stall.feeder.level.level.toString();
                     this.updateUpgradeButton();
                  }
                  else
                  {
                     this.feederInfo.visible = false;
                     this.feederView.feeder = null;
                  }
                  this.traitsList.dataProvider = this.creature.traitsAndCreature;
                  this.updateSaveTraitsButton();
                  _loc6_ = 0;
                  while(_loc6_ < 5)
                  {
                     _loc5_ = this[skillBoxes[_loc6_]];
                     if(this.creature.modifiable_skills.length > _loc6_)
                     {
                        _loc5_.skill = this.creature.modifiable_skills[_loc6_];
                     }
                     else
                     {
                        _loc5_.skill = null;
                     }
                     _loc6_++;
                  }
                  this.retireBtn.enabled = this.creature && this.creature.auction_id == 0 && this.gameClient.tutorialManager.state == 0 && Boolean(this.stall);
                  this.freeRespecBox.visible = this.creature.respec_count > 0;
                  _loc7_ = new Date();
                  _loc7_.time += (this.creature.respec_expiration as Number) * 1000;
                  this.freeRespecBox.toolTip = Utils.formatString(Asset.getInstanceByName("FREE_RESPEC_DESC").value,{
                     "number":this.creature.respec_count.toString(),
                     "expiry":_loc7_.toLocaleString()
                  });
               }
               else
               {
                  title = "?????";
                  this.familyLbl.text = "?????";
                  this.genderLbl.text = "?????";
                  this.genderIcon.source = null;
                  this.genderIcon.visible = false;
                  this.staminaLevelView.visible = false;
                  this.happinessLevelView.visible = false;
                  this.healthLevelView.visible = false;
                  this.rankLbl.visible = false;
                  this.levelLbl.visible = false;
                  this.maxHpLbl.visible = false;
                  this.maxPpLbl.visible = false;
                  this.levelProgress.visible = false;
                  this.updateUpgradeSkillsButton();
                  this.traitsList.dataProvider = null;
                  _loc8_ = 0;
                  while(_loc8_ < 5)
                  {
                     (_loc5_ = this[skillBoxes[_loc8_]]).skill = null;
                     _loc8_++;
                  }
               }
               this.saveTraitsBtn.visible = !this.locked;
               this.resetBtn.visible = !this.locked;
               this.retireBtn.visible = !this.locked;
               this.renameBtn.visible = !this.locked;
               this.upgradeSkillsBtn.visible = !this.locked;
            }
         }
      }
      
      private function onEditSkills(param1:MouseEvent) : void
      {
         this.gameView.skillEditorWindow.creature = this.creature;
         UIGlobals.popUpManager.addPopUp(this.gameView.skillEditorWindow,this.gameView,true);
         UIGlobals.popUpManager.centerPopUp(this.gameView.skillEditorWindow);
         this.gameView.skillEditorWindow.visible = true;
      }
      
      private function onSaveTraitsClick(param1:MouseEvent) : void
      {
         var _loc3_:TraitInstance = null;
         var _loc2_:Object = client.createInput();
         _loc2_.creature_instance_id = this.creature.id;
         _loc2_.traits = [];
         for each(_loc3_ in this.creature.traits)
         {
            _loc2_.traits.push(_loc3_.marshal());
         }
         client.service.LevelUpTraits(_loc2_);
         ++client.criticalComms;
      }
      
      private function onUpgradeWithCredits(param1:Event) : void
      {
         var _loc2_:UpgradeWindow = param1.target as UpgradeWindow;
         var _loc3_:uint = _loc2_.extraData;
         var _loc4_:Object;
         (_loc4_ = client.createInput()).use_tokens = false;
         _loc4_.feeder_id = _loc3_;
         client.service.UpgradeFeeder(_loc4_);
         ++client.criticalComms;
         this.feederUpgradeBtn.enabled = false;
      }
      
      private function onUpgradeWithTokens(param1:Event) : void
      {
         var _loc2_:UpgradeWindow = param1.target as UpgradeWindow;
         var _loc3_:uint = _loc2_.extraData;
         var _loc4_:Object;
         (_loc4_ = client.createInput()).use_tokens = true;
         _loc4_.feeder_id = _loc3_;
         client.service.UpgradeFeeder(_loc4_);
         ++client.criticalComms;
         this.feederUpgradeBtn.enabled = false;
      }
      
      private function onFeederUpgradeClick(param1:MouseEvent) : void
      {
         var _loc2_:FeederLevel = FeederLevel.getInstanceByLevel(this.stall.feeder.level.level + 1);
         var _loc3_:UpgradeWindow = new UpgradeWindow();
         _loc3_.titleIcon = UIUtils.createBitmapIcon(RanchView.UpgradeIconPng,UIGlobals.relativize(16),UIGlobals.relativize(16));
         _loc3_.credits = _loc2_.credits;
         _loc3_.tokens = _loc2_.tokens;
         _loc3_.extraData = this.stall.feeder.id;
         _loc3_.addEventListener(UpgradeWindow.USE_CREDITS,this.onUpgradeWithCredits);
         _loc3_.addEventListener(UpgradeWindow.USE_TOKENS,this.onUpgradeWithTokens);
         UIGlobals.popUpManager.addPopUp(_loc3_,UIGlobals.root,true);
         UIGlobals.popUpManager.centerPopUp(_loc3_,null,false);
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "UpgradeFeeder")
         {
            --client.criticalComms;
            this.feederUpgradeBtn.enabled = true;
         }
         else if(param1.method == "RetireCreature")
         {
            --client.criticalComms;
            this.retireBtn.enabled = Boolean(this.creature) && this.creature.auction_id == 0 && this.gameClient.tutorialManager.state == 0;
         }
         else if(param1.method == "LevelUpTraits")
         {
            --client.criticalComms;
         }
         else if(param1.method == "RenameCreature")
         {
            if(this._tempRename)
            {
               this._tempRename = null;
               --client.criticalComms;
            }
         }
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms")
         {
            this.updateResetRenameButton();
            this.retireBtn.enabled = client.criticalComms == 0 && this.creature && this.creature.auction_id == 0 && this.gameClient.tutorialManager.state == 0;
            statusBar.enabled = client.criticalComms == 0;
            this.updateUpgradeButton();
            this.updateUpgradeSkillsButton();
            this.updateSaveTraitsButton();
         }
      }
      
      private function onUserChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "tokens")
         {
            this.updateResetRenameButton();
            this.updateUpgradeButton();
         }
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "credits")
         {
            this.updateUpgradeButton();
         }
      }
      
      private function onUpgradeFeeder(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            client.handleGameEvents(param1.data.events);
         }
      }
      
      private function onRetireCreature(param1:ServiceEvent) : void
      {
         this.creature = null;
         this.doClose();
         if(param1.data.hasOwnProperty("events"))
         {
            client.handleGameEvents(param1.data.events);
         }
      }
      
      private function onLevelUpTraits(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            client.handleGameEvents(param1.data.events);
         }
      }
      
      private function onResetClick(param1:MouseEvent) : void
      {
         var _loc2_:TokenPackage = null;
         var _loc3_:String = null;
         if(this.creature.respec_count)
         {
            this.onConfirmReset(null);
         }
         else
         {
            _loc2_ = TokenPackage.getInstanceByType(TokenPackage.TYPE_RESET_SKILLS);
            _loc3_ = Asset.getInstanceByName("RESET_SKILLS_CONFIRMATION").value;
            _loc3_ = Utils.formatString(_loc3_,{"tokens":_loc2_.tokens.toString()});
            AlertWindow.show(_loc3_,Asset.getInstanceByName("CONFIRMATION"),UIGlobals.root,true,{"ALERT_WINDOW_YES":this.onConfirmReset},false,false,true,true,false,true,AlertWindow.WarningIconPng);
         }
      }
      
      private function onConfirmReset(param1:Event) : void
      {
         var _loc2_:Object = client.createInput();
         _loc2_ = client.createInput();
         _loc2_.creature_instance_id = this.creature.id;
         _loc2_.use_free_respec = param1 == null;
         client.service.ResetSkills(_loc2_);
         ++client.criticalComms;
      }
      
      private function onRenameClick(param1:MouseEvent) : void
      {
         var _loc2_:TokenPackage = TokenPackage.getInstanceByType(TokenPackage.TYPE_RENAME_CREATURE);
         var _loc3_:String = Asset.getInstanceByName("RENAME_CREATURE_CONFIRMATION").value;
         _loc3_ = Utils.formatString(_loc3_,{
            "tokens":_loc2_.tokens.toString(),
            "name":this.creature.name
         });
         InputWindow.show(_loc3_,Asset.getInstanceByName("RENAME"),UIGlobals.root,true,{"ALERT_WINDOW_OK":this.onConfirmRename},true,true,null,CreatureInstance.MIN_NAME_LENGTH,CreatureInstance.MAX_NAME_LENGTH,true);
      }
      
      private function onConfirmRename(param1:Event) : void
      {
         var _loc4_:Object = null;
         var _loc2_:InputWindow = param1.target as InputWindow;
         var _loc3_:String = StringUtil.trim(_loc2_.textInput.text);
         if(_loc3_ != this.creature.name)
         {
            _loc4_ = client.createInput();
            (_loc4_ = client.createInput()).creature_instance_id = this.creature.id;
            _loc4_.name = _loc3_;
            this._tempRename = _loc3_;
            client.service.RenameCreature(_loc4_);
            ++client.criticalComms;
         }
      }
      
      private function onRenameCreature(param1:ServiceEvent) : void
      {
         if(this._tempRename)
         {
            this.creature.name = this._tempRename;
            this._tempRename = null;
            --client.criticalComms;
         }
      }
      
      private function onRetireClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:AlertWindow = null;
         var _loc4_:ItemView = null;
         this.retireBtn.enabled = false;
         if(!this.creature.isEgg)
         {
            if(this.creature.level >= this.creature.max_level)
            {
               _loc2_ = Utils.formatString(Asset.getInstanceByName("RETIRE_CONFIRMATION_MAX_LEVEL").value,{"credits":this.creature.creditsValue});
               _loc3_ = AlertWindow.create(_loc2_,Asset.getInstanceByName("CONFIRMATION"),true,false,true,true,false,true,AlertWindow.WarningIconPng);
               _loc3_.addEventListener(AlertWindow.RESULT_YES,this.onConfirmRetire);
               _loc3_.addEventListener(AlertWindow.RESULT_NO,this.onCancelRetire);
               (_loc4_ = new ItemView()).width = 128;
               _loc4_.height = 128;
               _loc4_.static_item = this.creature.creature.splicer;
               _loc3_.content.addChild(_loc4_);
               UIGlobals.popUpManager.addPopUp(_loc3_,this.gameView,true);
            }
            else
            {
               _loc2_ = Utils.formatString(Asset.getInstanceByName("RETIRE_CONFIRMATION").value,{"credits":this.creature.creditsValue});
               AlertWindow.show(_loc2_,Asset.getInstanceByName("CONFIRMATION"),UIGlobals.root,true,{
                  "ALERT_WINDOW_YES":this.onConfirmRetire,
                  "ALERT_WINDOW_NO":this.onCancelRetire
               },false,false,true,true,false,true,AlertWindow.WarningIconPng);
            }
         }
      }
      
      private function onConfirmRetire(param1:Event) : void
      {
         var _loc2_:Object = client.createInput();
         _loc2_ = client.createInput();
         _loc2_.creature_instance_id = this.creature.id;
         client.service.RetireCreature(_loc2_);
         ++client.criticalComms;
      }
      
      private function onCancelRetire(param1:Event) : void
      {
         this.retireBtn.enabled = true;
      }
      
      private function onTraitClicked(param1:ExtendedEvent) : void
      {
         var _loc2_:TraitInstance = null;
         if(!this.locked && this.creature.modifiedSkillPoints > 0)
         {
            _loc2_ = param1.data as TraitInstance;
            if(this.creature.modifiedSkillPoints > 0 && _loc2_.canUpgrade(this.creature))
            {
               _loc2_.level_delta += 1;
               --this.creature.skill_points_delta;
               UIGlobals.playSound(SkillEditorWindow.SkillLevelUpWav);
            }
         }
      }
   }
}
