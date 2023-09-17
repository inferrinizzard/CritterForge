package com.edgebee.breedr.ui.world
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.NonPlayerCharacter;
   import com.edgebee.breedr.ui.npcs.AnimatedNpc;
   
   public class NpcView extends Canvas
   {
      
      private static var _frames:Object;
       
      
      private var _npc:NonPlayerCharacter;
      
      private var _expression:Number = 1;
      
      public var npcBox:Box;
      
      public var npcImg:AnimatedNpc;
      
      private var _layout:Array;
      
      public function NpcView()
      {
         var get_frame_info:Function = null;
         this._layout = [{
            "CLASS":Box,
            "ID":"npcBox",
            "percentWidth":1,
            "percentHeight":1,
            "x":UIGlobals.relativize(32),
            "horizontalAlign":Box.ALIGN_RIGHT,
            "verticalAlign":Box.ALIGN_BOTTOM,
            "CHILDREN":[{
               "CLASS":AnimatedNpc,
               "ID":"npcImg",
               "width":UIGlobals.relativize(460),
               "height":UIGlobals.relativize(690)
            }]
         }];
         super();
         mouseEnabled = false;
         if(!_frames)
         {
            get_frame_info = function(param1:String):Object
            {
               return {
                  "bmp":client.npcCache.content[param1],
                  "x":client.npcCache.content["offsets_info"][param1]["x"],
                  "y":client.npcCache.content["offsets_info"][param1]["y"]
               };
            };
            _frames = {
               "ranch1":{
                  1:{
                     "base":get_frame_info("ranch1_neutral_base"),
                     "eyes1":get_frame_info("ranch1_neutral_e1"),
                     "eyes2":get_frame_info("ranch1_neutral_e2"),
                     "eyes3":get_frame_info("ranch1_neutral_e3"),
                     "mouth1":get_frame_info("ranch1_neutral_m1"),
                     "mouth2":get_frame_info("ranch1_neutral_m2"),
                     "mouth3":get_frame_info("ranch1_neutral_m3")
                  },
                  2:{
                     "base":get_frame_info("ranch1_happy_base"),
                     "mouth1":get_frame_info("ranch1_happy_m1"),
                     "mouth2":get_frame_info("ranch1_happy_m2"),
                     "mouth3":get_frame_info("ranch1_happy_m3")
                  },
                  4:{
                     "base":get_frame_info("ranch1_sad_base"),
                     "eyes1":get_frame_info("ranch1_sad_e1"),
                     "eyes2":get_frame_info("ranch1_sad_e2"),
                     "eyes3":get_frame_info("ranch1_sad_e3"),
                     "mouth1":get_frame_info("ranch1_sad_m1"),
                     "mouth2":get_frame_info("ranch1_sad_m2"),
                     "mouth3":get_frame_info("ranch1_sad_m3")
                  }
               },
               "ranch2":{
                  1:{
                     "base":get_frame_info("ranch2_neutral_base"),
                     "eyes1":get_frame_info("ranch2_neutral_e1"),
                     "eyes2":get_frame_info("ranch2_neutral_e2"),
                     "eyes3":get_frame_info("ranch2_neutral_e3"),
                     "mouth1":get_frame_info("ranch2_neutral_m1"),
                     "mouth2":get_frame_info("ranch2_neutral_m2"),
                     "mouth3":get_frame_info("ranch2_neutral_m3")
                  },
                  4:{
                     "base":get_frame_info("ranch2_sad_base"),
                     "eyes1":get_frame_info("ranch2_sad_e1"),
                     "eyes2":get_frame_info("ranch2_sad_e2"),
                     "eyes3":get_frame_info("ranch2_sad_e3"),
                     "mouth1":get_frame_info("ranch2_sad_m1"),
                     "mouth2":get_frame_info("ranch2_sad_m2"),
                     "mouth3":get_frame_info("ranch2_sad_m3")
                  }
               },
               "shop":{
                  1:{
                     "base":get_frame_info("shop_neutral_base"),
                     "eyes1":get_frame_info("shop_neutral_e1"),
                     "eyes2":get_frame_info("shop_neutral_e2"),
                     "eyes3":get_frame_info("shop_neutral_e3"),
                     "mouth1":get_frame_info("shop_neutral_m1"),
                     "mouth2":get_frame_info("shop_neutral_m2"),
                     "mouth3":get_frame_info("shop_neutral_m3")
                  },
                  2:{
                     "base":get_frame_info("shop_happy_base"),
                     "eyes1":get_frame_info("shop_happy_e1"),
                     "eyes2":get_frame_info("shop_happy_e2"),
                     "eyes3":get_frame_info("shop_happy_e3"),
                     "mouth1":get_frame_info("shop_happy_m1"),
                     "mouth2":get_frame_info("shop_happy_m2"),
                     "mouth3":get_frame_info("shop_happy_m3")
                  }
               },
               "arena":{1:{
                  "base":get_frame_info("arena_neutral_base"),
                  "mouth1":get_frame_info("arena_neutral_m1"),
                  "mouth2":get_frame_info("arena_neutral_m2"),
                  "mouth3":get_frame_info("arena_neutral_m3")
               }},
               "travel":{
                  1:{
                     "base":get_frame_info("travel_neutral_base"),
                     "eyes1":get_frame_info("travel_neutral_e1"),
                     "eyes2":get_frame_info("travel_neutral_e2"),
                     "eyes3":get_frame_info("travel_neutral_e3"),
                     "mouth1":get_frame_info("travel_neutral_m1"),
                     "mouth2":get_frame_info("travel_neutral_m2"),
                     "mouth3":get_frame_info("travel_neutral_m3")
                  },
                  2:{
                     "base":get_frame_info("travel_happy_base"),
                     "mouth1":get_frame_info("travel_happy_m1"),
                     "mouth2":get_frame_info("travel_happy_m2"),
                     "mouth3":get_frame_info("travel_happy_m3")
                  }
               },
               "auction":{
                  1:{
                     "base":get_frame_info("auction_neutral_base"),
                     "eyes1":get_frame_info("auction_neutral_e1"),
                     "eyes2":get_frame_info("auction_neutral_e2"),
                     "eyes3":get_frame_info("auction_neutral_e3"),
                     "mouth1":get_frame_info("auction_neutral_m1"),
                     "mouth2":get_frame_info("auction_neutral_m2"),
                     "mouth3":get_frame_info("auction_neutral_m3")
                  },
                  2:{
                     "base":get_frame_info("auction_happy_base"),
                     "eyes1":get_frame_info("auction_happy_e1"),
                     "eyes2":get_frame_info("auction_happy_e2"),
                     "eyes3":get_frame_info("auction_happy_e3"),
                     "mouth1":get_frame_info("auction_happy_m1"),
                     "mouth2":get_frame_info("auction_happy_m2"),
                     "mouth3":get_frame_info("auction_happy_m3")
                  },
                  8:{
                     "offset_x":-66,
                     "base":get_frame_info("auction_angry_base"),
                     "mouth1":get_frame_info("auction_angry_m1"),
                     "mouth2":get_frame_info("auction_angry_m2"),
                     "mouth3":get_frame_info("auction_angry_m3")
                  }
               },
               "quest":{
                  1:{
                     "base":get_frame_info("quest_neutral_base"),
                     "eyes1":get_frame_info("quest_neutral_e1"),
                     "eyes2":get_frame_info("quest_neutral_e2"),
                     "eyes3":get_frame_info("quest_neutral_e3"),
                     "mouth1":get_frame_info("quest_neutral_m1"),
                     "mouth2":get_frame_info("quest_neutral_m2"),
                     "mouth3":get_frame_info("quest_neutral_m3")
                  },
                  2:{
                     "base":get_frame_info("quest_happy_base"),
                     "mouth1":get_frame_info("quest_happy_m1"),
                     "mouth2":get_frame_info("quest_happy_m2"),
                     "mouth3":get_frame_info("quest_happy_m3")
                  },
                  8:{
                     "base":get_frame_info("quest_angry_base"),
                     "eyes1":get_frame_info("quest_angry_e1"),
                     "eyes2":get_frame_info("quest_angry_e2"),
                     "eyes3":get_frame_info("quest_angry_e3"),
                     "mouth1":get_frame_info("quest_angry_m1"),
                     "mouth2":get_frame_info("quest_angry_m2"),
                     "mouth3":get_frame_info("quest_angry_m3")
                  }
               },
               "syndicate":{
                  1:{
                     "base":get_frame_info("syndicate_neutral_base"),
                     "eyes1":get_frame_info("syndicate_neutral_e1"),
                     "eyes2":get_frame_info("syndicate_neutral_e2"),
                     "eyes3":get_frame_info("syndicate_neutral_e3"),
                     "mouth1":get_frame_info("syndicate_neutral_m1"),
                     "mouth2":get_frame_info("syndicate_neutral_m2"),
                     "mouth3":get_frame_info("syndicate_neutral_m3")
                  },
                  8:{
                     "base":get_frame_info("syndicate_angry_base"),
                     "mouth1":get_frame_info("syndicate_angry_m1"),
                     "mouth2":get_frame_info("syndicate_angry_m2"),
                     "mouth3":get_frame_info("syndicate_angry_m3")
                  }
               }
            };
         }
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get npc() : NonPlayerCharacter
      {
         return this._npc;
      }
      
      public function set npc(param1:NonPlayerCharacter) : void
      {
         if(this.npc != param1)
         {
            if(this.npc)
            {
               this.npc.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onNpcChange);
            }
            this._npc = param1;
            if(this.npc)
            {
               this.npc.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onNpcChange);
            }
            this.update();
         }
      }
      
      public function get expression() : Number
      {
         return this._expression;
      }
      
      public function set expression(param1:Number) : void
      {
         if(this.expression != param1)
         {
            this._expression = param1;
            this.update();
         }
      }
      
      public function setNpcAndExpression(param1:NonPlayerCharacter, param2:Number) : void
      {
         var _loc3_:Boolean = false;
         if(this._expression != param2)
         {
            _loc3_ = true;
         }
         this._expression = param2;
         if(this.npc != param1)
         {
            this.npc = param1;
         }
         else if(_loc3_)
         {
            this.update();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         glowProxy.alpha = 1;
         glowProxy.color = 16777215;
         glowProxy.blur = 5;
         glowProxy.strength = 5;
         this.npcImg.glowProxy.alpha = 1;
         this.npcImg.glowProxy.color = 0;
         this.npcImg.glowProxy.blur = 3;
         this.npcImg.glowProxy.strength = 5;
      }
      
      private function update() : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(this.npc)
            {
               if(!_frames.hasOwnProperty(this.npc.codename))
               {
                  throw new Error("No frame data for npc with codename " + this.npc.codename);
               }
               if(!_frames[this.npc.codename].hasOwnProperty(this._expression))
               {
                  throw new Error("No frame data for expression 0x" + this._expression.toString(16) + " for npc with codename " + this.npc.codename);
               }
               this.npcImg.frames = _frames[this.npc.codename][this._expression];
               if(this.npcImg.frames.hasOwnProperty("offset_x"))
               {
                  x = UIGlobals.relativize(32) + this.npcImg.width / 512 * this.npcImg.frames.offset_x;
               }
               else
               {
                  x = UIGlobals.relativize(32);
               }
               visible = true;
            }
            else
            {
               this.npcImg.frames = null;
               visible = false;
            }
         }
      }
      
      private function onNpcChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
   }
}
