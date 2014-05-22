package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.utils.Vector2D;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    
    public class ControlLayer extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _sprites:Array = new Array();
        
        private var mouseDownFlag:Boolean = false;
        private var prevPoint:Vector2D;
        
        private var _backGroundLayer:BackGroundLayer;
        private var _characterMovingLayer:CharacterMovingLayer;
        private var _timeLayer:TimeLayer;
        
        private var _playerCharacterArray:Array;
        private var _enemyCharacterArray:Array;
        
        private var _enemyScheduler:Scheduler = new Scheduler;
        
        private static const _MARGIN:uint = 20;
        
        
        
        public function ControlLayer()
        {
            this.name = "ControlLayer";
            _backGroundLayer = SceneManager.instance.getCurrentScene().getLayerByName("BackGroundLayer") as BackGroundLayer;
            _characterMovingLayer = SceneManager.instance.getCurrentScene().getLayerByName("CharacterMovingLayer") as CharacterMovingLayer;
            _timeLayer = SceneManager.instance.getCurrentScene().getLayerByName("TimeLayer") as TimeLayer;
            
            
            
            _playerCharacterArray = _characterMovingLayer.playerCharacterArray;
            _enemyCharacterArray = _characterMovingLayer.enemyCharacterArray;
            
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/demo/demo_spritesheet.png", "res/demo/demo_atlas.xml", onCreated);
            addBatchSprite(_batchSprite);
            
            
            _enemyScheduler.addFunc(2000, enemyCreater, 1);
            _enemyScheduler.startScheduler();
            
            function enemyCreater():void
            {
                var playerCharacterObject:CharacterObject = new CharacterObject("res/demo/demo_spritesheet.png", 1000, 30, 10000, 3000, false);
                _enemyCharacterArray.push(playerCharacterObject);
            }
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
        
        public function removePlayerCharacterObject(targetObject:CharacterObject):void
        {
            for(var i:uint=0; i<_playerCharacterArray.length; ++i)
            {
                if( _playerCharacterArray[i] == targetObject )
                {
                    var playerCharacter:CharacterObject = _playerCharacterArray[i];
                    for(var j:uint=0; j<playerCharacter.sprite.getAllChildren().length; j++)
                    {
                        var childArray:Array = playerCharacter.sprite.getAllChildren();
                        var child:Sprite = childArray[j];
                        _characterMovingLayer.batchSprite.removeSprite(child);
                        child.dispose();
                    }
                    _playerCharacterArray.splice(i, 1);
                    break;
                }
            }
        }
        
        public function removeEnemyCharacterObject(targetObject:CharacterObject):void
        {
            for(var i:uint=0; i<_enemyCharacterArray.length; ++i)
            {
                if( _enemyCharacterArray[i] == targetObject )
                {
                    var enemyCharacter:CharacterObject = _enemyCharacterArray[i];
                    for(var j:uint=0; j<enemyCharacter.sprite.getAllChildren().length; j++)
                    {
                        var childArray:Array = enemyCharacter.sprite.getAllChildren();
                        var child:Sprite = childArray[j];
                        _characterMovingLayer.batchSprite.removeSprite(child);
                        child.dispose();
                    }
                    _enemyCharacterArray.splice(i, 1);
                    break;
                }
            }
        }
        
        private function onCreated():void
        {
            var sprite:Sprite = new Sprite();
            _sprites.push(sprite);
            var x:Number = 0;
            var y:Number = 0;
            sprite.createSpriteWithBatchSprite(_batchSprite, "character1_run_right0", x, y );
            sprite.setScaleWithWidthHeight(StageContext.instance.screenHeight/8, StageContext.instance.screenHeight/8);
            sprite.position.x = _MARGIN + sprite.width / 2 * sprite.scale.x;
            sprite.position.y = StageContext.instance.screenHeight - _MARGIN - sprite.height / 2 * sprite.scale.y;
            _batchSprite.addSprite(sprite);
        }
        
        override public function update(dt:Number):void
        {
            if( _batchSprite.imageLoaded == false )
                return;
            
            for(var i:uint=0; i<_playerCharacterArray.length; i++)
            {
                for(var j:uint=0; j<_enemyCharacterArray.length; j++)
                {
                    var playerCharacter:CharacterObject = _playerCharacterArray[i] as CharacterObject;
                    var enemyCharacter:CharacterObject = _enemyCharacterArray[j] as CharacterObject;
                    if(playerCharacter.sprite.collisionCheck(enemyCharacter.sprite))
                    {
                        
                        if(playerCharacter.info.state != CharacterObject.ATTACK)
                        {
                            playerCharacter.sprite.setPlayAnimation("character1_attack");
                            playerCharacter.info.state = CharacterObject.ATTACK;
                            playerCharacter.sprite.isMoving = false;
                            playerCharacter.targetObject = _enemyCharacterArray[j];
                            playerCharacter.attackScheduler.startScheduler();
                        }
                        if(enemyCharacter.info.state != CharacterObject.ATTACK)
                        {
                            enemyCharacter.sprite.setPlayAnimation("character3_attack_left");
                            enemyCharacter.info.state = CharacterObject.ATTACK;
                            enemyCharacter.sprite.isMoving = false;
                            enemyCharacter.targetObject = _playerCharacterArray[i];
                            enemyCharacter.attackScheduler.startScheduler();
                        }
                        if(playerCharacter.info.state == CharacterObject.ATTACK)
                        {
                            playerCharacter.hpProgress.updateProgress(playerCharacter.info.hp);
                        }
                        if(enemyCharacter.info.state == CharacterObject.ATTACK)
                        {
                            enemyCharacter.hpProgress.updateProgress(enemyCharacter.info.hp);
                        }
                    }
                }
            }
        }
        

        private function onTouch(event:MouseEvent):void
        {
            if( _MARGIN < event.stageX && event.stageX < _MARGIN + StageContext.instance.screenHeight/8)
            {
                if( _MARGIN < event.stageY && event.stageY < _MARGIN +  StageContext.instance.screenHeight/8)
                {
                    var playerCharacterObject:CharacterObject = new CharacterObject("res/demo/demo_spritesheet.png", 100, 40, 10000, 2000, true);
                    _playerCharacterArray.push(playerCharacterObject);
                }
            }
        }
        
        private function onMouseDown(event:MouseEvent):void
        {
            mouseDownFlag = true;
            prevPoint = new Vector2D(event.stageX, event.stageY);
        }
        private var intervalX:Number;
        private function onMouseMove(event:MouseEvent):void
        {   
            if(mouseDownFlag)
            {
                if( -(StageContext.instance.screenWidth/2) >= StageContext.instance.mainCamera.x  && StageContext.instance.mainCamera.x >= -((StageContext.instance.screenWidth*_backGroundLayer.bgPageNum) - (StageContext.instance.screenWidth/2)))
                {
                    intervalX = event.stageX - prevPoint.x;
                    StageContext.instance.mainCamera.moveCamera(intervalX, 0.0);
                    prevPoint.x = event.stageX;
                    
                    for(var i:uint = 0; i < _batchSprite.spriteArray.length; i++)
                    {
                        var controlSprite:Sprite = _batchSprite.spriteArray[i] as Sprite;
                        controlSprite.position.x -= intervalX;
                    }
                    
                    for(var j:uint = 0; j < _timeLayer.batchSprite.spriteArray.length; j++)
                    {
                        var controlTimeSprite:Sprite = _timeLayer.batchSprite.spriteArray[j] as Sprite;
                        controlTimeSprite.position.x -= intervalX;
                    }
                }
            }
        }
        
        private function onMouseUp(event:MouseEvent):void
        {
            mouseDownFlag = false;
            for(var j:uint = 0; j < _timeLayer.batchSprite.spriteArray.length; j++)
            {
                var controlTimeSprite:Sprite = _timeLayer.batchSprite.spriteArray[j] as Sprite;
                if(-(StageContext.instance.screenWidth/2) < StageContext.instance.mainCamera.x)
                {
                    controlTimeSprite.position.x += (StageContext.instance.mainCamera.x + (StageContext.instance.screenWidth/2));
                }
                else if(StageContext.instance.mainCamera.x < -((StageContext.instance.screenWidth*_backGroundLayer.bgPageNum) - (StageContext.instance.screenWidth/2)))
                {
                    controlTimeSprite.position.x += (StageContext.instance.mainCamera.x + (StageContext.instance.screenWidth*_backGroundLayer.bgPageNum) - (StageContext.instance.screenWidth/2));
                }
            }
            
            for(var i:uint = 0; i < _batchSprite.spriteArray.length; i++)
            {
                var controlSprite:Sprite = _batchSprite.spriteArray[i] as Sprite;
                if(-(StageContext.instance.screenWidth/2) < StageContext.instance.mainCamera.x)
                {
                    controlSprite.position.x += (StageContext.instance.mainCamera.x + (StageContext.instance.screenWidth/2));
                    StageContext.instance.mainCamera.moveCamera(-(StageContext.instance.mainCamera.x + (StageContext.instance.screenWidth/2)), 0.0) ;
                }
                else if(StageContext.instance.mainCamera.x < -((StageContext.instance.screenWidth*_backGroundLayer.bgPageNum) - (StageContext.instance.screenWidth/2)))
                {
                    controlSprite.position.x += (StageContext.instance.mainCamera.x + (StageContext.instance.screenWidth*_backGroundLayer.bgPageNum) - (StageContext.instance.screenWidth/2));
                    StageContext.instance.mainCamera.moveCamera(-(StageContext.instance.mainCamera.x + (StageContext.instance.screenWidth*_backGroundLayer.bgPageNum) - (StageContext.instance.screenWidth/2)), 0.0) ;
                }
            }
        }
        
    }
}
