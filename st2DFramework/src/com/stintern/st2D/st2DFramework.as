package com.stintern.st2D
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.DrawManager;
    import com.stintern.st2D.display.Scene;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.utils.GameStatus;
    import com.stintern.st2D.utils.GameTimer;
    
    import flash.display.Sprite;
    import flash.display.StageOrientation;
    import flash.events.Event;
    import flash.events.StageOrientationEvent;
    import com.stintern.st2D.demo.TotalAnimationLayer;
    
    public class st2DFramework extends Sprite
    {
        private var _timer:GameTimer = new GameTimer();
        private var _drawManager:DrawManager = new DrawManager();
        
        public function st2DFramework()
        {
            super();
            
            StageContext.instance.init(stage, onInited);
            stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, orientationChanging);
        }
        
        /**
         * Stage3D 를 초기화 하고 불려지는 함수입니다.  
         * 이곳에서 가장 처음으로 불려질 Scene 과 Layer 를 생성하세요.
         */
        private function onInited():void
        {
            var scene:Scene = new Scene();
            
            var testLayer:TotalAnimationLayer = new TotalAnimationLayer();
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
        
        private function orientationChanging(e:StageOrientationEvent):void {
            if (e.afterOrientation == StageOrientation.DEFAULT || e.afterOrientation == StageOrientation.UPSIDE_DOWN) {
                e.preventDefault();
            }
        }
    }
}