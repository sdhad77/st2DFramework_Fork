package com.sundaytoz.st2D.tests.batch
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.Layer;
    import com.sundaytoz.st2D.display.sprite.BatchSprite;
    import com.sundaytoz.st2D.display.sprite.STSprite;
    import com.sundaytoz.st2D.utils.scheduler.Scheduler;
    
    import flash.events.MouseEvent;
    
    public class BatchSpriteLayer extends Layer
    {
        private var batchSprite:BatchSprite;
        private var _scheduler:Scheduler = new Scheduler();
        
        public function BatchSpriteLayer()
        {
            batchSprite = new BatchSprite();
            batchSprite.createBatchSpriteWithPath("res/star.png", onCreated);
            
            addBatchSprite(batchSprite);
            
            _scheduler.addFunc(200, createStar, 0);
            _scheduler.startScheduler();
            
            function createStar():void
            {            
                var x:Number = Math.ceil(Math.random() * StageContext.instance.screenWidth);
                var y:Number = Math.ceil(Math.random() * StageContext.instance.screenHeight);
                
                STSprite.createSpriteWithPath("res/star.png", onSpriteCreated, null, x, y);
            }
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function onCreated():void
        {
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_UP, onTouch);
        }
                
        private function onTouch(event:MouseEvent):void
        {            
            _scheduler.stopScheduler();
        }
        
        private function onSpriteCreated(sprite:STSprite):void
        {
            batchSprite.addSprite(sprite);
        }
        
    }
}