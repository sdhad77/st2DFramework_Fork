package com.stintern.st2D.tests.game
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.Sprite;
    
    public class LoseLayer extends Layer
    {
        private var sprite1:Sprite = new Sprite();
        
        public function LoseLayer()
        {
            sprite1.createSpriteWithPath("res/gameover.jpg", onCreated, null, StageContext.instance.screenWidth/2, StageContext.instance.screenHeight/2);
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