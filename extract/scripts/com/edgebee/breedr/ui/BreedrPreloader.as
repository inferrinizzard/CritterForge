package com.edgebee.breedr.ui
{
   import com.edgebee.atlas.ui.utils.SimplePreloader;
   
   public class BreedrPreloader extends SimplePreloader
   {
      
      public static var BreedrSplashPng:Class = BreedrPreloader_BreedrSplashPng;
       
      
      public function BreedrPreloader()
      {
         super(BreedrSplashPng,"breedr_flash");
         addAssetToPreload(url + "/static/breedr/npc/npcs.swf");
         addAssetToPreload(url + "/static/breedr/creatures/bird.swf");
         addAssetToPreload(url + "/static/breedr/creatures/calamari.swf");
         addAssetToPreload(url + "/static/breedr/creatures/crocodile.swf");
         addAssetToPreload(url + "/static/breedr/creatures/crustacean.swf");
         addAssetToPreload(url + "/static/breedr/creatures/dragon.swf");
         addAssetToPreload(url + "/static/breedr/creatures/fish.swf");
         addAssetToPreload(url + "/static/breedr/creatures/gorilla.swf");
         addAssetToPreload(url + "/static/breedr/creatures/hornet.swf");
         addAssetToPreload(url + "/static/breedr/creatures/hydra.swf");
         addAssetToPreload(url + "/static/breedr/creatures/lizard.swf");
         addAssetToPreload(url + "/static/breedr/creatures/mammoth.swf");
         addAssetToPreload(url + "/static/breedr/creatures/mantis.swf");
         addAssetToPreload(url + "/static/breedr/creatures/moth.swf");
         addAssetToPreload(url + "/static/breedr/creatures/owlbear.swf");
         addAssetToPreload(url + "/static/breedr/creatures/raptor.swf");
         addAssetToPreload(url + "/static/breedr/creatures/spider.swf");
         addAssetToPreload(url + "/static/breedr/creatures/toad.swf");
         addAssetToPreload(url + "/static/breedr/creatures/tortoise.swf");
         addAssetToPreload(url + "/static/breedr/creatures/walrus.swf");
         addAssetToPreload(url + "/static/breedr/creatures/wolf.swf");
      }
   }
}
