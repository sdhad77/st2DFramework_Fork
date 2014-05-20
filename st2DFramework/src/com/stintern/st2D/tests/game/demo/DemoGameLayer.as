package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.Scene;
    import com.stintern.st2D.display.SceneManager;
    
    import flash.events.MouseEvent;
    
    public class DemoGameLayer extends Layer
    {
        public function DemoGameLayer()
        {
            AnimationData.instance.setAnimationData("res/dungGame.png", "res/atlas.xml", null);
            AnimationData.instance.setAnimation("res/dungGame.png", new Animation("char",  new Array("char0", "char1"),  8, "char"));
            
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
            // 이곳에 맨 처음으로 사용할 레이어를 부릅니다.
            var backGroundLayer:BackGroundLayer = new BackGroundLayer();
            var characterMovingLayer:CharacterMovingLayer = new CharacterMovingLayer();
            var controlLayer:ControlLayer = new ControlLayer();
            
            var scene:Scene = new Scene();
            scene.addLayer(backGroundLayer);
            scene.addLayer(characterMovingLayer);
            scene.addLayer(controlLayer);
            
            SceneManager.instance.pushScene(scene);
            
            StageContext.instance.stage.removeEventListener(MouseEvent.CLICK, onTouch);
        }
    }
}