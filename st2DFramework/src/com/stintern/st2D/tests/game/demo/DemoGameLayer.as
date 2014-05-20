package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.Scene;
    import com.stintern.st2D.display.SceneManager;
    
    import flash.events.MouseEvent;
    
    public class DemoGameLayer extends Layer
    {
        public function DemoGameLayer()
        {
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
        }
        
        override public function update(dt:Number):void
        {
        }
        
        /**
         * Demo게임의 레이어 들을 add하여 보여줍니다.
         * @param event
         * 
         */
        private function onTouch(event:MouseEvent):void
        {
            var scene:Scene = new Scene();
            SceneManager.instance.pushScene(scene);
            
            var backGroundLayer:BackGroundLayer = new BackGroundLayer();
            scene.addLayer(backGroundLayer);
            
            var characterMovingLayer:CharacterMovingLayer = new CharacterMovingLayer();
            scene.addLayer(characterMovingLayer);
            
            var controlLayer:ControlLayer = new ControlLayer();
            scene.addLayer(controlLayer);
            
            StageContext.instance.stage.removeEventListener(MouseEvent.CLICK, onTouch);
        }
    }
}