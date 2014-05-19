package com.stintern.st2D.tests.batch
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.STSprite;
    import com.stintern.st2D.utils.Vector2D;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    import flash.events.MouseEvent;
    
    public class BatchSpriteLayer extends Layer
    {
        private var batchSprite:BatchSprite;
        private var _scheduler:Scheduler = new Scheduler();
        
        private var _sprites:Array = new Array();
        private var _translation:Number = 0.0;
        
        private var _touchCount:uint = 0;
        
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
                
                var sprite:STSprite = new STSprite();
                sprite.createSpriteWithPath("res/star.png", onSpriteCreated, null, x, y);
            }
        }
        
        override public function update(dt:Number):void
        {
            for each( var sprite:STSprite in _sprites)
            {
                sprite.setTranslation( new Vector2D( (Math.sin(_translation) ) + sprite.position.x , sprite.position.y ) );    
            }
            
            _translation += 0.05;
        }
        
        private function onCreated():void
        {
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_UP, onTouch);
        }
                
        private function onTouch(event:MouseEvent):void
        {            
            if( _touchCount > 0 )
            {
                SceneManager.instance.popScene();
                StageContext.instance.stage.removeEventListener(MouseEvent.MOUSE_UP, onTouch);
                return;
            }
            
            _scheduler.stopScheduler();
            _touchCount++;
        }
        
        private function onSpriteCreated(sprite:STSprite):void
        {
            batchSprite.addSprite(sprite);
            _sprites.push(sprite);
        }
        
    }
}