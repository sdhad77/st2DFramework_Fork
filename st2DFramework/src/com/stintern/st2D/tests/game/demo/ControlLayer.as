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
    
    public class ControlLayer extends Layer
    {
        private var _batchSprite:BatchSprite;
        
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
            _batchSprite.createBatchSpriteWithPath("res/demo/demo_spritesheet.png", "res/demo/demo_atlas.xml", onCreatedButton);
            addBatchSprite(_batchSprite);
            
            
            _enemyScheduler.addFunc(2000, enemyCreater, 1);
            _enemyScheduler.startScheduler();
            
            function enemyCreater():void
            {
                var playerCharacterObject:CharacterObject = new CharacterObject("character3_run_left", "character3_attack_left", 1000, 30, 10000, 3000, 200, 300, false);
                _enemyCharacterArray.push(playerCharacterObject);
            }
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
        

        
        private function onCreatedButton():void
        {
            var sprite:Sprite = new Sprite();
            var x:Number = 0;
            var y:Number = 0;
            sprite.createSpriteWithBatchSprite(_batchSprite, "character1_run_right0", x, y );
            sprite.setScaleWithWidthHeight(StageContext.instance.screenHeight/8, StageContext.instance.screenHeight/8);
            sprite.position.x = _MARGIN + sprite.width / 2 * sprite.scale.x;
            sprite.position.y = StageContext.instance.screenHeight - _MARGIN - sprite.height / 2 * sprite.scale.y;
            _batchSprite.addSprite(sprite);
            x = sprite.position.x + StageContext.instance.screenHeight/8;
            y = sprite.position.y;
            
            sprite = new Sprite();
            sprite.createSpriteWithBatchSprite(_batchSprite, "character2_run_right0", x, y );
            sprite.setScaleWithWidthHeight(StageContext.instance.screenHeight/8, StageContext.instance.screenHeight/8);
            sprite.position.x = x;
            sprite.position.y = y;
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
                            playerCharacter.sprite.setPlayAnimation(playerCharacter.attAniStr);
                            playerCharacter.info.state = CharacterObject.ATTACK;
                            playerCharacter.sprite.isMoving = false;
                            playerCharacter.targetObject = _enemyCharacterArray[j];
                            playerCharacter.attackScheduler.startScheduler();
                        }
                        if(enemyCharacter.info.state != CharacterObject.ATTACK)
                        {
                            enemyCharacter.sprite.setPlayAnimation(enemyCharacter.attAniStr);
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
                    var characterObject1:CharacterObject = new CharacterObject("character1_run_right", "character1_attack", 100, 40, 10000, 2000, 300, 400, true);
                    _playerCharacterArray.push(characterObject1);
                }
            }
            else if( _MARGIN +  StageContext.instance.screenHeight/8 < event.stageX && event.stageX < _MARGIN +  StageContext.instance.screenHeight/8*2)
            {
                if( _MARGIN < event.stageY && event.stageY < _MARGIN +  StageContext.instance.screenHeight/8)
                {
                    var characterObject2:CharacterObject = new CharacterObject("character2_run_right", "character2_attack_right", 100, 40, 10000, 2000, 300, 400, true);
                    _playerCharacterArray.push(characterObject2);
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
            for(var j:uint = 0; j < _timeLayer.batchSprite.spriteArray.length; j++)             //Camera 이동시 TimeLayer 고정을 위한 처리
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
            
            for(var i:uint = 0; i < _batchSprite.spriteArray.length; i++)                       //Camera 이동시 ControlLayer 고정을 위한 처리
            {
                var controlSprite:Sprite = _batchSprite.spriteArray[i] as Sprite;
                if(-(StageContext.instance.screenWidth/2) < StageContext.instance.mainCamera.x)
                {
                    controlSprite.position.x += (StageContext.instance.mainCamera.x + (StageContext.instance.screenWidth/2));
                }
                else if(StageContext.instance.mainCamera.x < -((StageContext.instance.screenWidth*_backGroundLayer.bgPageNum) - (StageContext.instance.screenWidth/2)))
                {
                    controlSprite.position.x += (StageContext.instance.mainCamera.x + (StageContext.instance.screenWidth*_backGroundLayer.bgPageNum) - (StageContext.instance.screenWidth/2));
                }
            }
            
            if(-(StageContext.instance.screenWidth/2) < StageContext.instance.mainCamera.x)     //Camera 이동 처리
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
