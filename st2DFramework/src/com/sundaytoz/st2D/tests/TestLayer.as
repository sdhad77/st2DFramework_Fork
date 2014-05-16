package com.sundaytoz.st2D.tests
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.Layer;
    import com.sundaytoz.st2D.display.STSprite;
    import com.sundaytoz.st2D.display.Scene;
    import com.sundaytoz.st2D.display.SceneManager;
    import com.sundaytoz.st2D.tests.SceneTransition.FirstSceneLayer;
    
    import flash.events.MouseEvent;
    
    public class TestLayer extends Layer
    {
        private var sprite1:STSprite;
        private var sprite2:STSprite;
        
        public function TestLayer()
        {
            STSprite.createSpriteWithPath("res/test.png", onCreated, null, 200, 200);
            STSprite.createSpriteWithPath("res/star.png", onCreated2, null, 250, 250);
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
        }
        
        override public function update(dt:Number):void
        {
            
        }
        
        private function onCreated(sprite:STSprite):void
        {
            sprite1 = sprite;
            this.addSprite(sprite1);
        }
        
        private function onCreated2(sprite:STSprite):void
        {
            sprite2 = sprite;
            this.addSprite(sprite2);
        }
        
        private function onTouch(event:MouseEvent):void
        {
            // 이곳에 맨 처음으로 사용할 레이어를 부릅니다.
            var aniLayer:FirstSceneLayer = new FirstSceneLayer();
            
            var scene:Scene = new Scene();
            scene.addLayer(aniLayer);
            
            SceneManager.instance.pushScene(scene);
            
            StageContext.instance.stage.removeEventListener(MouseEvent.CLICK, onTouch);
        }
        
    }
}