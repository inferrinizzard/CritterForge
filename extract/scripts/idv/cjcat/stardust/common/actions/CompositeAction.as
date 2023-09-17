package idv.cjcat.stardust.common.actions
{
   import flash.events.Event;
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.events.ActionEvent;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.xml.XMLBuilder;
   import idv.cjcat.stardust.sd;
   
   public class CompositeAction extends Action implements ActionCollector
   {
       
      
      public var checkComponentMasks:Boolean;
      
      sd var actionCollection:idv.cjcat.stardust.common.actions.ActionCollection;
      
      private var activeActions:Array;
      
      public function CompositeAction()
      {
         super();
         this.checkComponentMasks = false;
         this.sd::actionCollection = new idv.cjcat.stardust.common.actions.ActionCollection();
      }
      
      override public function preUpdate(param1:Emitter, param2:Number) : void
      {
         var _loc3_:Action = null;
         this.activeActions = [];
         for each(_loc3_ in this.sd::actionCollection.sd::actions)
         {
            if(_loc3_.active)
            {
               if(_loc3_.mask)
               {
                  this.activeActions.push(_loc3_);
                  _loc3_.preUpdate(param1,param2);
               }
            }
         }
      }
      
      override public function update(param1:Emitter, param2:Particle, param3:Number) : void
      {
         var _loc4_:Action = null;
         if(this.checkComponentMasks)
         {
            for each(_loc4_ in this.activeActions)
            {
               if(_loc4_.mask & param2.mask)
               {
                  _loc4_.update(param1,param2,param3);
               }
            }
         }
         else
         {
            for each(_loc4_ in this.activeActions)
            {
               _loc4_.update(param1,param2,param3);
            }
         }
      }
      
      override public function postUpdate(param1:Emitter, param2:Number) : void
      {
         this.activeActions = null;
      }
      
      public function addAction(param1:Action) : void
      {
         this.sd::actionCollection.sd::actions.push(param1);
         param1.addEventListener(ActionEvent.PRIORITY_CHANGE,this.sortActions);
         this.sortActions();
      }
      
      public function removeAction(param1:Action) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Action = null;
         while((_loc2_ = this.sd::actionCollection.sd::actions.indexOf(param1)) >= 0)
         {
            _loc3_ = this.sd::actionCollection.sd::actions.splice(_loc2_,1)[0];
            _loc3_.removeEventListener(ActionEvent.PRIORITY_CHANGE,this.sortActions);
         }
      }
      
      public function clearActions() : void
      {
         var _loc1_:Action = null;
         for each(_loc1_ in this.sd::actionCollection.sd::actions)
         {
            this.removeAction(_loc1_);
         }
      }
      
      final public function sortActions(param1:Event = null) : void
      {
         this.sd::actionCollection.sd::actions.sortOn("priority",Array.NUMERIC | Array.DESCENDING);
      }
      
      final override public function get needsSortedParticles() : Boolean
      {
         var _loc1_:Action = null;
         for each(_loc1_ in this.sd::actionCollection.sd::actions)
         {
            if(_loc1_.needsSortedParticles)
            {
               return true;
            }
         }
         return false;
      }
      
      override public function getRelatedObjects() : Array
      {
         return this.sd::actionCollection.sd::actions.concat();
      }
      
      override public function getXMLTagName() : String
      {
         return "CompositeAction";
      }
      
      override public function toXML() : XML
      {
         var _loc2_:Action = null;
         var _loc1_:XML = super.toXML();
         if(_loc1_.@checkComponentMasks.length())
         {
            _loc1_.@checkComponentMasks = this.checkComponentMasks;
         }
         if(this.sd::actionCollection.sd::actions.length > 0)
         {
            _loc1_.appendChild(<actions/>);
            for each(_loc2_ in this.sd::actionCollection.sd::actions)
            {
               _loc1_.actions.appendChild(_loc2_.getXMLTag());
            }
         }
         return _loc1_;
      }
      
      override public function parseXML(param1:XML, param2:XMLBuilder = null) : void
      {
         var _loc3_:XML = null;
         super.parseXML(param1,param2);
         this.checkComponentMasks = param1.@checkComponentMasks == "true";
         this.clearActions();
         for each(_loc3_ in param1.actions.*)
         {
            this.addAction(Action(param2.getElementByName(_loc3_.@name)));
         }
      }
   }
}
