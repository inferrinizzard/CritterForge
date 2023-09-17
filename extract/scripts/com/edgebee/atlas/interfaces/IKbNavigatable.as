package com.edgebee.atlas.interfaces
{
   import flash.events.IEventDispatcher;
   
   public interface IKbNavigatable extends IEventDispatcher
   {
       
      
      function get hasKbFocus() : Boolean;
      
      function set hasKbFocus(param1:Boolean) : void;
      
      function get enabled() : Boolean;
      
      function set enabled(param1:Boolean) : void;
      
      function get kbFirstNode() : IKbNavigatable;
      
      function set kbFirstNode(param1:IKbNavigatable) : void;
      
      function get kbUpNode() : IKbNavigatable;
      
      function set kbUpNode(param1:IKbNavigatable) : void;
      
      function get kbDownNode() : IKbNavigatable;
      
      function set kbDownNode(param1:IKbNavigatable) : void;
      
      function get kbLeftNode() : IKbNavigatable;
      
      function set kbLeftNode(param1:IKbNavigatable) : void;
      
      function get kbRightNode() : IKbNavigatable;
      
      function set kbRightNode(param1:IKbNavigatable) : void;
      
      function get kbAnchorUpNode() : IKbNavigatable;
      
      function set kbAnchorUpNode(param1:IKbNavigatable) : void;
      
      function get kbAnchorDownNode() : IKbNavigatable;
      
      function set kbAnchorDownNode(param1:IKbNavigatable) : void;
      
      function get kbAnchorLeftNode() : IKbNavigatable;
      
      function set kbAnchorLeftNode(param1:IKbNavigatable) : void;
      
      function get kbAnchorRightNode() : IKbNavigatable;
      
      function set kbAnchorRightNode(param1:IKbNavigatable) : void;
      
      function getKbNode(param1:uint) : IKbNavigatable;
      
      function get isMetaKbNode() : Boolean;
      
      function kbLink(param1:IKbNavigatable, param2:uint, param3:Boolean = true) : void;
      
      function kbAnchor(param1:IKbNavigatable, param2:uint) : void;
      
      function kbMove(param1:uint) : IKbNavigatable;
      
      function kbActivate() : void;
   }
}
