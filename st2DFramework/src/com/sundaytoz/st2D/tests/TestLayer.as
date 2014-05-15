package com.sundaytoz.st2D.tests
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.Layer;
    import com.sundaytoz.st2D.display.STSprite;
    import com.sundaytoz.st2D.utils.Vector2D;
    
    public class TestLayer extends Layer
    {
        private var sprite1:STSprite = new STSprite();
        private var sprite2:STSprite = new STSprite();
        
        public function TestLayer()
        {
            STSprite.createSpriteWithPath("res/test.png", onCreated);
            STSprite.createSpriteWithPath("res/star.png", onCreated2);
        }
        
        private function onCreated(sprite:STSprite):void
        {
            sprite1 = sprite;
            sprite1.position = new Vector2D(StageContext.instance.screenWidth * 0.5, StageContext.instance.screenHeight * 0.5);
            this.addSprite(sprite1);
        }
        
        private function onCreated2(sprite:STSprite):void
        {
            sprite2 = sprite;
            sprite2.position = new Vector2D(StageContext.instance.screenWidth * 0.5 + 100, StageContext.instance.screenHeight * 0.5 + 100 );
            sprite2.depth = 1;
            
            this.addSprite(sprite2);
        }
    }
}