package com.stintern.st2D.tests.camera
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.utils.Vector2D;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    import flash.events.MouseEvent;
    
    public class FirstLayer extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _scheduler:Scheduler = new Scheduler();
        
        private var _sprites:Array = new Array();
        private var _translation:Number = 0.0;
        
        private var _touchCount:uint = 0;
        
        public function FirstLayer()
        {
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/atlas.png", "res/atlas.xml", onCreated);
            addBatchSprite(_batchSprite);
        }
        
        override public function update(dt:Number):void
        {
            for each( var sprite:Sprite in _sprites )
            {
                sprite.setTranslation( new Vector2D( (Math.sin(_translation) ) + sprite.position.x , sprite.position.y ) );    
            }
            
            _translation += 0.05;
            
            StageContext.instance.mainCamera.moveCamera( _translation, 0);
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
                
                sprite.createSpriteWithBatchSprite(_batchSprite, "fire4", onSpriteCreated, x, y );    
            }
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
        
        private function onSpriteCreated():void
        {
            _batchSprite.addSprite(_sprites[_sprites.length-1]);
        }
        
    }
}