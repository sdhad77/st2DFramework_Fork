package com.stintern.st2D.demo
{
    import com.stintern.st2D.LayerSample.CloudLayer;
    import com.stintern.st2D.LayerSample.TimeLayer;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.Scene;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.utils.AssetLoader;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    
    public class Title extends Layer
    {
        private var mc:MovieClip;
        
        public function Title()
        {
            AssetLoader.instance.loadSWF("res/background/title.swf", onLoadComplete);
            
            function onLoadComplete(object:Object, zOrder:uint):void
            {
                mc = object as MovieClip;
                
                mc.width = StageContext.instance.screenWidth;
                mc.height = StageContext.instance.screenHeight;
                StageContext.instance.stage.addChild(mc);
                
                mc.getChildAt(1).addEventListener(MouseEvent.CLICK, buttonClick);
            }
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function buttonClick(evt:MouseEvent):void
        {
            var scene:Scene = new Scene();
            SceneManager.instance.pushScene(scene);
            
            var totalAnimationLayer:Game = new Game();
            scene.addLayer(totalAnimationLayer);
            
            var cloudLayer:CloudLayer = new CloudLayer();
            scene.addLayer(cloudLayer);
            
            var timeLayer:TimeLayer = new TimeLayer();
            scene.addLayer(timeLayer);
            
            mc.getChildAt(1).removeEventListener(MouseEvent.CLICK, buttonClick);
            StageContext.instance.stage.removeChildAt(1);
        }
    }
}