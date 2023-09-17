package com.edgebee.breedr.data.skill
{
   public class Connector
   {
      
      public static const CONNECTOR_NONE:int = 0;
      
      public static const CONNECTOR_MALE:int = 268435456;
      
      public static const CONNECTOR_FEMALE:int = 536870912;
      
      public static const CONNECTOR_ANY_SEX:int = 1073741824;
      
      public static const CONNECTOR_SEX_MASK:int = int(4026531840);
      
      public static const CONNECTOR_TYPE_NORMAL_EFFECT:int = 16777216;
      
      public static const CONNECTOR_TYPE_ATTACK_EFFECT:int = 33554432;
      
      public static const CONNECTOR_TYPE_EFFECT_MASK:int = 251658240;
      
      public static const CONNECTOR_DAMAGE:int = 1;
      
      public static const CONNECTOR_ATTACK:int = 2;
      
      public static const CONNECTOR_BLOCK:int = 4;
      
      public static const CONNECTOR_RESTORATION:int = 8;
      
      public static const CONNECTOR_CONDITION:int = 16;
      
      public static const CONNECTOR_DISPEL:int = 32;
      
      public static const CONNECTOR_TYPE_ANY:int = 255;
      
      public static const CONNECTOR_TYPE_MASK:int = 251658495;
      
      public static const TYPE_A:int = 0;
      
      public static const TYPE_B:int = 1;
      
      public static const TYPE_C:int = 2;
      
      public static const TYPE_D:int = 3;
      
      public static const TYPE_E:int = 4;
      
      public static const TYPE_F:int = 5;
      
      public static const TYPE_G:int = 6;
      
      public static const TYPE_H:int = 7;
       
      
      protected var _connector:int;
      
      private var _types:Array;
      
      public function Connector(param1:int)
      {
         super();
         this._connector = param1;
      }
      
      public function get isValid() : Boolean
      {
         return this._connector > 0;
      }
      
      public function get isMale() : Boolean
      {
         return Boolean(this._connector & CONNECTOR_MALE);
      }
      
      public function get isFemale() : Boolean
      {
         return Boolean(this._connector & CONNECTOR_FEMALE);
      }
      
      public function get types() : Array
      {
         if(!this._types)
         {
            this._types = [];
            if(this._connector & CONNECTOR_TYPE_EFFECT_MASK)
            {
               if(this._connector & CONNECTOR_TYPE_NORMAL_EFFECT)
               {
                  this._types.push(TYPE_A);
               }
               if(this._connector & CONNECTOR_TYPE_ATTACK_EFFECT)
               {
                  this._types.push(TYPE_B);
               }
            }
            else
            {
               if(this._connector & CONNECTOR_DAMAGE)
               {
                  this._types.push(TYPE_C);
               }
               if(this._connector & CONNECTOR_ATTACK)
               {
                  this._types.push(TYPE_D);
               }
               if(this._connector & CONNECTOR_BLOCK)
               {
                  this._types.push(TYPE_E);
               }
               if(this._connector & CONNECTOR_RESTORATION)
               {
                  this._types.push(TYPE_F);
               }
               if(this._connector & CONNECTOR_CONDITION)
               {
                  this._types.push(TYPE_G);
               }
               if(this._connector & CONNECTOR_DISPEL)
               {
                  this._types.push(TYPE_H);
               }
            }
         }
         return this._types;
      }
      
      public function canConnectTo(param1:Connector) : Boolean
      {
         var _loc2_:* = this._connector & Connector.CONNECTOR_SEX_MASK;
         var _loc3_:* = param1._connector & Connector.CONNECTOR_SEX_MASK;
         var _loc4_:* = this._connector & Connector.CONNECTOR_TYPE_MASK;
         var _loc5_:* = param1._connector & Connector.CONNECTOR_TYPE_MASK;
         return this._connector != 0 && param1._connector != 0 && (_loc2_ & _loc3_) == 0 && (_loc4_ & _loc5_) != 0;
      }
      
      public function connectToWithType(param1:Connector) : uint
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         for each(_loc2_ in this.types)
         {
            for each(_loc3_ in param1.types)
            {
               if(_loc2_ == _loc3_)
               {
                  return _loc2_;
               }
            }
         }
         return 0;
      }
   }
}
