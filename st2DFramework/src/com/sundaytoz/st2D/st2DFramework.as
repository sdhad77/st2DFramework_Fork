package com.sundaytoz.st2D
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.Scene;
    import com.sundaytoz.st2D.display.SceneManager;
    import com.sundaytoz.st2D.tests.TestLayer;
    import com.sundaytoz.st2D.tests.SceneTransition.FirstSceneLayer;
    
    import flash.display.Sprite;
    import flash.events.Event;
    
    public class st2DFramework extends Sprite
    {
        public function st2DFramework()
        {
            super();
            
            StageContext.instance.init(stage, onInited);
        }
        
        /**
         * Stage3D 를 초기화 하고 불려지는 함수입니다.  
         * 이곳에서 가장 처음으로 불려질 Scene 과 Layer 를 생성하세요.
         */
        private function onInited():void
        {
            var scene:Scene = new Scene();
            
            var testLayer:TestLayer = new TestLayer();
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