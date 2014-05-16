package com.sundaytoz.st2D.tests.batch
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.Layer;
    import com.sundaytoz.st2D.display.STSprite;
    import com.sundaytoz.st2D.display.batch.BatchSprite;
    
    import flash.events.MouseEvent;
    
    public class BatchSpriteLayer extends Layer
    {
        private var batchSprite:BatchSprite;
        
        public function BatchSpriteLayer()
        {
            batchSprite = new BatchSprite();
            batchSprite.createBatchSpriteWithPath("res/star.png", onCreated);
            
            addBatchSprite(batchSprite);
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function onCreated():void
        {
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_UP, onTouch);
            
            STSprite.createSpriteWithPath("res/star.png", onSpriteCreated, null, 100, 100);
            STSprite.createSpriteWithPath("res/star.png", onSpriteCreated, null, 300, 300);
            STSprite.createSpriteWithPath("res/star.png", onSpriteCreated, null, StageContext.instance.screenWidth * 0.5, StageContext.instance.screenHeight * 0.5);
        }
                
        private function onTouch(event:MouseEvent):void
        {            
            var x:Number = Math.ceil(Math.random() * StageContext.instance.screenWidth);
            var y:Number = Math.ceil(Math.random() * StageContext.instance.screenHeight);
            
            trace(x, y);
            
            STSprite.createSpriteWithPath("res/star.png", onSpriteCreated, null, x, y);
        }
        
        private function onSpriteCreated(sprite:STSprite):void
        {
            batchSprite.addSprite(sprite);
        }
        

        

        
    }
}