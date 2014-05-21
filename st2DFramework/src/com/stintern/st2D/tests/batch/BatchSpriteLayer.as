package com.stintern.st2D.tests.batch
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.utils.Vector2D;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    import flash.events.MouseEvent;
    
    public class BatchSpriteLayer extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _scheduler:Scheduler = new Scheduler();
        
        private var _sprites:Array = new Array();
        private var _translation:Number = 0.0;
        
        private var _touchCount:uint = 0;
        
        public function BatchSpriteLayer()
        {
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/demo/demo_spritesheet.png", "res/demo/demo_atlas.xml", onCreated);
            addBatchSprite(_batchSprite);
        }
        
        override public function update(dt:Number):void
        {
            for each( var sprite:Sprite in _sprites )
            {
                sprite.setTranslation( new Vector2D( (Math.sin(_translation) ) + sprite.position.x , sprite.position.y ) );    
            }
            
            _translation += 0.05;
        }
        
        private function onCreated():void
        {
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_UP, onTouch);
           
            _scheduler.addFunc(50, createStar, 0);
            _scheduler.startScheduler();
            
            function createStar():void
            {            
                var x:Number = Math.ceil(Math.random() * StageContext.instance.screenWidth);
                var y:Number = Math.ceil(Math.random() * StageContext.instance.screenHeight);
                
                var sprite:Sprite = new Sprite();
                _sprites.push(sprite);
                
                if( _sprites.length % 2 == 0 )
                {
                    sprite.createSpriteWithBatchSprite(_batchSprite, "character_run1",  x, y );    
                }
                else
                {
                    sprite.createSpriteWithBatchSprite(_batchSprite, "character_attack1",  x, y );
                }
                
                _batchSprite.addSprite(sprite);
            }
        }
                
        private function onTouch(event:MouseEvent):void
        {            

        }
        
    }
}