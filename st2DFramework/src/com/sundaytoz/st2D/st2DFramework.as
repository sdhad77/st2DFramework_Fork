package com.sundaytoz.st2D
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.DrawManager;
    import com.sundaytoz.st2D.display.Scene;
    import com.sundaytoz.st2D.display.SceneManager;
    import com.sundaytoz.st2D.tests.TestLayer;
    import com.sundaytoz.st2D.utils.GameStatus;
    import com.sundaytoz.st2D.utils.GameTimer;
    
    import flash.display.Sprite;
    import flash.events.Event;
    
    public class st2DFramework extends Sprite
    {
        private var _timer:GameTimer = new GameTimer();
        private var _drawManager:DrawManager = new DrawManager();
        
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
            
            addChild(GameStatus.instance.initFPS());         // FPS 출력을 원하지 않을 경우 주석 처리하십시오
        }
        
		/**
		 *	게임 메인 루프 
		 */
        private function enterFrame(e:Event):void 
        {
			//delta time 을 계산
            _timer.tick();
            
            update(_timer.deltaTime);
            
            draw();
            
			// FPS 출력을 원하지 않을 경우 주석 처리하십시오
            GameStatus.instance.update();                
            
        }
        
        private function update(dt:Number):void
        {
            SceneManager.instance.getCurrentScene().updateAllLayers(dt);
        }
        
        private function draw():void
        {
            _drawManager.draw();
        }
        
    }
}