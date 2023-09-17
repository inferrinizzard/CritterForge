package com.edgebee.breedr.ui.skill
{
   import com.adobe.utils.StringUtil;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.data.StaticData;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.DragEvent;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.MenuEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.containers.Menu;
   import com.edgebee.atlas.ui.containers.TileList;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.GradientLabel;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.ScrollBar;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.gadgets.InputWindow;
   import com.edgebee.atlas.ui.skins.LinkButtonSkin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Timer;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.skill.EffectPiece;
   import com.edgebee.breedr.data.skill.EffectPieceInstance;
   import com.edgebee.breedr.data.skill.ModifierPiece;
   import com.edgebee.breedr.data.skill.ModifierPieceInstance;
   import com.edgebee.breedr.data.skill.Piece;
   import com.edgebee.breedr.data.skill.Rule;
   import com.edgebee.breedr.data.skill.SkillInstance;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.skins.BreedrLeftArrowButtonSkin;
   import com.edgebee.breedr.ui.skins.BreedrRightArrowButtonSkin;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.text.TextFormatAlign;
   
   public class SkillEditorWindow extends Window
   {
      
      public static var SkillLevelUpWav:Class = SkillEditorWindow_SkillLevelUpWav;
      
      private static const SKILL_INDICES:Array = ["skillIndex1Lbl","skillIndex2Lbl","skillIndex3Lbl","skillIndex4Lbl","skillIndex5Lbl"];
       
      
      private var _creature:WeakReference;
      
      private var _skill:WeakReference;
      
      public var nonCritical:Boolean = false;
      
      private var _pieces:DataArray;
      
      private var _hints:Array;
      
      private var _currentHintIndex:int;
      
      private var _hintTimer:Timer;
      
      private var _nameInputWindow:InputWindow;
      
      private var _hoveringOver:WeakReference;
      
      public var benchBox:Box;
      
      public var pieceBox:Box;
      
      public var skillView:com.edgebee.breedr.ui.skill.SkillView;
      
      public var hintLbl:Label;
      
      public var selectorBox:Box;
      
      public var indexBox:Box;
      
      public var optionsBox:Box;
      
      public var previousBtn:Button;
      
      public var nextBtn:Button;
      
      public var pieceList:TileList;
      
      public var skillIndex1Lbl:GradientLabel;
      
      public var skillIndex2Lbl:GradientLabel;
      
      public var skillIndex3Lbl:GradientLabel;
      
      public var skillIndex4Lbl:GradientLabel;
      
      public var skillIndex5Lbl:GradientLabel;
      
      public var ppCostLbl:GradientLabel;
      
      public var renameBtn:Button;
      
      public var clearBtn:Button;
      
      public var priorityUpBtn:Button;
      
      public var priorityDownBtn:Button;
      
      public var saveBtn:Button;
      
      public var skillPointsLbl:GradientLabel;
      
      public var ruleTargetsBtn:Button;
      
      public var rulesBtn:Button;
      
      private var _contentLayout:Array;
      
      private var _statusBarLayout:Array;
      
      public function SkillEditorWindow()
      {
         this._creature = new WeakReference(null,CreatureInstance);
         this._skill = new WeakReference(null,SkillInstance);
         this._pieces = new DataArray(EffectPiece.classinfo,ModifierPiece.classinfo);
         this._hints = [];
         this._hintTimer = new Timer(5000);
         this._hoveringOver = new WeakReference(null,EffectView);
         this._contentLayout = [{
            "CLASS":Canvas,
            "percentWidth":1,
            "percentHeight":1,
            "CHILDREN":[{
               "CLASS":Box,
               "ID":"benchBox",
               "direction":Box.VERTICAL,
               "name":"SkillEditorBench",
               "percentWidth":1,
               "percentHeight":1,
               "useMouseScreen":true,
               "layoutInvisibleChildren":false,
               "spreadProportionality":false,
               "horizontalAlign":Box.ALIGN_CENTER,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "STYLES":{"Gap":UIGlobals.relativize(-7)},
               "CHILDREN":[{
                  "CLASS":Label,
                  "ID":"hintLbl",
                  "percentWidth":0.65,
                  "height":UIGlobals.relativize(32),
                  "wordWrap":true,
                  "filters":UIGlobals.fontOutline,
                  "alignment":TextFormatAlign.CENTER,
                  "STYLES":{
                     "FontSize":UIGlobals.relativizeFont(14),
                     "FontColor":13421772
                  }
               },{
                  "CLASS":com.edgebee.breedr.ui.skill.SkillView,
                  "ID":"skillView",
                  "size":UIGlobals.relativize(80),
                  "EVENTS":[{
                     "TYPE":PieceView.PIECE_MOUSE_CLICK,
                     "LISTENER":this.onPieceMouseClick
                  },{
                     "TYPE":PieceView.PIECE_MOUSE_OVER,
                     "LISTENER":this.onPieceMouseOver
                  },{
                     "TYPE":PieceView.PIECE_MOUSE_OUT,
                     "LISTENER":this.onPieceMouseOut
                  }]
               },{
                  "CLASS":Box,
                  "name":"AIPicker",
                  "percentWidth":1,
                  "horizontalAlign":Box.ALIGN_CENTER,
                  "CHILDREN":[{
                     "CLASS":Button,
                     "ID":"ruleTargetsBtn",
                     "STYLES":{
                        "PaddingLeft":2,
                        "PaddingRight":2,
                        "PaddingTop":2,
                        "PaddingBottom":2
                     },
                     "EVENTS":[{
                        "TYPE":MouseEvent.CLICK,
                        "LISTENER":this.onRuleTargetsClick
                     }]
                  },{
                     "CLASS":Spacer,
                     "width":UIGlobals.relativize(5)
                  },{
                     "CLASS":Button,
                     "ID":"rulesBtn",
                     "STYLES":{
                        "PaddingLeft":2,
                        "PaddingRight":2,
                        "PaddingTop":2,
                        "PaddingBottom":2
                     },
                     "EVENTS":[{
                        "TYPE":MouseEvent.CLICK,
                        "LISTENER":this.onRulesClick
                     }]
                  }]
               }]
            },{
               "CLASS":Box,
               "ID":"selectorBox",
               "percentWidth":1,
               "percentHeight":1,
               "horizontalAlign":Box.ALIGN_CENTER,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "CHILDREN":[{
                  "CLASS":Button,
                  "ID":"previousBtn",
                  "width":UIGlobals.relativize(24),
                  "height":UIGlobals.relativize(24),
                  "STYLES":{"Skin":BreedrLeftArrowButtonSkin},
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":this.onPreviousSkillClick
                  }]
               },{
                  "CLASS":Spacer,
                  "percentWidth":1
               },{
                  "CLASS":Button,
                  "ID":"nextBtn",
                  "width":UIGlobals.relativize(24),
                  "height":UIGlobals.relativize(24),
                  "STYLES":{"Skin":BreedrRightArrowButtonSkin},
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":this.onNextSkillClick
                  }]
               }]
            },{
               "CLASS":Box,
               "ID":"indexBox",
               "filters":UIGlobals.fontOutline,
               "percentWidth":1,
               "percentHeight":1,
               "CHILDREN":[{
                  "CLASS":Box,
                  "direction":Box.VERTICAL,
                  "STYLES":{"Gap":UIGlobals.relativize(-8)},
                  "CHILDREN":[{
                     "CLASS":GradientLabel,
                     "ID":"skillIndex1Lbl",
                     "STYLES":{"FontSize":UIGlobals.relativizeFont(16)}
                  },{
                     "CLASS":GradientLabel,
                     "ID":"skillIndex2Lbl",
                     "STYLES":{"FontSize":UIGlobals.relativizeFont(16)}
                  },{
                     "CLASS":GradientLabel,
                     "ID":"skillIndex3Lbl",
                     "STYLES":{"FontSize":UIGlobals.relativizeFont(16)}
                  },{
                     "CLASS":GradientLabel,
                     "ID":"skillIndex4Lbl",
                     "STYLES":{"FontSize":UIGlobals.relativizeFont(16)}
                  },{
                     "CLASS":GradientLabel,
                     "ID":"skillIndex5Lbl",
                     "STYLES":{"FontSize":UIGlobals.relativizeFont(16)}
                  }]
               },{
                  "CLASS":Spacer,
                  "percentWidth":1
               },{
                  "CLASS":GradientLabel,
                  "ID":"ppCostLbl",
                  "colors":[UIGlobals.getStyle("PPColor"),UIUtils.adjustBrightness2(UIGlobals.getStyle("PPColor"),85)],
                  "STYLES":{"FontSize":UIGlobals.relativizeFont(24)}
               }]
            },{
               "CLASS":Box,
               "ID":"optionsBox",
               "percentWidth":1,
               "percentHeight":1,
               "horizontalAlign":Box.ALIGN_CENTER,
               "verticalAlign":Box.ALIGN_BOTTOM,
               "CHILDREN":[{
                  "CLASS":GradientLabel,
                  "ID":"skillPointsLbl",
                  "filters":UIGlobals.fontOutline,
                  "colors":[UIGlobals.getStyle("SkillPointColor"),UIUtils.adjustBrightness2(UIGlobals.getStyle("SkillPointColor"),85)],
                  "STYLES":{
                     "FontWeight":"bold",
                     "FontSize":UIGlobals.relativizeFont(18)
                  }
               },{
                  "CLASS":Spacer,
                  "percentWidth":1
               },{
                  "CLASS":Button,
                  "ID":"priorityUpBtn",
                  "label":Asset.getInstanceByName("PRIORITY_UP"),
                  "STYLES":{
                     "Skin":LinkButtonSkin,
                     "FontColor":16777215,
                     "FontSize":UIGlobals.relativizeFont(12)
                  },
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":this.onPriorityUpClick
                  }]
               },{
                  "CLASS":Button,
                  "ID":"priorityUpBtn",
                  "label":Asset.getInstanceByName("PRIORITY_DOWN"),
                  "STYLES":{
                     "Skin":LinkButtonSkin,
                     "FontColor":16777215,
                     "FontSize":UIGlobals.relativizeFont(12)
                  },
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":this.onPriorityDownClick
                  }]
               },{
                  "CLASS":Button,
                  "ID":"renameBtn",
                  "label":Asset.getInstanceByName("RENAME"),
                  "STYLES":{
                     "Skin":LinkButtonSkin,
                     "FontColor":16777215,
                     "FontSize":UIGlobals.relativizeFont(12)
                  },
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":this.onRenameClick
                  }]
               },{
                  "CLASS":Button,
                  "ID":"clearBtn",
                  "label":Asset.getInstanceByName("CLEAR"),
                  "STYLES":{
                     "Skin":LinkButtonSkin,
                     "FontColor":16777215,
                     "FontSize":UIGlobals.relativizeFont(12)
                  },
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":this.onClearClick
                  }]
               }]
            }]
         },{
            "CLASS":Box,
            "ID":"pieceBox",
            "percentWidth":1,
            "height":UIGlobals.relativize(128),
            "useMouseScreen":true,
            "STYLES":{
               "BorderColor":16777215,
               "BorderAlpha":0,
               "BorderThickness":0
            },
            "CHILDREN":[{
               "CLASS":TileList,
               "ID":"pieceList",
               "sortFunc":sortPieces,
               "widthInColumns":9,
               "heightInRows":2,
               "direction":TileList.VERTICAL,
               "renderer":PieceListView,
               "STYLES":{"BackgroundAlpha":0.25}
            },{
               "CLASS":ScrollBar,
               "name":"SkillEditorWindow:PieceListScrollBar",
               "height":UIGlobals.relativize(128),
               "scrollable":"{pieceList}"
            }]
         }];
         this._statusBarLayout = [{
            "CLASS":Button,
            "ID":"saveBtn",
            "name":"SkillEditorSaveButton",
            "label":Asset.getInstanceByName("SAVE"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onSaveClick
            }]
         }];
         super();
         width = UIGlobals.relativizeX(650);
         height = UIGlobals.relativizeY(515);
         rememberPositionId = "SkillEditorWindow";
         title = Asset.getInstanceByName("SKILL_EDITOR");
         visible = false;
         client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         client.service.addEventListener("GetAvailableSkillPieces",this.onGetAvailableSkillPieces);
         client.service.addEventListener("SetSkills",this.onSetSkills);
         client.service.addEventListener("ResetSkills",this.onResetSkills);
         client.user.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onUserChange);
      }
      
      private static function sortPieces(param1:*, param2:*) : int
      {
         var _loc3_:Piece = param1 as Piece;
         var _loc4_:Piece = param2 as Piece;
         if(_loc3_.priority < _loc4_.priority)
         {
            return -1;
         }
         if(_loc3_.priority > _loc4_.priority)
         {
            return 1;
         }
         return 0;
      }
      
      private static function sortSkills(param1:SkillInstance, param2:SkillInstance) : int
      {
         if(param1.originalIndex < param2.originalIndex)
         {
            return -1;
         }
         if(param1.originalIndex > param2.originalIndex)
         {
            return 1;
         }
         return 0;
      }
      
      public function get player() : Player
      {
         return (client as Client).player;
      }
      
      public function get gameView() : GameView
      {
         return (UIGlobals.root as breedr_flash).rootView.gameView;
      }
      
      public function get creature() : CreatureInstance
      {
         return this._creature.get() as CreatureInstance;
      }
      
      public function set creature(param1:CreatureInstance) : void
      {
         var _loc2_:Object = null;
         if(param1 != this.creature)
         {
            if(this.creature)
            {
               this.creature.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
            }
            this._creature.reset(param1);
            if(this.creature)
            {
               this.creature.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
               this.skill = this.creature.modifiable_skills[0];
               _loc2_ = client.createInput();
               _loc2_.creature_instance_id = this.creature.id;
               client.service.GetAvailableSkillPieces(_loc2_);
               this.pieceList.busyOverlayed = true;
            }
            this.update();
         }
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
         content.direction = Box.VERTICAL;
         content.horizontalAlign = Box.ALIGN_LEFT;
         content.layoutInvisibleChildren = false;
         UIUtils.performLayout(this,content,this._contentLayout);
         this.pieceList.dataProvider = this._pieces;
         statusBar.horizontalAlign = Box.ALIGN_CENTER;
         statusBar.setStyle("Gap",5);
         UIUtils.performLayout(this,statusBar,this._statusBarLayout);
         this.benchBox.addEventListener(DragEvent.DRAG_ENTER,this.onBenchDragEnter);
         this.benchBox.addEventListener(DragEvent.DRAG_EXIT,this.onBenchDragExit);
         this.benchBox.addEventListener(DragEvent.DRAG_OVER,this.onBenchDragOver);
         this.benchBox.addEventListener(DragEvent.DRAG_DROP,this.onBenchDragDrop);
         this._hintTimer.addEventListener(TimerEvent.TIMER,this.onHintTimer);
         this.onUserChange(null);
      }
      
      override public function doClose() : void
      {
         UIGlobals.popUpManager.removePopUp(this);
         visible = false;
         this._pieces.removeAll();
         this.clearAllChanges();
         this.creature = null;
         dispatchEvent(new Event(Event.CLOSE));
         this._hintTimer.stop();
         if(this._nameInputWindow)
         {
            this._nameInputWindow.doClose();
            this._nameInputWindow = null;
         }
      }
      
      public function resetAvailableSkillPieces(param1:Array, param2:Array) : void
      {
         var _loc3_:uint = 0;
         this._pieces.removeAll();
         var _loc4_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc4_.push(EffectPiece.getInstanceById(_loc3_));
         }
         for each(_loc3_ in param2)
         {
            _loc4_.push(ModifierPiece.getInstanceById(_loc3_));
         }
         this._pieces.source = _loc4_;
      }
      
      public function resetSkillPoints() : void
      {
         this.skillPointsLbl.visible = this.creature.skill_points > 0 || this.creature.skill_points_delta != 0;
         if(this.creature.modifiedSkillPoints == 1)
         {
            this.skillPointsLbl.text = Asset.getInstanceByName("SKILL_POINT");
         }
         else
         {
            this.skillPointsLbl.text = Utils.formatString(Asset.getInstanceByName("SKILL_POINTS").value,{"points":this.creature.modifiedSkillPoints.toString()});
         }
      }
      
      private function onUserChange(param1:PropertyChangeEvent) : void
      {
         if((!param1 || param1.property == "state") && Boolean(this.renameBtn))
         {
            this.renameBtn.enabled = client.user.registered;
            this.renameBtn.toolTip = !client.user.registered ? Asset.getInstanceByName("MUST_BE_REGISTERED") : null;
         }
      }
      
      private function onCreatureChange(param1:PropertyChangeEvent) : void
      {
         if(!this.creature.copying)
         {
            this.update(param1.property);
         }
      }
      
      private function onSkillChange(param1:PropertyChangeEvent) : void
      {
         if(!this.skill.copying)
         {
            this.update(param1.property);
         }
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms")
         {
            enabled = client.criticalComms == 0;
         }
      }
      
      private function onGetAvailableSkillPieces(param1:ServiceEvent) : void
      {
         this.pieceList.busyOverlayed = false;
         this.resetAvailableSkillPieces(param1.data.effect_pieces,param1.data.modifier_pieces);
      }
      
      private function onHintTimer(param1:TimerEvent) : void
      {
         ++this._currentHintIndex;
         if(this._currentHintIndex >= this._hints.length)
         {
            this._currentHintIndex = 0;
         }
         this.hintLbl.text = this._hints[this._currentHintIndex];
      }
      
      private function update(param1:String = null) : void
      {
         var _loc2_:EffectPieceInstance = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(childrenCreated || childrenCreating)
         {
            if(this.creature)
            {
               this.skillView.skill = this.skill;
               this.skillView.creature = this.creature;
               this._hints = [];
               this._currentHintIndex = 0;
               if(this.skill.pieces.length == 0)
               {
                  this._hints.push(Asset.getInstanceByName("SKILL_EDITOR_HINT_EMPTY"));
               }
               else
               {
                  if(this.skill.pieces.length == 1)
                  {
                     this._hints.push(Asset.getInstanceByName("SKILL_EDITOR_HINT_NO_SECONDARY"));
                  }
                  if(this.creature.modifiedSkillPoints > 0)
                  {
                     this._hints.push(Asset.getInstanceByName("SKILL_EDITOR_HINT_SKILL_POINTS"));
                  }
                  if(this.skill.pieces.length > 0)
                  {
                     _loc2_ = this.skill.pieces[0] as EffectPieceInstance;
                     if(_loc2_.slot_count > _loc2_.pieces.length)
                     {
                        this._hints.push(Asset.getInstanceByName("SKILL_EDITOR_HINT_OPEN_SLOT"));
                     }
                     else if(this.skill.pieces.length > 1)
                     {
                        _loc2_ = this.skill.pieces[1] as EffectPieceInstance;
                        if(_loc2_.slot_count > _loc2_.pieces.length)
                        {
                           this._hints.push(Asset.getInstanceByName("SKILL_EDITOR_HINT_OPEN_SLOT"));
                        }
                     }
                  }
                  if(this.creature.skill_points_delta != 0)
                  {
                     this._hints.push(Asset.getInstanceByName("SKILL_EDITOR_HINT_CHANGES"));
                  }
                  this._hints.push(Asset.getInstanceByName("SKILL_EDITOR_HINT_IDLE"));
               }
               this._currentHintIndex = Utils.randomInt(0,this._hints.length - 1);
               this.hintLbl.text = this._hints[this._currentHintIndex];
               this._hintTimer.reset();
               this._hintTimer.start();
               this.ppCostLbl.text = Utils.formatString(Asset.getInstanceByName("PP_COST_WITH_MAX").value,{
                  "cost":this.skill.dynamicPPCost,
                  "max_pp":this.creature.max_pp.toString()
               });
               this.resetSkillPoints();
               this.updateSkillIndices();
               this.ruleTargetsBtn.label = this.skill.rule_targets_enemy ? Asset.getInstanceByName("RULE_WHEN_ENEMY") : Asset.getInstanceByName("RULE_WHEN_SELF");
               if(this.skill.rule)
               {
                  this.rulesBtn.label = this.skill.rule.description;
               }
               else
               {
                  this.rulesBtn.label = Asset.getInstanceByName("CLICK_TO_SET_A_RULE");
               }
            }
            else
            {
               this.skillView.skill = null;
               this.ppCostLbl.text = "";
               this.skillPointsLbl.text = "";
               _loc3_ = 0;
               while(_loc3_ < SKILL_INDICES.length)
               {
                  _loc4_ = String(SKILL_INDICES[_loc3_]);
                  this[_loc4_].visible = false;
                  _loc3_++;
               }
            }
         }
      }
      
      private function updateSkillIndices() : void
      {
         var _loc2_:String = null;
         var _loc1_:int = 0;
         while(_loc1_ < SKILL_INDICES.length)
         {
            _loc2_ = String(SKILL_INDICES[_loc1_]);
            if(_loc1_ < this.creature.modifiable_skills.length)
            {
               this[_loc2_].visible = true;
               this[_loc2_].text = this.creature.modifiable_skills[_loc1_].name;
               if(_loc1_ == this.creature.modifiable_skills.getItemIndex(this.skill))
               {
                  this[_loc2_].alpha = 1;
                  (this[_loc2_] as Component).dropShadowProxy.alpha = 1;
                  (this[_loc2_] as Component).colorMatrix.reset();
               }
               else
               {
                  this[_loc2_].alpha = 0.5;
                  (this[_loc2_] as Component).colorMatrix.saturation = -50;
                  (this[_loc2_] as Component).colorMatrix.contrast = -50;
               }
            }
            else
            {
               this[_loc2_].visible = false;
            }
            _loc1_++;
         }
      }
      
      private function onPreviousSkillClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this.creature.modifiable_skills.getItemIndex(this.skill);
         _loc2_--;
         if(_loc2_ < 0)
         {
            _loc2_ = this.creature.modifiable_skills.length - 1;
         }
         this.skill = this.creature.modifiable_skills[_loc2_];
      }
      
      private function onNextSkillClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this.creature.modifiable_skills.getItemIndex(this.skill);
         _loc2_++;
         if(_loc2_ >= this.creature.modifiable_skills.length)
         {
            _loc2_ = 0;
         }
         this.skill = this.creature.modifiable_skills[_loc2_];
      }
      
      private function clearAllChanges() : void
      {
         var _loc1_:SkillInstance = null;
         var _loc2_:Piece = null;
         var _loc3_:Piece = null;
         var _loc4_:EffectPieceInstance = null;
         var _loc5_:ModifierPieceInstance = null;
         var _loc6_:Array = null;
         if(this.creature)
         {
            for each(_loc1_ in this.creature.modifiable_skills)
            {
               for each(_loc2_ in _loc1_.pieces)
               {
                  _loc4_ = _loc2_ as EffectPieceInstance;
                  this.creature.skill_points_delta += _loc4_.level_delta;
                  _loc4_.level_delta = 0;
                  for each(_loc3_ in _loc4_.pieces)
                  {
                     _loc5_ = _loc3_ as ModifierPieceInstance;
                     this.creature.skill_points_delta += _loc5_.level_delta;
                     _loc5_.level_delta = 0;
                  }
               }
            }
            for each(_loc1_ in this.creature.modifiable_skills)
            {
               _loc6_ = _loc1_.temporaryPieces;
               for each(_loc2_ in _loc6_)
               {
                  _loc1_.removePiece(_loc2_);
               }
            }
            this.creature.skills.sort(sortSkills);
         }
      }
      
      private function onSelectName(param1:Event) : void
      {
         var _loc2_:String = StringUtil.trim(this._nameInputWindow.textInput.text);
         if(_loc2_.length >= 3 && _loc2_.length <= 16)
         {
            this.skill.name = _loc2_;
         }
         this._nameInputWindow = null;
      }
      
      private function onCancelName(param1:Event) : void
      {
         this._nameInputWindow = null;
      }
      
      private function onPriorityUpClick(param1:MouseEvent) : void
      {
         var _loc3_:SkillInstance = null;
         var _loc2_:int = this.creature.skills.getItemIndex(this.skill);
         if(_loc2_ > 1 && this.creature.skills.length > 2)
         {
            _loc3_ = this.creature.skills.removeItem(this.skill) as SkillInstance;
            this.creature.skills.addItemAt(_loc3_,_loc2_ - 1);
            this.updateSkillIndices();
         }
      }
      
      private function onPriorityDownClick(param1:MouseEvent) : void
      {
         var _loc3_:SkillInstance = null;
         var _loc2_:int = this.creature.skills.getItemIndex(this.skill);
         if(_loc2_ < this.creature.skills.length - 1 && this.creature.skills.length > 2)
         {
            _loc3_ = this.creature.skills.removeItem(this.skill) as SkillInstance;
            this.creature.skills.addItemAt(_loc3_,_loc2_ + 1);
            this.updateSkillIndices();
         }
      }
      
      private function onRenameClick(param1:MouseEvent) : void
      {
         if(this._nameInputWindow)
         {
            this._nameInputWindow.doClose();
         }
         this._nameInputWindow = InputWindow.create(Asset.getInstanceByName("RENAME_SKILL_BODY"),Asset.getInstanceByName("RENAME_SKILL_TITLE"),true,true);
         this._nameInputWindow.minChars = 3;
         this._nameInputWindow.maxChars = 16;
         this._nameInputWindow.trim = true;
         this._nameInputWindow.defaultText = this.skill.name;
         this._nameInputWindow.textInputWidth = 120;
         this._nameInputWindow.addEventListener(InputWindow.RESULT_OK,this.onSelectName);
         this._nameInputWindow.addEventListener(InputWindow.RESULT_CANCEL,this.onCancelName);
         this._nameInputWindow.addEventListener(InputWindow.RESULT_CLOSE,this.onCancelName);
         UIGlobals.popUpManager.addPopUp(this._nameInputWindow,this,false);
         UIGlobals.popUpManager.centerPopUp(this._nameInputWindow);
      }
      
      private function onClearClick(param1:MouseEvent) : void
      {
         var _loc4_:Piece = null;
         var _loc5_:Array = null;
         var _loc6_:Piece = null;
         var _loc7_:Piece = null;
         var _loc8_:EffectPieceInstance = null;
         var _loc9_:ModifierPieceInstance = null;
         var _loc2_:Array = this.skill.temporaryPieces;
         var _loc3_:Array = [];
         for each(_loc4_ in _loc2_)
         {
            _loc3_ = _loc3_.concat(this.skill.removePiece(_loc4_,this.creature));
         }
         _loc5_ = [];
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_ is EffectPieceInstance)
            {
               _loc5_.push((_loc4_ as EffectPieceInstance).effect_piece);
            }
            if(_loc4_ is ModifierPieceInstance)
            {
               _loc5_.push((_loc4_ as ModifierPieceInstance).modifier_piece);
            }
         }
         this._pieces.source = this._pieces.source.concat(_loc5_);
         for each(_loc6_ in this.skill.pieces)
         {
            _loc8_ = _loc6_ as EffectPieceInstance;
            this.creature.skill_points_delta += _loc8_.level_delta;
            _loc8_.level_delta = 0;
            for each(_loc7_ in _loc8_.pieces)
            {
               _loc9_ = _loc7_ as ModifierPieceInstance;
               this.creature.skill_points_delta += _loc9_.level_delta;
               _loc9_.level_delta = 0;
            }
         }
         this.skillView.resetLocks();
      }
      
      private function onSaveClick(param1:MouseEvent) : void
      {
         var _loc3_:SkillInstance = null;
         var _loc2_:Object = client.createInput();
         _loc2_.creature_instance_id = this.creature.id;
         _loc2_.skills = [];
         var _loc4_:int = 0;
         while(_loc4_ < this.creature.modifiable_skills.length)
         {
            _loc3_ = this.creature.modifiable_skills[_loc4_];
            _loc2_.skills.push(_loc3_.marshal(_loc4_));
            _loc4_++;
         }
         client.service.SetSkills(_loc2_);
         if(!this.nonCritical)
         {
            ++client.criticalComms;
         }
         else
         {
            visible = false;
         }
      }
      
      private function onSetSkills(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            client.handleGameEvents(param1.data.events);
         }
      }
      
      private function onResetSkills(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            client.handleGameEvents(param1.data.events);
         }
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "SetSkills")
         {
            if(!this.nonCritical)
            {
               --client.criticalComms;
            }
         }
         else if(param1.method == "ResetSkills")
         {
            if(!this.nonCritical)
            {
               --client.criticalComms;
            }
         }
      }
      
      private function onPieceMouseClick(param1:ExtendedEvent) : void
      {
         var _loc2_:PieceView = null;
         var _loc3_:Piece = null;
         if(this.creature.modifiedSkillPoints > 0)
         {
            _loc2_ = param1.data.piece as PieceView;
            _loc3_ = _loc2_.piece as Piece;
            if(_loc3_ is EffectPieceInstance || _loc3_ is ModifierPieceInstance)
            {
               if(_loc3_.canUpgrade(this.creature))
               {
                  --this.creature.skill_points_delta;
                  _loc3_.level_delta += 1;
                  UIGlobals.playSound(SkillLevelUpWav);
               }
            }
         }
      }
      
      private function onPieceMouseOver(param1:ExtendedEvent) : void
      {
      }
      
      private function onPieceMouseOut(param1:ExtendedEvent) : void
      {
      }
      
      private function onRuleTargetsClick(param1:MouseEvent) : void
      {
         var _loc2_:Array = [];
         _loc2_.push({
            "LABEL":Asset.getInstanceByName("RULE_WHEN_SELF"),
            "SDATA":false,
            "ENABLED":true
         });
         _loc2_.push({
            "LABEL":Asset.getInstanceByName("RULE_WHEN_ENEMY"),
            "SDATA":true,
            "ENABLED":true
         });
         var _loc3_:Menu = new Menu(this,_loc2_);
         _loc3_.addEventListener(MenuEvent.ITEM_CLICK,this.onRuleTargetsSelect);
         _loc3_.show(param1.stageX,param1.stageY);
      }
      
      private function onRuleTargetsSelect(param1:MenuEvent) : void
      {
         this.skill.rule_targets_enemy = param1.data as Boolean;
         this.ruleTargetsBtn.label = this.skill.rule_targets_enemy ? Asset.getInstanceByName("RULE_WHEN_ENEMY") : Asset.getInstanceByName("RULE_WHEN_SELF");
      }
      
      private function onRulesClick(param1:MouseEvent) : void
      {
         var _loc12_:* = undefined;
         var _loc14_:Rule = null;
         var _loc16_:* = false;
         var _loc17_:String = null;
         var _loc18_:Array = null;
         var _loc2_:Array = [];
         var _loc3_:Object = {
            "name":"health",
            "LABEL":Asset.getInstanceByName("AI_REASON_HP"),
            "CHILDREN":[]
         };
         var _loc4_:Object = {
            "name":"power",
            "LABEL":Asset.getInstanceByName("AI_REASON_PP"),
            "CHILDREN":[]
         };
         var _loc5_:Object = {
            "name":"conditions",
            "LABEL":Asset.getInstanceByName("AI_REASON_CONDITIONS"),
            "CHILDREN":[]
         };
         var _loc6_:Object = {
            "name":"random",
            "LABEL":Asset.getInstanceByName("RULE_RANDOM"),
            "CHILDREN":[]
         };
         var _loc7_:Object = {
            "name":"round",
            "LABEL":Asset.getInstanceByName("RULE_ROUND_INDEX"),
            "CHILDREN":[]
         };
         var _loc8_:Object = {
            "name":"special",
            "LABEL":Asset.getInstanceByName("RULE_CONDITIONS_SPECIAL"),
            "CHILDREN":[]
         };
         var _loc9_:Object = {
            "name":"boosts",
            "LABEL":Asset.getInstanceByName("RULE_CONDITIONS_BOOST"),
            "CHILDREN":[]
         };
         var _loc10_:Object = {
            "name":"reduces",
            "LABEL":Asset.getInstanceByName("RULE_CONDITIONS_REDUCE"),
            "CHILDREN":[]
         };
         var _loc11_:Object = {
            "name":"traits",
            "LABEL":Asset.getInstanceByName("RULE_TRAIT"),
            "CHILDREN":[]
         };
         var _loc13_:Array = StaticData.getAllInstances("Rule","id");
         for each(_loc14_ in _loc13_)
         {
            _loc16_ = _loc14_.min_level <= this.creature.level;
            _loc17_ = null;
            if(!_loc16_)
            {
               _loc17_ = Utils.formatString(Asset.getInstanceByName("RULE_REQUIRES_LEVEL").value,{"level":_loc14_.min_level});
               _loc17_ = Utils.htmlWrap(_loc17_,UIGlobals.getStyle("FontFamily"),null,UIGlobals.getStyle("SmallFontSize",9));
            }
            _loc12_ = _loc14_.description;
            switch(_loc14_.classification)
            {
               case Rule.CLASSIFICATION_NONE:
                  _loc18_ = _loc2_;
                  break;
               case Rule.CLASSIFICATION_HEALTH:
                  _loc18_ = _loc3_.CHILDREN;
                  break;
               case Rule.CLASSIFICATION_POWER:
                  _loc18_ = _loc4_.CHILDREN;
                  break;
               case Rule.CLASSIFICATION_CONDITIONS:
                  _loc18_ = _loc5_.CHILDREN;
                  break;
               case Rule.CLASSIFICATION_RANDOM:
                  _loc18_ = _loc6_.CHILDREN;
                  break;
               case Rule.CLASSIFICATION_ROUND:
                  _loc18_ = _loc7_.CHILDREN;
                  break;
               case Rule.CLASSIFICATION_CONDITIONS_SPECIAL:
                  _loc18_ = _loc8_.CHILDREN;
                  break;
               case Rule.CLASSIFICATION_CONDITIONS_BOOST:
                  _loc18_ = _loc9_.CHILDREN;
                  break;
               case Rule.CLASSIFICATION_CONDITIONS_REDUCE:
                  _loc18_ = _loc10_.CHILDREN;
                  break;
               case Rule.CLASSIFICATION_TRAIT:
                  _loc18_ = _loc11_.CHILDREN;
                  break;
            }
            _loc18_.push({
               "LABEL":_loc12_,
               "SDATA":_loc14_,
               "ENABLED":_loc16_,
               "TOOLTIP":_loc17_
            });
         }
         _loc5_.CHILDREN.push(_loc9_);
         _loc5_.CHILDREN.push(_loc10_);
         _loc5_.CHILDREN.push(_loc8_);
         if(_loc3_.CHILDREN.length > 0)
         {
            _loc2_.push(_loc3_);
         }
         if(_loc4_.CHILDREN.length > 0)
         {
            _loc2_.push(_loc4_);
         }
         if(_loc5_.CHILDREN.length > 0)
         {
            _loc2_.push(_loc5_);
         }
         if(_loc6_.CHILDREN.length > 0)
         {
            _loc2_.push(_loc6_);
         }
         if(_loc7_.CHILDREN.length > 0)
         {
            _loc2_.push(_loc7_);
         }
         if(_loc11_.CHILDREN.length > 0)
         {
            _loc2_.push(_loc11_);
         }
         var _loc15_:Menu;
         (_loc15_ = new Menu(this,_loc2_)).addEventListener(MenuEvent.ITEM_CLICK,this.onRuleSelect);
         _loc15_.show(param1.stageX,param1.stageY);
      }
      
      private function onRuleSelect(param1:MenuEvent) : void
      {
         this.skill.rule_id = (param1.data as Rule).id;
         this.rulesBtn.label = this.skill.rule.description;
      }
      
      private function onBenchDragEnter(param1:DragEvent) : void
      {
         var _loc2_:Piece = null;
         if(param1.dragInfo.hasOwnProperty("piece"))
         {
            _loc2_ = param1.dragInfo.piece as Piece;
            UIGlobals.dragManager.acceptDragDrop(this.benchBox);
         }
      }
      
      private function onBenchDragOver(param1:DragEvent) : void
      {
         var _loc3_:Point = null;
         var _loc2_:Component = param1.dragProxy;
         _loc3_ = this.skillView.globalToLocal(_loc2_.parent.localToGlobal(new Point(_loc2_.x + _loc2_.width / 2,_loc2_.y + _loc2_.height / 2)));
         if(!this.skillView.primary.effect || !this.skillView.secondary.effect)
         {
            this._hoveringOver.reset(this.skillView.primary);
         }
         else if(_loc3_.y < this.skillView.height / 2)
         {
            this._hoveringOver.reset(this.skillView.primary);
         }
         else
         {
            this._hoveringOver.reset(this.skillView.secondary);
         }
      }
      
      private function onBenchDragExit(param1:DragEvent) : void
      {
      }
      
      private function onBenchDragDrop(param1:DragEvent) : void
      {
         var _loc2_:Piece = null;
         var _loc3_:EffectPiece = null;
         var _loc4_:EffectPieceInstance = null;
         var _loc5_:EffectView = null;
         var _loc6_:EffectPieceInstance = null;
         var _loc7_:ModifierPiece = null;
         var _loc8_:ModifierPieceInstance = null;
         var _loc9_:Piece = null;
         if(param1.dragInfo.hasOwnProperty("piece"))
         {
            _loc2_ = param1.dragInfo.piece as Piece;
            if(_loc2_ is EffectPiece)
            {
               if(this.skill.pieces.length >= 2)
               {
                  return;
               }
               _loc3_ = _loc2_ as EffectPiece;
               if(_loc3_.top != null && _loc3_.top.isValid && this.skill.pieces.length == 0)
               {
                  return;
               }
               if((Boolean(_loc4_ = this.skill.pieces.last as EffectPieceInstance)) && !_loc3_.canConnectTo(_loc4_.effect_piece))
               {
                  return;
               }
               this.skill.pieces.addItem((_loc2_ as EffectPiece).instantiate());
               this._pieces.removeItem(_loc2_);
            }
            else if(_loc2_ is ModifierPiece)
            {
               this.onBenchDragOver(param1);
               _loc6_ = (_loc5_ = this._hoveringOver.get() as EffectView).effect;
               _loc7_ = _loc2_ as ModifierPiece;
               if(_loc6_)
               {
                  if(_loc6_.pieces.length >= _loc6_.slot_count)
                  {
                     return;
                  }
                  if(_loc7_.type == ModifierPiece.TYPE_FIRE || _loc7_.type == ModifierPiece.TYPE_ICE || _loc7_.type == ModifierPiece.TYPE_THUNDER || _loc7_.type == ModifierPiece.TYPE_EARTH)
                  {
                     for each(_loc8_ in _loc6_.pieces)
                     {
                        if(_loc8_.modifier_piece.type == ModifierPiece.TYPE_FIRE || _loc8_.modifier_piece.type == ModifierPiece.TYPE_ICE || _loc8_.modifier_piece.type == ModifierPiece.TYPE_THUNDER || _loc8_.modifier_piece.type == ModifierPiece.TYPE_EARTH)
                        {
                           return;
                        }
                     }
                  }
                  if(!(_loc9_ = _loc6_.pieces.last as Piece))
                  {
                     _loc9_ = _loc6_.effect_piece;
                  }
                  if(!_loc7_.canConnectTo(_loc9_) || !_loc7_.canConnectTo(_loc6_.effect_piece))
                  {
                     return;
                  }
                  _loc6_.pieces.addItem(_loc7_.instantiate());
                  this._pieces.removeItem(_loc2_);
               }
            }
            this._hoveringOver.reset(null);
         }
      }
   }
}
