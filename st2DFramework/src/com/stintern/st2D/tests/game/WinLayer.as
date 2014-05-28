package com.stintern.st2D.tests.game
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.Sprite;
    
    public class WinLayer extends Layer
    {
        private var sprite1:Sprite = new Sprite();
        
        public function WinLayer()
        {
            sprite1.createSpriteWithPath("res/youwin.jpg", onCreated, null, StageContext.instance.screenWidth/2, StageContext.instance.screenHeight/2);
            StageContext.instance.mainCamera.moveCamera(-StageContext.instance.mainCamera.x - StageContext.instance.screenWidth/2, 0);
        }
        
        override public function update(dt:Number):void
        {
            
        }
        
        private function onCreated():void
        {
            this.addSprite(sprite1);
        }
    }
}