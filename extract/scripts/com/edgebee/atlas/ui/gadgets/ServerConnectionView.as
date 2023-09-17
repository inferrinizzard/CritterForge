package com.edgebee.atlas.ui.gadgets
{
   import com.edgebee.atlas.net.ServerConnection;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.ProgressBar;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import flash.events.Event;
   
   public class ServerConnectionView extends Box
   {
      
      public static const ConnectIconPng:Class = ServerConnectionView_ConnectIconPng;
      
      public static const DisconnectIconPng:Class = ServerConnectionView_DisconnectIconPng;
      
      public static const TransferIconPng:Class = ServerConnectionView_TransferIconPng;
      
      public static const CompleteIconPng:Class = ServerConnectionView_CompleteIconPng;
      
      public static const IncompleteIconPng:Class = ServerConnectionView_IncompleteIconPng;
       
      
      private var _connection:WeakReference;
      
      public var disconnectBmp:BitmapComponent;
      
      public var connectBmp:BitmapComponent;
      
      public var transferBmp:BitmapComponent;
      
      public var completeBmp:BitmapComponent;
      
      public var incompleteBmp:BitmapComponent;
      
      public var progressBar:ProgressBar;
      
      public var retriesLbl:Label;
      
      public var methodLbl:Label;
      
      private var _layout:Array;
      
      public function ServerConnectionView()
      {
         this._connection = new WeakReference(null,ServerConnection);
         this._layout = [{
            "CLASS":BitmapComponent,
            "ID":"disconnectBmp",
            "percentHeight":1,
            "isSquare":true,
            "source":DisconnectIconPng
         },{
            "CLASS":BitmapComponent,
            "ID":"connectBmp",
            "percentHeight":1,
            "isSquare":true,
            "source":ConnectIconPng
         },{
            "CLASS":BitmapComponent,
            "ID":"transferBmp",
            "percentHeight":1,
            "isSquare":true,
            "source":TransferIconPng
         },{
            "CLASS":BitmapComponent,
            "ID":"completeBmp",
            "percentHeight":1,
            "isSquare":true,
            "source":CompleteIconPng
         },{
            "CLASS":BitmapComponent,
            "ID":"incompleteBmp",
            "percentHeight":1,
            "isSquare":true,
            "source":IncompleteIconPng
         },{
            "CLASS":ProgressBar,
            "ID":"progressBar",
            "percentWidth":0.5,
            "percentHeight":0.75
         },{
            "CLASS":Label,
            "ID":"retriesLbl"
         },{
            "CLASS":Label,
            "ID":"methodLbl",
            "percentWidth":0.5
         }];
         super(Box.HORIZONTAL,Box.ALIGN_LEFT,Box.ALIGN_MIDDLE);
      }
      
      public function get connection() : ServerConnection
      {
         return this._connection.get() as ServerConnection;
      }
      
      public function set connection(param1:ServerConnection) : void
      {
         if(param1 != this.connection)
         {
            if(this.connection)
            {
               this.connection.removeEventListener(ServerConnection.STATE_CHANGED,this.onStateChanged);
            }
            this._connection.reset(param1);
            if(this.connection)
            {
               this.connection.addEventListener(ServerConnection.STATE_CHANGED,this.onStateChanged);
            }
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.retriesLbl.setStyle("FontSize",getStyle("FontSize"));
         this.methodLbl.setStyle("FontSize",getStyle("FontSize"));
         this.onStateChanged(null);
      }
      
      private function onStateChanged(param1:Event) : void
      {
         this.disconnectBmp.colorMatrix.saturation = -100;
         this.disconnectBmp.alpha = 0.35;
         this.connectBmp.colorMatrix.saturation = -100;
         this.connectBmp.alpha = 0.35;
         this.transferBmp.colorMatrix.saturation = -100;
         this.transferBmp.alpha = 0.35;
         this.completeBmp.colorMatrix.saturation = -100;
         this.completeBmp.alpha = 0.35;
         this.incompleteBmp.colorMatrix.saturation = -100;
         this.incompleteBmp.alpha = 0.5;
         this.progressBar.setValueAndMaximum(0,1);
         visible = this.connection.busy;
         if(this.connection.busy)
         {
            if(this.connection.retries > 0)
            {
               this.retriesLbl.text = this.connection.retries.toString();
            }
            else
            {
               this.retriesLbl.text = "";
            }
            this.methodLbl.text = this.connection.sentData["method"].replace(/([A-Z])/g," $1");
         }
         else
         {
            this.methodLbl.text = "";
            this.retriesLbl.text = "";
         }
         switch(this.connection.state)
         {
            case ServerConnection.STATE_DISCONNECTED:
               this.disconnectBmp.colorMatrix.saturation = 0;
               this.disconnectBmp.alpha = 1;
               break;
            case ServerConnection.STATE_CONNECTED:
               this.connectBmp.colorMatrix.saturation = 0;
               this.connectBmp.alpha = 1;
               break;
            case ServerConnection.STATE_TRANSFERING:
               this.transferBmp.colorMatrix.saturation = 0;
               this.transferBmp.alpha = 1;
               this.progressBar.setValueAndMaximum(this.connection.savedBytesLoaded,this.connection.savedBytesTotal);
               break;
            case ServerConnection.STATE_COMPLETED:
               this.completeBmp.colorMatrix.saturation = 0;
               this.completeBmp.alpha = 1;
               this.progressBar.setValueAndMaximum(1,1);
               break;
            case ServerConnection.STATE_ERROR:
               this.incompleteBmp.colorMatrix.saturation = 0;
               this.incompleteBmp.alpha = 1;
         }
      }
   }
}
