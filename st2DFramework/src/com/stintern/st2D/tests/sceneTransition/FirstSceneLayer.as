package com.stintern.st2D.tests.sceneTransition
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.display.Scene;
    import com.stintern.st2D.display.SceneManager;
    
    import flash.events.MouseEvent;

    public class FirstSceneLayer extends Layer
    {
        public function FirstSceneLayer()
        {
            Sprite.createSpriteWithPath("res/test.png", onCreated, null, StageContext.instance.screenWidth * 0.5, StageContext.instance.screenHeight * 0.5);
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
        }
        
        override public function update(dt:Number):void
        {
            
        }        
        
        private function onCreated(sprite:Sprite):void
        {
            var testSprite:Sprite = sprite;
            this.addSprite(testSprite);
        }
        
        private function onTouch(event:MouseEvent):void
        {
            // 이곳에 맨 처음으로 사용할 레이어를 부릅니다.
            var scene:Scene = new Scene();
            var secondSceneLayer:SecondSceneLayer = new SecondSceneLayer();
            scene.addLayer(secondSceneLayer);
            
            SceneManager.instance.pushScene(scene);
            
            StageContext.instance.stage.removeEventListener(MouseEvent.CLICK, onTouch);
            
        }
    }
}