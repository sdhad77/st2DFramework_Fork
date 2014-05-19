package com.stintern.st2D.tests.sceneTransition
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.STSprite;
    import com.stintern.st2D.display.SceneManager;
    
    import flash.events.MouseEvent;

    public class SecondSceneLayer extends Layer
    {
        public function SecondSceneLayer()
        {
            STSprite.createSpriteWithPath("res/star.png", onCreated, null, StageContext.instance.screenWidth * 0.5, StageContext.instance.screenHeight * 0.5);
                
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
        }
        
        override public function update(dt:Number):void
        {
            
        }
        
        private function onCreated(sprite:STSprite):void
        {
            var testSprite:STSprite = sprite;
            this.addSprite(testSprite);
        }
        
        private function onTouch(event:MouseEvent):void
        {
            SceneManager.instance.popScene();
            
            StageContext.instance.stage.removeEventListener(MouseEvent.CLICK, onTouch);
        }
    }
}