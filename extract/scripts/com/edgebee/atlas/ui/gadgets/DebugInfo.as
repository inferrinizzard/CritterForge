package com.edgebee.atlas.ui.gadgets
{
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Application;
   import com.edgebee.atlas.util.Timer;
   import com.edgebee.atlas.util.Utils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.system.Capabilities;
   import flash.system.System;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class DebugInfo extends TextField
   {
       
      
      public var maxFps:Number = 0;
      
      public var minFps:Number = 0;
      
      public var buildName:String = "";
      
      private var _application:Application;
      
      private var _timer:Timer;
      
      private var _runGcNotification:uint = 0;
      
      private var _lastTime:Date;
      
      private var _lastFrameTimes:Array;
      
      public function DebugInfo(param1:Application)
      {
         this._timer = new Timer(1000);
         this._lastTime = new Date();
         this._lastFrameTimes = [];
         super();
         this._application = param1;
         autoSize = TextFieldAutoSize.LEFT;
         antiAliasType = AntiAliasType.ADVANCED;
         backgroundColor = 3355443;
         background = true;
         border = true;
         borderColor = 0;
         multiline = true;
         filters = [new GlowFilter(0,0,0,0,0,0)];
         alpha = 0.05;
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.font = "Courier new";
         _loc2_.size = 8;
         _loc2_.color = 10092441;
         defaultTextFormat = _loc2_;
         selectable = false;
         doubleClickEnabled = true;
         addEventListener(MouseEvent.DOUBLE_CLICK,this.onDblClick,false,0,true);
         addEventListener(MouseEvent.ROLL_OVER,this.onRollOver,false,0,true);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut,false,0,true);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.start();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame,false,0,true);
         this.buildName = UIGlobals.root.buildVersion;
      }
      
      public function get application() : Application
      {
         return this._application;
      }
      
      public function get fps() : Number
      {
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc1_:Number = 0;
         for each(_loc2_ in this._lastFrameTimes)
         {
            _loc1_ += _loc2_;
         }
         _loc3_ = 0;
         if(this._lastFrameTimes.length > 0)
         {
            _loc3_ = _loc1_ / this._lastFrameTimes.length;
         }
         var _loc4_:Number = 0;
         if(_loc3_ > 0)
         {
            _loc4_ = 1000 / _loc3_;
         }
         if(this.maxFps == 0 || _loc4_ > this.maxFps)
         {
            this.maxFps = _loc4_;
         }
         if(this.minFps == 0 || _loc4_ < this.minFps)
         {
            this.minFps = _loc4_;
         }
         return _loc4_;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:String = "";
         if(this._runGcNotification > 0)
         {
            --this._runGcNotification;
            _loc2_ = " Forced Garbage Collection";
         }
         text = Utils.formatString("{name} ({build})\n{ptype} {version} {debug}\n{fps} [{min},{max}] | {mem} KB{n}\n{requests} reqs. avg {latency}ms",{
            "name":this.application.appName,
            "build":this.buildName,
            "ptype":Capabilities.playerType,
            "version":Capabilities.version,
            "debug":(Capabilities.isDebugger ? "(D)" : "(R)"),
            "fps":int(this.fps),
            "min":int(this.minFps),
            "max":int(this.maxFps),
            "mem":System.totalMemory / 1024,
            "n":_loc2_,
            "requests":(!!this.application.client ? this.application.client.service.statistics.requests : 0),
            "latency":(!!this.application.client ? this.application.client.service.statistics.averageLatency : 0)
         });
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Date = new Date();
         var _loc3_:uint = _loc2_.time - this._lastTime.time;
         this._lastTime = _loc2_;
         this._lastFrameTimes.push(_loc3_);
         if(this._lastFrameTimes.length > 60)
         {
            this._lastFrameTimes.shift();
         }
      }
      
      private function onDblClick(param1:MouseEvent) : void
      {
         if(this._runGcNotification == 0)
         {
            if(this.application.client)
            {
               this.application.client.service.statistics.dump();
            }
            this._runGcNotification = 4;
            System.gc();
         }
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         alpha = 0.75;
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         alpha = 0.05;
      }
   }
}
