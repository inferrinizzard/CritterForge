package idv.cjcat.stardust.common.actions
{
   import flash.geom.ColorTransform;
   import idv.cjcat.stardust.common.easing.Linear;
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.xml.XMLBuilder;
   
   public class ColorCurve extends Action
   {
       
      
      public var inColor:ColorTransform;
      
      public var outColor:ColorTransform;
      
      public var inLifespan:Number;
      
      public var outLifespan:Number;
      
      private var _inFunction:Function;
      
      private var _outFunction:Function;
      
      private var _inFunctionExtraParams:Array;
      
      private var _outFunctionExtraParams:Array;
      
      public function ColorCurve(param1:Number = 0, param2:Number = 0, param3:Function = null, param4:Function = null)
      {
         super();
         this.inColor = new ColorTransform();
         this.outColor = new ColorTransform();
         this.inLifespan = param1;
         this.outLifespan = param2;
         this.inFunction = param3;
         this.outFunction = param4;
         this.inFunctionExtraParams = [];
         this.outFunctionExtraParams = [];
      }
      
      private function interpolateColorTransforms(param1:Number, param2:ColorTransform, param3:ColorTransform, param4:Number) : ColorTransform
      {
         var _loc5_:ColorTransform;
         (_loc5_ = new ColorTransform()).redOffset = this._inFunction.apply(null,[param1,param2.redOffset,param3.redOffset - param2.redOffset,param4].concat(this._inFunctionExtraParams));
         _loc5_.greenOffset = this._inFunction.apply(null,[param1,param2.greenOffset,param3.greenOffset - param2.greenOffset,param4].concat(this._inFunctionExtraParams));
         _loc5_.blueOffset = this._inFunction.apply(null,[param1,param2.blueOffset,param3.blueOffset - param2.blueOffset,param4].concat(this._inFunctionExtraParams));
         _loc5_.alphaOffset = this._inFunction.apply(null,[param1,param2.alphaOffset,param3.alphaOffset - param2.alphaOffset,param4].concat(this._inFunctionExtraParams));
         _loc5_.redMultiplier = this._inFunction.apply(null,[param1,param2.redMultiplier,param3.redMultiplier - param2.redMultiplier,param4].concat(this._inFunctionExtraParams));
         _loc5_.greenMultiplier = this._inFunction.apply(null,[param1,param2.greenMultiplier,param3.greenMultiplier - param2.greenMultiplier,param4].concat(this._inFunctionExtraParams));
         _loc5_.blueMultiplier = this._inFunction.apply(null,[param1,param2.blueMultiplier,param3.blueMultiplier - param2.blueMultiplier,param4].concat(this._inFunctionExtraParams));
         _loc5_.alphaMultiplier = this._inFunction.apply(null,[param1,param2.alphaMultiplier,param3.alphaMultiplier - param2.alphaMultiplier,param4].concat(this._inFunctionExtraParams));
         return _loc5_;
      }
      
      override public function update(param1:Emitter, param2:Particle, param3:Number) : void
      {
         if(param2.initLife - param2.life < this.inLifespan)
         {
            param2.colorTransform = this.interpolateColorTransforms(param2.initLife - param2.life,this.inColor,param2.initColorTransform,this.inLifespan);
         }
         else if(param2.life < this.outLifespan)
         {
            param2.colorTransform = this.interpolateColorTransforms(this.outLifespan - param2.life,param2.initColorTransform,this.outColor,this.outLifespan);
         }
         else
         {
            param2.colorTransform = param2.initColorTransform;
         }
      }
      
      public function get inFunctionExtraParams() : Array
      {
         return this._inFunctionExtraParams;
      }
      
      public function set inFunctionExtraParams(param1:Array) : void
      {
         if(!param1)
         {
            param1 = [];
         }
         this._inFunctionExtraParams = param1;
      }
      
      public function get outFunctionExtraParams() : Array
      {
         return this._outFunctionExtraParams;
      }
      
      public function set outFunctionExtraParams(param1:Array) : void
      {
         if(!param1)
         {
            param1 = [];
         }
         this._outFunctionExtraParams = param1;
      }
      
      public function get inFunction() : Function
      {
         return this._inFunction;
      }
      
      public function set inFunction(param1:Function) : void
      {
         if(param1 == null)
         {
            param1 = Linear.easeIn;
         }
         this._inFunction = param1;
      }
      
      public function get outFunction() : Function
      {
         return this._outFunction;
      }
      
      public function set outFunction(param1:Function) : void
      {
         if(param1 == null)
         {
            param1 = Linear.easeOut;
         }
         this._outFunction = param1;
      }
      
      override public function getXMLTagName() : String
      {
         return "ColorCurve";
      }
      
      override public function toXML() : XML
      {
         return super.toXML();
      }
      
      override public function parseXML(param1:XML, param2:XMLBuilder = null) : void
      {
         super.parseXML(param1,param2);
      }
   }
}
