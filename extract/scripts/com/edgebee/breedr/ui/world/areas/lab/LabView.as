package com.edgebee.breedr.ui.world.areas.lab
{
   import com.edgebee.atlas.animation.Interpolation;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.DragEvent;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.creature.Accessory;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.item.Item;
   import com.edgebee.breedr.data.item.ItemInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.player.TokenPackage;
   import com.edgebee.breedr.data.world.Area;
   import com.edgebee.breedr.data.world.Dialog;
   import com.edgebee.breedr.ui.ControlBar;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.creature.CreatureView;
   import com.edgebee.breedr.ui.skins.BreedrLeftArrowButtonSkin;
   import com.edgebee.breedr.ui.skins.BreedrRightArrowButtonSkin;
   import com.edgebee.breedr.ui.skins.TransparentWindow;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class LabView extends Canvas
   {
      
      public static const ManipIconPng:Class = LabView_ManipIconPng;
      
      private static const MAX_MANIPS_PER_ACCESSORY:uint = 5;
      
      private static const MANIP_NAMES:Array = ["horns","wings","dorsal","tail","claws","mouth","family"];
      
      private static const MANIP_ICONS:Array = ["manipBmp01","manipBmp02","manipBmp03","manipBmp04","manipBmp05"];
      
      private static const CREATURE_SIZE:Number = UIGlobals.relativize(220);
      
      private static const ICON_SIZE:Number = UIGlobals.relativize(22);
       
      
      private var _manipulations:Array;
      
      private const MANIP_FAMILY:uint = 0;
      
      private const MANIP_HORNS:uint = 1;
      
      private const MANIP_WINGS:uint = 2;
      
      private const MANIP_DORSAL:uint = 3;
      
      private const MANIP_TAIL:uint = 4;
      
      private const MANIP_CLAWS:uint = 5;
      
      private const MANIP_MOUTH:uint = 6;
      
      private var _manipulationsLeft:uint;
      
      private var _seed1:WeakReference;
      
      private var _seed2:WeakReference;
      
      private var _addedManips:uint = 0;
      
      public var creatureBox:Canvas;
      
      public var parent1View:CreatureView;
      
      public var parent2View:CreatureView;
      
      public var optionsBox:Box;
      
      public var createBtn:Button;
      
      public var nameLbl:Label;
      
      public var bg:TransparentWindow;
      
      public var manipulationsLeftLbl:Label;
      
      public var manipulationsBox:Box;
      
      public var addManipsBtn:Button;
      
      public var parent1HintLbl:Label;
      
      public var parent2HintLbl:Label;
      
      public var parent1Box:Box;
      
      public var parent2Box:Box;
      
      public var selectorsBox:Box;
      
      public var eggBox:Box;
      
      public var eggView:CreatureView;
      
      public var hornsSelectorBox:Box;
      
      public var hornsSelectorLbl:Label;
      
      public var wingsSelectorBox:Box;
      
      public var wingsSelectorLbl:Label;
      
      public var dorsalSelectorBox:Box;
      
      public var dorsalSelectorLbl:Label;
      
      public var tailSelectorBox:Box;
      
      public var tailSelectorLbl:Label;
      
      public var mouthSelectorBox:Box;
      
      public var mouthSelectorLbl:Label;
      
      public var clawsSelectorBox:Box;
      
      public var clawsSelectorLbl:Label;
      
      public var familySelectorBox:Box;
      
      public var familySelectorLbl:Label;
      
      public var manipBmp01:BitmapComponent;
      
      public var manipBmp02:BitmapComponent;
      
      public var manipBmp03:BitmapComponent;
      
      public var manipBmp04:BitmapComponent;
      
      public var manipBmp05:BitmapComponent;
      
      private var _layout:Array;
      
      public function LabView()
      {
         this._manipulations = [0,0,0,0,0,0,0];
         this._seed1 = new WeakReference(null,ItemInstance);
         this._seed2 = new WeakReference(null,ItemInstance);
         this._layout = [{
            "CLASS":Box,
            "name":"BreedBox",
            "width":UIGlobals.relativize(600),
            "height":UIGlobals.relativize(450),
            "direction":Box.VERTICAL,
            "layoutInvisibleChildren":false,
            "STYLES":{"Padding":UIGlobals.relativize(12)},
            "CHILDREN":[{
               "CLASS":TransparentWindow,
               "ID":"bg",
               "width":UIGlobals.relativize(600),
               "height":UIGlobals.relativize(450),
               "includeInLayout":false
            },{
               "CLASS":Box,
               "percentWidth":1,
               "percentHeight":1,
               "layoutInvisibleChildren":false,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "horizontalAlign":Box.ALIGN_CENTER,
               "CHILDREN":[{
                  "CLASS":Box,
                  "ID":"parent1Box",
                  "layoutInvisibleChildren":false,
                  "width":CREATURE_SIZE,
                  "horizontalAlign":Box.ALIGN_CENTER,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "CHILDREN":[{
                     "CLASS":CreatureView,
                     "ID":"parent1View",
                     "disableElements":true,
                     "width":CREATURE_SIZE,
                     "height":CREATURE_SIZE,
                     "relativeProportions":true
                  },{
                     "CLASS":Label,
                     "ID":"parent1HintLbl",
                     "filters":UIGlobals.fontOutline,
                     "useHtml":true,
                     "visible":true,
                     "STYLES":{"FontColor":16777215},
                     "text":Asset.getInstanceByName("BREED_DRAG_SAMPLE")
                  }]
               },{
                  "CLASS":Box,
                  "ID":"selectorsBox",
                  "name":"BreedSelectors",
                  "direction":Box.VERTICAL,
                  "percentWidth":1,
                  "STYLES":{"Gap":1},
                  "CHILDREN":[{
                     "CLASS":Box,
                     "ID":"hornsSelectorBox",
                     "horizontalAlign":Box.ALIGN_CENTER,
                     "direction":Box.VERTICAL,
                     "percentWidth":1,
                     "STYLES":{
                        "BackgroundAlpha":0.25,
                        "Gap":UIGlobals.relativize(-4)
                     },
                     "CHILDREN":[{
                        "CLASS":Label,
                        "text":Asset.getInstanceByName("HORNS"),
                        "filters":UIGlobals.fontOutline,
                        "STYLES":{
                           "FontWeight":"bold",
                           "FontSize":UIGlobals.relativizeFont(12)
                        }
                     },{
                        "CLASS":Box,
                        "percentWidth":1,
                        "verticalAlign":Box.ALIGN_MIDDLE,
                        "horizontalAlign":Box.ALIGN_CENTER,
                        "CHILDREN":[{
                           "CLASS":Button,
                           "STYLES":{
                              "Skin":BreedrLeftArrowButtonSkin,
                              "PaddingLeft":8,
                              "PaddingRight":8
                           },
                           "EVENTS":[{
                              "TYPE":MouseEvent.CLICK,
                              "LISTENER":this.hornsLeftClick
                           }]
                        },{
                           "CLASS":Spacer,
                           "percentWidth":0.5
                        },{
                           "CLASS":Label,
                           "ID":"hornsSelectorLbl",
                           "useHtml":true,
                           "filters":UIGlobals.fontOutline,
                           "STYLES":{
                              "FontWeight":"bold",
                              "FontSize":UIGlobals.relativizeFont(12)
                           }
                        },{
                           "CLASS":Spacer,
                           "percentWidth":0.5
                        },{
                           "CLASS":Button,
                           "STYLES":{
                              "Skin":BreedrRightArrowButtonSkin,
                              "PaddingLeft":8,
                              "PaddingRight":8
                           },
                           "EVENTS":[{
                              "TYPE":MouseEvent.CLICK,
                              "LISTENER":this.hornsRightClick
                           }]
                        }]
                     }]
                  },{
                     "CLASS":Box,
                     "ID":"wingsSelectorBox",
                     "horizontalAlign":Box.ALIGN_CENTER,
                     "direction":Box.VERTICAL,
                     "percentWidth":1,
                     "STYLES":{
                        "BackgroundAlpha":0.25,
                        "Gap":UIGlobals.relativize(-4)
                     },
                     "CHILDREN":[{
                        "CLASS":Label,
                        "text":Asset.getInstanceByName("WINGS"),
                        "filters":UIGlobals.fontOutline,
                        "STYLES":{
                           "FontWeight":"bold",
                           "FontSize":UIGlobals.relativizeFont(12)
                        }
                     },{
                        "CLASS":Box,
                        "percentWidth":1,
                        "verticalAlign":Box.ALIGN_MIDDLE,
                        "horizontalAlign":Box.ALIGN_CENTER,
                        "CHILDREN":[{
                           "CLASS":Button,
                           "STYLES":{
                              "Skin":BreedrLeftArrowButtonSkin,
                              "PaddingLeft":8,
                              "PaddingRight":8
                           },
                           "EVENTS":[{
                              "TYPE":MouseEvent.CLICK,
                              "LISTENER":this.wingsLeftClick
                           }]
                        },{
                           "CLASS":Spacer,
                           "percentWidth":0.5
                        },{
                           "CLASS":Label,
                           "ID":"wingsSelectorLbl",
                           "useHtml":true,
                           "filters":UIGlobals.fontOutline,
                           "STYLES":{
                              "FontWeight":"bold",
                              "FontSize":UIGlobals.relativizeFont(12)
                           }
                        },{
                           "CLASS":Spacer,
                           "percentWidth":0.5
                        },{
                           "CLASS":Button,
                           "STYLES":{
                              "Skin":BreedrRightArrowButtonSkin,
                              "PaddingLeft":8,
                              "PaddingRight":8
                           },
                           "EVENTS":[{
                              "TYPE":MouseEvent.CLICK,
                              "LISTENER":this.wingsRightClick
                           }]
                        }]
                     }]
                  },{
                     "CLASS":Box,
                     "ID":"dorsalSelectorBox",
                     "horizontalAlign":Box.ALIGN_CENTER,
                     "direction":Box.VERTICAL,
                     "percentWidth":1,
                     "STYLES":{
                        "BackgroundAlpha":0.25,
                        "Gap":UIGlobals.relativize(-4)
                     },
                     "CHILDREN":[{
                        "CLASS":Label,
                        "text":Asset.getInstanceByName("DORSAL"),
                        "filters":UIGlobals.fontOutline,
                        "STYLES":{
                           "FontWeight":"bold",
                           "FontSize":UIGlobals.relativizeFont(12)
                        }
                     },{
                        "CLASS":Box,
                        "percentWidth":1,
                        "verticalAlign":Box.ALIGN_MIDDLE,
                        "horizontalAlign":Box.ALIGN_CENTER,
                        "CHILDREN":[{
                           "CLASS":Button,
                           "STYLES":{
                              "Skin":BreedrLeftArrowButtonSkin,
                              "PaddingLeft":8,
                              "PaddingRight":8
                           },
                           "EVENTS":[{
                              "TYPE":MouseEvent.CLICK,
                              "LISTENER":this.dorsalLeftClick
                           }]
                        },{
                           "CLASS":Spacer,
                           "percentWidth":0.5
                        },{
                           "CLASS":Label,
                           "ID":"dorsalSelectorLbl",
                           "useHtml":true,
                           "filters":UIGlobals.fontOutline,
                           "STYLES":{
                              "FontWeight":"bold",
                              "FontSize":UIGlobals.relativizeFont(12)
                           }
                        },{
                           "CLASS":Spacer,
                           "percentWidth":0.5
                        },{
                           "CLASS":Button,
                           "STYLES":{
                              "Skin":BreedrRightArrowButtonSkin,
                              "PaddingLeft":8,
                              "PaddingRight":8
                           },
                           "EVENTS":[{
                              "TYPE":MouseEvent.CLICK,
                              "LISTENER":this.dorsalRightClick
                           }]
                        }]
                     }]
                  },{
                     "CLASS":Box,
                     "ID":"tailSelectorBox",
                     "horizontalAlign":Box.ALIGN_CENTER,
                     "direction":Box.VERTICAL,
                     "percentWidth":1,
                     "STYLES":{
                        "BackgroundAlpha":0.25,
                        "Gap":UIGlobals.relativize(-4)
                     },
                     "CHILDREN":[{
                        "CLASS":Label,
                        "text":Asset.getInstanceByName("TAIL"),
                        "filters":UIGlobals.fontOutline,
                        "STYLES":{
                           "FontWeight":"bold",
                           "FontSize":UIGlobals.relativizeFont(12)
                        }
                     },{
                        "CLASS":Box,
                        "percentWidth":1,
                        "verticalAlign":Box.ALIGN_MIDDLE,
                        "horizontalAlign":Box.ALIGN_CENTER,
                        "CHILDREN":[{
                           "CLASS":Button,
                           "STYLES":{
                              "Skin":BreedrLeftArrowButtonSkin,
                              "PaddingLeft":8,
                              "PaddingRight":8
                           },
                           "EVENTS":[{
                              "TYPE":MouseEvent.CLICK,
                              "LISTENER":this.tailLeftClick
                           }]
                        },{
                           "CLASS":Spacer,
                           "percentWidth":0.5
                        },{
                           "CLASS":Label,
                           "ID":"tailSelectorLbl",
                           "useHtml":true,
                           "filters":UIGlobals.fontOutline,
                           "STYLES":{
                              "FontWeight":"bold",
                              "FontSize":UIGlobals.relativizeFont(12)
                           }
                        },{
                           "CLASS":Spacer,
                           "percentWidth":0.5
                        },{
                           "CLASS":Button,
                           "STYLES":{
                              "Skin":BreedrRightArrowButtonSkin,
                              "PaddingLeft":8,
                              "PaddingRight":8
                           },
                           "EVENTS":[{
                              "TYPE":MouseEvent.CLICK,
                              "LISTENER":this.tailRightClick
                           }]
                        }]
                     }]
                  },{
                     "CLASS":Box,
                     "ID":"mouthSelectorBox",
                     "horizontalAlign":Box.ALIGN_CENTER,
                     "direction":Box.VERTICAL,
                     "percentWidth":1,
                     "STYLES":{
                        "BackgroundAlpha":0.25,
                        "Gap":UIGlobals.relativize(-4)
                     },
                     "CHILDREN":[{
                        "CLASS":Label,
                        "text":Asset.getInstanceByName("JAW"),
                        "filters":UIGlobals.fontOutline,
                        "STYLES":{
                           "FontWeight":"bold",
                           "FontSize":UIGlobals.relativizeFont(12)
                        }
                     },{
                        "CLASS":Box,
                        "percentWidth":1,
                        "verticalAlign":Box.ALIGN_MIDDLE,
                        "horizontalAlign":Box.ALIGN_CENTER,
                        "CHILDREN":[{
                           "CLASS":Button,
                           "STYLES":{
                              "Skin":BreedrLeftArrowButtonSkin,
                              "PaddingLeft":8,
                              "PaddingRight":8
                           },
                           "EVENTS":[{
                              "TYPE":MouseEvent.CLICK,
                              "LISTENER":this.mouthLeftClick
                           }]
                        },{
                           "CLASS":Spacer,
                           "percentWidth":0.5
                        },{
                           "CLASS":Label,
                           "ID":"mouthSelectorLbl",
                           "useHtml":true,
                           "filters":UIGlobals.fontOutline,
                           "STYLES":{
                              "FontWeight":"bold",
                              "FontSize":UIGlobals.relativizeFont(12)
                           }
                        },{
                           "CLASS":Spacer,
                           "percentWidth":0.5
                        },{
                           "CLASS":Button,
                           "STYLES":{
                              "Skin":BreedrRightArrowButtonSkin,
                              "PaddingLeft":8,
                              "PaddingRight":8
                           },
                           "EVENTS":[{
                              "TYPE":MouseEvent.CLICK,
                              "LISTENER":this.mouthRightClick
                           }]
                        }]
                     }]
                  },{
                     "CLASS":Box,
                     "ID":"clawsSelectorBox",
                     "horizontalAlign":Box.ALIGN_CENTER,
                     "direction":Box.VERTICAL,
                     "percentWidth":1,
                     "STYLES":{
                        "BackgroundAlpha":0.25,
                        "Gap":UIGlobals.relativize(-4)
                     },
                     "CHILDREN":[{
                        "CLASS":Label,
                        "text":Asset.getInstanceByName("CLAWS"),
                        "filters":UIGlobals.fontOutline,
                        "STYLES":{
                           "FontWeight":"bold",
                           "FontSize":UIGlobals.relativizeFont(12)
                        }
                     },{
                        "CLASS":Box,
                        "percentWidth":1,
                        "verticalAlign":Box.ALIGN_MIDDLE,
                        "horizontalAlign":Box.ALIGN_CENTER,
                        "CHILDREN":[{
                           "CLASS":Button,
                           "STYLES":{
                              "Skin":BreedrLeftArrowButtonSkin,
                              "PaddingLeft":8,
                              "PaddingRight":8
                           },
                           "EVENTS":[{
                              "TYPE":MouseEvent.CLICK,
                              "LISTENER":this.clawsLeftClick
                           }]
                        },{
                           "CLASS":Spacer,
                           "percentWidth":0.5
                        },{
                           "CLASS":Label,
                           "ID":"clawsSelectorLbl",
                           "useHtml":true,
                           "filters":UIGlobals.fontOutline,
                           "STYLES":{
                              "FontWeight":"bold",
                              "FontSize":UIGlobals.relativizeFont(12)
                           }
                        },{
                           "CLASS":Spacer,
                           "percentWidth":0.5
                        },{
                           "CLASS":Button,
                           "STYLES":{
                              "Skin":BreedrRightArrowButtonSkin,
                              "PaddingLeft":8,
                              "PaddingRight":8
                           },
                           "EVENTS":[{
                              "TYPE":MouseEvent.CLICK,
                              "LISTENER":this.clawsRightClick
                           }]
                        }]
                     }]
                  },{
                     "CLASS":Box,
                     "ID":"familySelectorBox",
                     "horizontalAlign":Box.ALIGN_CENTER,
                     "direction":Box.VERTICAL,
                     "percentWidth":1,
                     "STYLES":{
                        "BackgroundAlpha":0.25,
                        "Gap":UIGlobals.relativize(-4)
                     },
                     "CHILDREN":[{
                        "CLASS":Label,
                        "text":Asset.getInstanceByName("FAMILY"),
                        "filters":UIGlobals.fontOutline,
                        "STYLES":{
                           "FontWeight":"bold",
                           "FontSize":UIGlobals.relativizeFont(12)
                        }
                     },{
                        "CLASS":Box,
                        "percentWidth":1,
                        "verticalAlign":Box.ALIGN_MIDDLE,
                        "horizontalAlign":Box.ALIGN_CENTER,
                        "CHILDREN":[{
                           "CLASS":Button,
                           "STYLES":{
                              "Skin":BreedrLeftArrowButtonSkin,
                              "PaddingLeft":8,
                              "PaddingRight":8
                           },
                           "EVENTS":[{
                              "TYPE":MouseEvent.CLICK,
                              "LISTENER":this.familyLeftClick
                           }]
                        },{
                           "CLASS":Spacer,
                           "percentWidth":0.5
                        },{
                           "CLASS":Label,
                           "ID":"familySelectorLbl",
                           "useHtml":true,
                           "filters":UIGlobals.fontOutline,
                           "STYLES":{
                              "FontWeight":"bold",
                              "FontSize":UIGlobals.relativizeFont(12)
                           }
                        },{
                           "CLASS":Spacer,
                           "percentWidth":0.5
                        },{
                           "CLASS":Button,
                           "STYLES":{
                              "Skin":BreedrRightArrowButtonSkin,
                              "PaddingLeft":8,
                              "PaddingRight":8
                           },
                           "EVENTS":[{
                              "TYPE":MouseEvent.CLICK,
                              "LISTENER":this.familyRightClick
                           }]
                        }]
                     }]
                  }]
               },{
                  "CLASS":Box,
                  "ID":"parent2Box",
                  "layoutInvisibleChildren":false,
                  "width":CREATURE_SIZE,
                  "horizontalAlign":Box.ALIGN_CENTER,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "CHILDREN":[{
                     "CLASS":CreatureView,
                     "ID":"parent2View",
                     "disableElements":true,
                     "width":CREATURE_SIZE,
                     "height":CREATURE_SIZE,
                     "relativeProportions":true
                  },{
                     "CLASS":Label,
                     "ID":"parent2HintLbl",
                     "filters":UIGlobals.fontOutline,
                     "useHtml":true,
                     "visible":true,
                     "STYLES":{"FontColor":16777215},
                     "text":Asset.getInstanceByName("BREED_DRAG_SAMPLE")
                  }]
               },{
                  "CLASS":Box,
                  "ID":"eggBox",
                  "visible":false,
                  "CHILDREN":[{
                     "CLASS":CreatureView,
                     "ID":"eggView",
                     "width":CREATURE_SIZE * 1.5,
                     "height":CREATURE_SIZE * 1.5,
                     "relativeProportions":true
                  }]
               }]
            },{
               "CLASS":Spacer,
               "height":UIGlobals.relativize(15)
            },{
               "CLASS":Box,
               "ID":"optionsBox",
               "percentWidth":1,
               "horizontalAlign":Box.ALIGN_CENTER,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "layoutInvisibleChildren":false,
               "STYLES":{
                  "Gap":UIGlobals.relativize(3),
                  "BackgroundAlpha":0.5,
                  "CornerRadius":15,
                  "Padding":UIGlobals.relativize(12)
               },
               "CHILDREN":[{
                  "CLASS":Box,
                  "direction":Box.VERTICAL,
                  "ID":"manipulationsBox",
                  "STYLES":{"Gap":-4},
                  "CHILDREN":[{
                     "CLASS":Box,
                     "STYLES":{"Gap":UIGlobals.relativize(3)},
                     "filters":UIGlobals.fontOutline,
                     "CHILDREN":[{
                        "CLASS":BitmapComponent,
                        "ID":"manipBmp01",
                        "width":ICON_SIZE,
                        "isSquare":true,
                        "source":ManipIconPng
                     },{
                        "CLASS":BitmapComponent,
                        "ID":"manipBmp02",
                        "width":ICON_SIZE,
                        "isSquare":true,
                        "source":ManipIconPng
                     },{
                        "CLASS":BitmapComponent,
                        "ID":"manipBmp03",
                        "width":ICON_SIZE,
                        "isSquare":true,
                        "source":ManipIconPng
                     },{
                        "CLASS":BitmapComponent,
                        "ID":"manipBmp04",
                        "width":ICON_SIZE,
                        "isSquare":true,
                        "source":ManipIconPng
                     },{
                        "CLASS":BitmapComponent,
                        "ID":"manipBmp05",
                        "width":ICON_SIZE,
                        "isSquare":true,
                        "source":ManipIconPng
                     }]
                  },{
                     "CLASS":Label,
                     "ID":"manipulationsLeftLbl",
                     "filters":UIGlobals.fontOutline,
                     "STYLES":{
                        "FontSize":UIGlobals.relativize(11),
                        "FontWeight":"bold"
                     }
                  }]
               },{
                  "CLASS":Button,
                  "ID":"addManipsBtn",
                  "label":Asset.getInstanceByName("ADD_MANIPS"),
                  "visible":false,
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":this.onAddManipsClick
                  }]
               },{
                  "CLASS":Spacer,
                  "percentWidth":1
               },{
                  "CLASS":Button,
                  "ID":"createBtn",
                  "name":"BreedButton",
                  "label":Asset.getInstanceByName("BREED"),
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":this.onCreateClick
                  }]
               },{
                  "CLASS":Button,
                  "label":Asset.getInstanceByName("RESET"),
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":this.onResetClick
                  }]
               }]
            }]
         }];
         super();
         this.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         this.client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         this.client.user.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onUserChange);
         this.client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         this.client.service.addEventListener("Breed",this.onBreed);
         this.client.service.addEventListener("TrashItem",this.onThrashItem);
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get gameView() : GameView
      {
         return (UIGlobals.root as breedr_flash).rootView.gameView;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         addEventListener(DragEvent.DRAG_ENTER,this.onDragEnter);
         addEventListener(DragEvent.DRAG_EXIT,this.onDragExit);
         addEventListener(DragEvent.DRAG_DROP,this.onDragDrop);
         var _loc1_:BitmapComponent = new BitmapComponent();
         _loc1_.source = ControlBar.TokenIcon32Png;
         _loc1_.width = 16;
         _loc1_.height = 16;
         this.addManipsBtn.icon = _loc1_;
         this.update();
      }
      
      override protected function doSetVisible(param1:Boolean) : void
      {
         super.doSetVisible(param1);
         if(param1)
         {
            this.bg.startAnimation();
         }
         else
         {
            this.bg.stopAnimation();
         }
      }
      
      private function get seed1() : ItemInstance
      {
         return this._seed1.get() as ItemInstance;
      }
      
      private function set seed1(param1:ItemInstance) : void
      {
         if(this.seed1 != param1)
         {
            this._seed1.reset(param1);
            if(this.seed2)
            {
               this.resetManipulations();
            }
            this.update();
         }
      }
      
      private function get seed2() : ItemInstance
      {
         return this._seed2.get() as ItemInstance;
      }
      
      private function set seed2(param1:ItemInstance) : void
      {
         if(this.seed2 != param1)
         {
            this._seed2.reset(param1);
            if(this.seed1)
            {
               this.resetManipulations();
            }
            this.update();
         }
      }
      
      private function resetManipulations(param1:Boolean = true) : void
      {
         var _loc2_:TokenPackage = null;
         this._manipulationsLeft = 5;
         this._manipulations = [0,0,0,0,0,0,0];
         if(param1)
         {
            _loc2_ = TokenPackage.getInstanceByType(TokenPackage.TYPE_ADD_MANIPULATIONS);
            this.client.user.tokens += _loc2_.tokens * this._addedManips;
            this._addedManips = 0;
         }
         this._addedManips = 0;
      }
      
      private function reset(param1:Boolean = true) : void
      {
         this.seed1 = null;
         this.seed2 = null;
         this.resetManipulations(param1);
         this.update();
      }
      
      private function doBreed(param1:Event = null) : void
      {
         var _loc2_:Object = this.client.createInput();
         _loc2_.seed1_id = this.seed1.id;
         _loc2_.seed2_id = this.seed2.id;
         _loc2_.manipulations = this._manipulations;
         this.client.service.Breed(_loc2_);
         ++this.client.criticalComms;
      }
      
      private function onCreateClick(param1:MouseEvent) : void
      {
         var _loc2_:AlertWindow = null;
         if(this.player.freeStallCount < 1)
         {
            this.gameView.dialogView.dialog = Dialog.getInstanceByName("lab_stables_full");
            this.gameView.dialogView.step();
         }
         else if(!this.client.criticalComms)
         {
            if(this._manipulationsLeft > 0)
            {
               _loc2_ = AlertWindow.show(Asset.getInstanceByName("STILL_MANIPULATIONS_LEFT"),Asset.getInstanceByName("CONFIRMATION"),UIGlobals.root,true,{"ALERT_WINDOW_YES":this.doBreed},true,false,true,true,false,false,AlertWindow.WarningIconPng);
            }
            else
            {
               this.doBreed();
            }
         }
      }
      
      private function onAddManipsClick(param1:MouseEvent) : void
      {
         var _loc2_:TokenPackage = TokenPackage.getInstanceByType(TokenPackage.TYPE_ADD_MANIPULATIONS);
         var _loc3_:String = Asset.getInstanceByName("CONFIRM_TOKEN_PURCHASE").value;
         _loc3_ = Utils.formatString(_loc3_,{"tokens":_loc2_.tokens.toString()});
         var _loc4_:AlertWindow = AlertWindow.show(_loc3_,Asset.getInstanceByName("CONFIRMATION"),UIGlobals.root,true,{"ALERT_WINDOW_OK":this.onAddManipsConfirmed},true,true,false,false,true,true,ControlBar.TokenIcon32Png);
      }
      
      private function onAddManipsConfirmed(param1:Event) : void
      {
         var _loc2_:TokenPackage = TokenPackage.getInstanceByType(TokenPackage.TYPE_ADD_MANIPULATIONS);
         this.client.user.tokens -= _loc2_.tokens;
         ++this._addedManips;
         this._manipulationsLeft = 5;
         this.update();
      }
      
      private function onResetClick(param1:MouseEvent) : void
      {
         this.reset();
      }
      
      private function getRatioString(param1:uint) : String
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc2_:int = int(this._manipulations[param1]);
         var _loc3_:* = Math.abs(_loc2_) == MAX_MANIPS_PER_ACCESSORY;
         if(_loc2_ < 0)
         {
            _loc4_ = 50 + Math.abs(_loc2_) * 5;
            _loc6_ = Utils.htmlWrap(_loc4_.toString() + "%",null,_loc3_ ? 11206570 : 16777130,0,true);
            _loc5_ = 50 - Math.abs(_loc2_) * 5;
            _loc7_ = Utils.htmlWrap(_loc5_.toString() + "%",null,16755370,0,false);
            return Utils.htmlWrap(_loc6_ + " - " + _loc7_,null,14540253,UIGlobals.relativizeFont(14));
         }
         if(_loc2_ > 0)
         {
            _loc4_ = 50 - _loc2_ * 5;
            _loc6_ = Utils.htmlWrap(_loc4_.toString() + "%",null,16755370,0,false);
            _loc5_ = 50 + _loc2_ * 5;
            _loc7_ = Utils.htmlWrap(_loc5_.toString() + "%",null,_loc3_ ? 11206570 : 16777130,0,true);
            return Utils.htmlWrap(_loc6_ + " - " + _loc7_,null,14540253,UIGlobals.relativizeFont(14));
         }
         return Utils.htmlWrap("50% - 50%",null,14540253,UIGlobals.relativizeFont(14),false);
      }
      
      private function update() : void
      {
         var _loc1_:String = null;
         var _loc2_:CreatureInstance = null;
         var _loc3_:CreatureInstance = null;
         var _loc4_:BitmapComponent = null;
         var _loc5_:int = 0;
         var _loc6_:TokenPackage = null;
         if(this.parent1View)
         {
            if(childrenCreated || childrenCreating)
            {
               this.createBtn.enabled = Boolean(this.seed1) && Boolean(this.seed2);
               this.parent1View.creature = !!this.seed1 ? this.seed1.creature : null;
               this.parent2View.creature = !!this.seed2 ? this.seed2.creature : null;
               this.parent1View.visible = this.seed1 != null;
               this.parent1HintLbl.visible = this.seed1 == null;
               this.parent2View.visible = this.seed2 != null;
               this.parent2HintLbl.visible = this.seed2 == null;
               if(Boolean(this.parent1View.creature) && Boolean(this.parent2View.creature))
               {
                  _loc2_ = this.parent1View.creature;
                  _loc3_ = this.parent2View.creature;
                  for each(_loc1_ in MANIP_NAMES)
                  {
                     if(_loc1_ == "family")
                     {
                        this[_loc1_ + "SelectorBox"].enabled = _loc2_.creature.id != _loc3_.creature.id;
                     }
                     else
                     {
                        this[_loc1_ + "SelectorBox"].enabled = _loc2_[_loc1_ + "_id"] || _loc3_[_loc1_ + "_id"];
                     }
                     this[_loc1_ + "SelectorBox"].alpha = !!this[_loc1_ + "SelectorBox"].enabled ? 1 : 0.5;
                     this[_loc1_ + "SelectorBox"].colorMatrix.saturation = !!this[_loc1_ + "SelectorBox"].enabled ? 0 : 100;
                     if(this[_loc1_ + "SelectorBox"].enabled)
                     {
                        this[_loc1_ + "SelectorLbl"].text = this.getRatioString(this["MANIP_" + _loc1_.toUpperCase()]);
                     }
                     else
                     {
                        this[_loc1_ + "SelectorLbl"].text = Utils.htmlWrap("---",null,14540253,UIGlobals.relativizeFont(14));
                     }
                  }
               }
               else
               {
                  for each(_loc1_ in MANIP_NAMES)
                  {
                     this[_loc1_ + "SelectorBox"].enabled = false;
                     this[_loc1_ + "SelectorBox"].alpha = 0.5;
                     this[_loc1_ + "SelectorBox"].colorMatrix.saturation = 0;
                     this[_loc1_ + "SelectorLbl"].text = Utils.htmlWrap("---",null,14540253,UIGlobals.relativizeFont(14));
                  }
               }
               this.manipulationsLeftLbl.visible = Boolean(this.seed1) && Boolean(this.seed2);
               if(Boolean(this.seed1) && Boolean(this.seed2))
               {
                  if(this._manipulationsLeft > 0)
                  {
                     this.manipulationsBox.visible = true;
                     this.addManipsBtn.visible = false;
                     this.manipulationsLeftLbl.text = Utils.formatString(Asset.getInstanceByName("MANIPULATIONS_LEFT").value,{"num":this._manipulationsLeft.toString()});
                     _loc5_ = 0;
                     while(_loc5_ < MAX_MANIPS_PER_ACCESSORY)
                     {
                        _loc4_ = this[MANIP_ICONS[_loc5_]];
                        if(_loc5_ > this._manipulationsLeft - 1)
                        {
                           _loc4_.colorMatrix.saturation = -100;
                           _loc4_.colorMatrix.brightness = -50;
                        }
                        else
                        {
                           _loc4_.colorMatrix.reset();
                        }
                        _loc5_++;
                     }
                  }
                  else
                  {
                     this.addManipsBtn.visible = true;
                     _loc6_ = TokenPackage.getInstanceByType(TokenPackage.TYPE_ADD_MANIPULATIONS);
                     this.addManipsBtn.enabled = this.client.user.tokens >= _loc6_.tokens;
                     this.manipulationsBox.visible = false;
                  }
               }
               else
               {
                  this.addManipsBtn.visible = false;
                  this.manipulationsBox.visible = false;
               }
            }
            else
            {
               this.parent1View.creature = null;
               this.parent2View.creature = null;
            }
         }
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "area")
         {
            if(this.player.area.type == Area.TYPE_LABORATORY)
            {
               this.update();
            }
            else
            {
               this.reset();
            }
         }
      }
      
      private function onUserChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "tokens")
         {
            this.update();
         }
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms" && Boolean(this.optionsBox))
         {
            this.optionsBox.enabled = this.client.criticalComms == 0;
         }
      }
      
      private function onBreed(param1:ServiceEvent) : void
      {
         --this.client.criticalComms;
         this.reset(false);
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onThrashItem(param1:ServiceEvent) : void
      {
         this.update();
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "Breed")
         {
            --this.client.criticalComms;
         }
      }
      
      private function onDragEnter(param1:DragEvent) : void
      {
         var _loc2_:ItemInstance = null;
         if(param1.dragInfo.hasOwnProperty("item"))
         {
            _loc2_ = param1.dragInfo.item as ItemInstance;
            if(_loc2_.item.type == Item.TYPE_BREED && _loc2_.creature.id > 0 && _loc2_.auction_id == 0 && !_loc2_.creature.is_quest && (!this.seed1 || !this.seed2) && this.seed1 != _loc2_ && this.seed2 != _loc2_)
            {
               colorMatrix.brightness = 10;
               UIGlobals.dragManager.acceptDragDrop(this);
            }
         }
      }
      
      private function onDragExit(param1:DragEvent) : void
      {
         colorMatrix.reset();
      }
      
      private function onDragDrop(param1:DragEvent) : void
      {
         var _loc2_:ItemInstance = null;
         if(param1.dragInfo.hasOwnProperty("item"))
         {
            _loc2_ = param1.dragInfo.item as ItemInstance;
            colorMatrix.reset();
            if(this.seed1)
            {
               if(Boolean(this.seed1) && this.seed1.creature.is_male == _loc2_.creature.is_male)
               {
                  this.gameView.dialogView.dialog = Dialog.getInstanceByName("lab_wrong_gender");
                  this.gameView.dialogView.step();
               }
               else
               {
                  this.seed2 = _loc2_;
               }
            }
            else if(Boolean(this.seed2) && this.seed2.creature.is_male == _loc2_.creature.is_male)
            {
               this.gameView.dialogView.dialog = Dialog.getInstanceByName("lab_wrong_gender");
               this.gameView.dialogView.step();
            }
            else
            {
               this.seed1 = _loc2_;
            }
         }
      }
      
      private function manipToAccName(param1:uint) : String
      {
         switch(param1)
         {
            case this.MANIP_CLAWS:
               return "claw";
            case this.MANIP_DORSAL:
               return "dorsal";
            case this.MANIP_HORNS:
               return "horns";
            case this.MANIP_MOUTH:
               return "mouth";
            case this.MANIP_TAIL:
               return "tail";
            case this.MANIP_WINGS:
               return "wings";
            default:
               return null;
         }
      }
      
      private function clickLeft(param1:uint) : void
      {
         var _loc3_:BitmapComponent = null;
         var _loc4_:Accessory = null;
         var _loc5_:String = null;
         if(this._manipulations[param1] <= -MAX_MANIPS_PER_ACCESSORY)
         {
            return;
         }
         var _loc2_:Boolean = false;
         if(this._manipulations[param1] <= 0)
         {
            if(this._manipulationsLeft > 0)
            {
               --this._manipulationsLeft;
               --this._manipulations[param1];
               _loc2_ = true;
            }
         }
         else
         {
            ++this._manipulationsLeft;
            --this._manipulations[param1];
         }
         if(_loc2_)
         {
            if(param1 == this.MANIP_FAMILY)
            {
               _loc3_ = this.parent1View.layers["body"] as BitmapComponent;
               _loc3_.colorTransformProxy.offset = 255;
               _loc3_.controller.animateTo({"colorTransformProxy.offset":0},{"colorTransformProxy.offset":Interpolation.expoIn},true,2);
            }
            else
            {
               for(_loc5_ in this.parent1View.layers)
               {
                  _loc3_ = this.parent1View.layers[_loc5_] as BitmapComponent;
                  if((Boolean(_loc4_ = this.parent1View.creature.getAccessory(_loc5_))) && _loc4_.name.split("_",1)[0] == this.manipToAccName(param1))
                  {
                     _loc3_.colorTransformProxy.offset = 255;
                     _loc3_.controller.animateTo({"colorTransformProxy.offset":0},{"colorTransformProxy.offset":Interpolation.expoIn},true,2);
                  }
               }
            }
         }
         this.update();
      }
      
      private function clickRight(param1:uint) : void
      {
         var _loc3_:BitmapComponent = null;
         var _loc4_:Accessory = null;
         var _loc5_:String = null;
         if(this._manipulations[param1] >= MAX_MANIPS_PER_ACCESSORY)
         {
            return;
         }
         var _loc2_:Boolean = false;
         if(this._manipulations[param1] >= 0)
         {
            if(this._manipulationsLeft > 0)
            {
               --this._manipulationsLeft;
               ++this._manipulations[param1];
               _loc2_ = true;
            }
         }
         else
         {
            ++this._manipulationsLeft;
            ++this._manipulations[param1];
         }
         if(_loc2_)
         {
            if(param1 == this.MANIP_FAMILY)
            {
               _loc3_ = this.parent2View.layers["body"] as BitmapComponent;
               _loc3_.colorTransformProxy.offset = 255;
               _loc3_.controller.animateTo({"colorTransformProxy.offset":0},{"colorTransformProxy.offset":Interpolation.expoIn},true,2);
            }
            else
            {
               for(_loc5_ in this.parent1View.layers)
               {
                  _loc3_ = this.parent2View.layers[_loc5_] as BitmapComponent;
                  if((Boolean(_loc4_ = this.parent2View.creature.getAccessory(_loc5_))) && _loc4_.name.split("_",1)[0] == this.manipToAccName(param1))
                  {
                     _loc3_.colorTransformProxy.offset = 255;
                     _loc3_.controller.animateTo({"colorTransformProxy.offset":0},{"colorTransformProxy.offset":Interpolation.expoIn},true,2);
                  }
               }
            }
         }
         this.update();
      }
      
      private function hornsLeftClick(param1:MouseEvent) : void
      {
         this.clickLeft(this.MANIP_HORNS);
      }
      
      private function hornsRightClick(param1:MouseEvent) : void
      {
         this.clickRight(this.MANIP_HORNS);
      }
      
      private function wingsLeftClick(param1:MouseEvent) : void
      {
         this.clickLeft(this.MANIP_WINGS);
      }
      
      private function wingsRightClick(param1:MouseEvent) : void
      {
         this.clickRight(this.MANIP_WINGS);
      }
      
      private function dorsalLeftClick(param1:MouseEvent) : void
      {
         this.clickLeft(this.MANIP_DORSAL);
      }
      
      private function dorsalRightClick(param1:MouseEvent) : void
      {
         this.clickRight(this.MANIP_DORSAL);
      }
      
      private function tailLeftClick(param1:MouseEvent) : void
      {
         this.clickLeft(this.MANIP_TAIL);
      }
      
      private function tailRightClick(param1:MouseEvent) : void
      {
         this.clickRight(this.MANIP_TAIL);
      }
      
      private function mouthLeftClick(param1:MouseEvent) : void
      {
         this.clickLeft(this.MANIP_MOUTH);
      }
      
      private function mouthRightClick(param1:MouseEvent) : void
      {
         this.clickRight(this.MANIP_MOUTH);
      }
      
      private function clawsLeftClick(param1:MouseEvent) : void
      {
         this.clickLeft(this.MANIP_CLAWS);
      }
      
      private function clawsRightClick(param1:MouseEvent) : void
      {
         this.clickRight(this.MANIP_CLAWS);
      }
      
      private function familyLeftClick(param1:MouseEvent) : void
      {
         this.clickLeft(this.MANIP_FAMILY);
      }
      
      private function familyRightClick(param1:MouseEvent) : void
      {
         this.clickRight(this.MANIP_FAMILY);
      }
   }
}
