package com.sundaytoz.st2D.tests.LayerTransition
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.Layer;
    import com.sundaytoz.st2D.display.STSprite;
    import com.sundaytoz.st2D.display.SceneManager;
    
    import flash.events.MouseEvent;

    public class SecondScene extends Layer
    {
        public function SecondScene()
        {
            STSprite.createSpriteWithPath("res/star.png", onCreated, null, StageContext.instance.screenWidth * 0.5, StageContext.instance.screenHeight * 0.5);
                
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
            SceneManager.instance.popScene();
        }
    }
}