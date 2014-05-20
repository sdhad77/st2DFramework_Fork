package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.utils.Vector2D;
    
    import flash.events.MouseEvent;
    
    public class ControlLayer extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _sprites:Array = new Array();
        
        private var mouseDownFlag:Boolean = false;
        private var prevPoint:Vector2D;
        private var _backGroundLayer:BackGroundLayer;
        private static const _MARGIN:uint = 20;
        
        public function ControlLayer()
        {
            _backGroundLayer = SceneManager.instance.getCurrentScene().getLayerByName("BackGroundLayer") as BackGroundLayer;
            
            
            
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/dungGame.png", "res/atlas.xml", onCreated);
            addBatchSprite(_batchSprite);
            
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
        
        private function onCreated():void
        {
            var sprite:Sprite = new Sprite();
            _sprites.push(sprite);
            var x:Number = 0;
            var y:Number = 0;
            sprite.createSpriteWithBatchSprite(_batchSprite, "char0", onSpriteCreated, x, y );
            sprite.setScaleWithWidthHeight(StageContext.instance.screenHeight/8, StageContext.instance.screenHeight/8);
            sprite.position.x = _MARGIN + sprite.width/2;
            sprite.position.y = StageContext.instance.screenHeight - _MARGIN - sprite.height/2;
        }
        
        private function onSpriteCreated():void
        {
            _batchSprite.addSprite(_sprites[_sprites.length-1]);
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function onTouch(event:MouseEvent):void
        {
            trace( _MARGIN + "  :  " + event.stageX  + "  :  " +  (_MARGIN + StageContext.instance.screenHeight/8));
            trace(_MARGIN + "  :  " + event.stageY + "  :  " +  (_MARGIN +  StageContext.instance.screenHeight/8));
            if( _MARGIN < event.stageX && event.stageX < _MARGIN + StageContext.instance.screenHeight/8)
            {
                if( _MARGIN < event.stageY && event.stageY < _MARGIN +  StageContext.instance.screenHeight/8)
                {
                    var _player:CharacterObject = new CharacterObject("res/dungGame.png", 100, 100, 20, true);
                }
            }
        }
        
        private function onMouseDown(event:MouseEvent):void
        {
            mouseDownFlag = true;
            prevPoint = new Vector2D(event.stageX, event.stageY);
        }
        
        private function onMouseMove(event:MouseEvent):void
        {   
            if(mouseDownFlag)
            {
                if( -(StageContext.instance.screenWidth/2) >= StageContext.instance.mainCamera.x  && StageContext.instance.mainCamera.x >= -((StageContext.instance.screenWidth*_backGroundLayer.bgPageNum) - (StageContext.instance.screenWidth/2)))
                {
                    var intervalX:Number = event.stageX - prevPoint.x;
                    StageContext.instance.mainCamera.moveCamera(intervalX, 0.0);
                    prevPoint.x = event.stageX;
                }
            }
        }
        
        private function onMouseUp(event:MouseEvent):void
        {
            mouseDownFlag = false;
            if(-(StageContext.instance.screenWidth/2) < StageContext.instance.mainCamera.x)
            {
                StageContext.instance.mainCamera.moveCamera(-(StageContext.instance.mainCamera.x + (StageContext.instance.screenWidth/2)), 0.0) ;
            }
            else if(StageContext.instance.mainCamera.x < -((StageContext.instance.screenWidth*_backGroundLayer.bgPageNum) - (StageContext.instance.screenWidth/2)))
            {
                StageContext.instance.mainCamera.moveCamera(-(StageContext.instance.mainCamera.x + (StageContext.instance.screenWidth*_backGroundLayer.bgPageNum) - (StageContext.instance.screenWidth/2)), 0.0) ;
            }
        }
    }
}



