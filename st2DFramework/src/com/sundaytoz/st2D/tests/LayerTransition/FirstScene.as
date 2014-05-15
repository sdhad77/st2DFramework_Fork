package com.sundaytoz.st2D.tests.LayerTransition
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.Layer;
    import com.sundaytoz.st2D.display.STSprite;
    import com.sundaytoz.st2D.display.Scene;
    import com.sundaytoz.st2D.display.SceneManager;
    
    import flash.events.MouseEvent;

    public class FirstScene extends Layer
    {
        public function FirstScene()
        {
            STSprite.createSpriteWithPath("res/test.png", onCreated, null, StageContext.instance.screenWidth * 0.5, StageContext.instance.screenHeight * 0.5);
            
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_UP, onTouch);
        }
        
        override public function update():void
        {
            
        }        
        
        private function onCreated(sprite:STSprite):void
        {
            var testSprite:STSprite = sprite;
            this.addSprite(testSprite);
        }
        
        private function onTouch(event:MouseEvent):void
        {
            // 이곳에 맨 처음으로 사용할 레이어를 부릅니다.
            var secondScene:SecondScene = new SecondScene();
            
            var scene:Scene = new Scene();
            scene.addLayer(secondScene);
            
            SceneManager.instance.pushScene(scene);
        }
    }
}