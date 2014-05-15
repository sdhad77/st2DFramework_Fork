package com.sundaytoz.st2D
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.Scene;
    import com.sundaytoz.st2D.display.SceneManager;
    import com.sundaytoz.st2D.tests.TestLayer;
    
    import flash.display.Sprite;
    import flash.events.Event;
    
    public class st2DFramework extends Sprite
    {
        public function st2DFramework()
        {
            super();
            
            StageContext.instance.init(stage, onInited);
        }
        
        private function onInited():void
        {
            // 이곳에 맨 처음으로 사용할 레이어를 부릅니다.
            var testLayer:TestLayer = new TestLayer();

            var scene:Scene = new Scene();
            scene.addLayer(testLayer);
            SceneManager.instance.pushScene(scene);
            
            addEventListener(Event.ENTER_FRAME, enterFrame);
        }
        
        private function enterFrame(e:Event):void 
        {
            update();
            
            draw();
        }
        
        private function update():void
        {
            SceneManager.instance.getCurrentScene().updateAllLayers();
        }
        
        private function draw():void
        {
            StageContext.instance.draw();
        }
        
    }
}