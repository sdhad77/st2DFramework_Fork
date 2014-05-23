package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.ProgressBar;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.tests.game.demo.utils.Resources;
    import com.stintern.st2D.utils.Vector2D;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    
    public class ControlLayer extends Layer
    {
        private var _batchSprite:BatchSprite;
        
        private var mouseDownFlag:Boolean = false;
        private var prevPoint:Vector2D;
        
        private var _cashData:uint;
        private var _currentCash:uint = 0;
        private var _cashBarBg:Sprite;
        private var _cashBarFront:Sprite;
        private var _cashBarProgress:ProgressBar = new ProgressBar();
        
        private var _backGroundLayer:BackGroundLayer;
        private var _characterMovingLayer:CharacterMovingLayer;
        private var _timeLayer:TimeLayer;
        
        private var _playerCharacterArray:Array;
        private var _enemyCharacterArray:Array;
        
        private var _enemyScheduler:Scheduler = new Scheduler;
        
        private var intervalX:Number;
        
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
            
            _enemyScheduler.addFunc(2000, enemyCreater, 10);
            _enemyScheduler.startScheduler();
            
            function enemyCreater():void
            {
                _enemyCharacterArray.push(new CharacterObject("character3_run_left", "character3_attack_left", 1000, 30, 10000, 3000, Resources.TAG_GREEN, false));
            }
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
        
        private function onCreatedButton():void
        {
            var sprite:Sprite = new Sprite();
            sprite.createSpriteWithBatchSprite(_batchSprite, "character2_btn");
            sprite.setScaleWithWidthHeight(StageContext.instance.screenHeight/8, StageContext.instance.screenHeight/8);
            sprite.position.x = _MARGIN + sprite.width / 2 * sprite.scale.x;
            sprite.position.y = StageContext.instance.screenHeight - _MARGIN - sprite.height / 2 * sprite.scale.y;
            _batchSprite.addSprite(sprite);
            
            var x:Number = _MARGIN + StageContext.instance.screenWidth/8;
            var y:Number = sprite.position.y;
            
            sprite = new Sprite();
            sprite.createSpriteWithBatchSprite(_batchSprite, "character1_btn", x, y );
            sprite.setScaleWithWidthHeight(StageContext.instance.screenHeight/8, StageContext.instance.screenHeight/8);
            _batchSprite.addSprite(sprite);
            
            onCreatedCashBar(_MARGIN + StageContext.instance.screenHeight/8*4, sprite.position.y );
            
            sprite = null;
            onCreatedCastle();
        }
        
        
        private function onCreatedCashBar(positionX:Number, positionY:Number):void
        {
            _cashBarBg = new Sprite();
            _cashBarBg.createSpriteWithBatchSprite(_characterMovingLayer.batchSprite, "hp_bkg", positionX, positionY);
            _cashBarBg.scale.x = 15.0;
            _cashBarBg.scale.y = 1.5;
            _cashBarBg.position.x = positionX + _cashBarBg.width/2;
            _cashBarBg.position.y = positionY - _cashBarBg.height;
            _batchSprite.addSprite(_cashBarBg);
            
            _cashBarFront = new Sprite();
            _cashBarFront.createSpriteWithBatchSprite(_characterMovingLayer.batchSprite, "cash_front", positionX, positionY);
            _cashBarFront.scale.x = 15.0;
            _cashBarFront.scale.y = 1.2;
            _cashBarFront.position.x = positionX + _cashBarFront.width/2;
            _cashBarFront.position.y = positionY - _cashBarFront.height
            _batchSprite.addSprite(_cashBarFront);
            
            _cashBarProgress.init(_cashBarFront, _cashBarBg, 100, 0, ProgressBar.FROM_LEFT);
        }
        
        private function updateCash():void
        {
            if( _batchSprite.imageLoaded == false )
                return;
            
            _currentCash = _cashData/Resources.CASH_BAR_SPEED;
            if( _currentCash <= 100 )
            {
                _cashBarProgress.updateProgress(_currentCash);
                
            }
            else
            {
                _currentCash = _cashBarProgress.totalValue;
                _cashData = _cashBarProgress.totalValue * Resources.CASH_BAR_SPEED;
            }
        }
        
        private function onCreatedCastle():void
        {
            var playerCastleObject:CharacterObject = new CharacterObject("castle", "castle", 5000, 50, 0, 1000, Resources.TAG_CASTLE, true);
            _characterMovingLayer.playerCharacterArray.push(playerCastleObject);
            
            var enemyCastleObject:CharacterObject = new CharacterObject("castle", "castle", 5000, 50, 0, 1000, Resources.TAG_CASTLE, false);
            _characterMovingLayer.enemyCharacterArray.push(enemyCastleObject);
        }
        
        override public function update(dt:Number):void
        {
            _cashData += dt;
            updateCash();           
            
            if( _batchSprite.imageLoaded == false )
                return;
            
            for(var i:uint=0; i<_playerCharacterArray.length; i++)
            {
                var playerCharacter:CharacterObject = _playerCharacterArray[i] as CharacterObject;
                for(var j:uint=0; j<_enemyCharacterArray.length; j++)
                {
                    var enemyCharacter:CharacterObject = _enemyCharacterArray[j] as CharacterObject;
                    if(intersectRect(playerCharacter.getAttackBounds(), enemyCharacter.sprite.rect))
                    {
                        if(playerCharacter.info.state != CharacterObject.ATTACK)
                        {
                            playerCharacter.setState(CharacterObject.ATTACK, enemyCharacter);
                            if(enemyCharacter.tag == Resources.TAG_CASTLE)
                            {
                                enemyCharacter.setState(CharacterObject.ATTACK, playerCharacter);
                            }
                        }
                    }
                }
                
                for(var bulletIndex:uint=0; bulletIndex<playerCharacter.bulletArray.length; ++bulletIndex)
                {
                    if( playerCharacter.bulletArray[bulletIndex].isMoving == false )
                    {
                        playerCharacter.removeBullet(bulletIndex);
                    }
                }
            }
            
            for(i=0; i<_enemyCharacterArray.length; ++i)
            {
                enemyCharacter = _enemyCharacterArray[i] as CharacterObject;
                for(j=0; j<_playerCharacterArray.length; j++)
                {
                    playerCharacter = _playerCharacterArray[j] as CharacterObject;
                    if(intersectRect(enemyCharacter.getAttackBounds(), playerCharacter.sprite.rect))
                    {
                        if(enemyCharacter.info.state != CharacterObject.ATTACK)
                        {
                            enemyCharacter.setState(CharacterObject.ATTACK, playerCharacter);
                            if(playerCharacter.tag == Resources.TAG_CASTLE)
                            {
                                playerCharacter.setState(CharacterObject.ATTACK, enemyCharacter);
                            }
                        }
                    }
                    for(bulletIndex=0; bulletIndex<playerCharacter.bulletArray.length; ++bulletIndex)
                    {
                        if( playerCharacter.bulletArray[bulletIndex].isMoving == false )
                        {
                            playerCharacter.removeBullet(bulletIndex);
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
                    if(_currentCash >= Resources.CHARECTER2_CASH)
                    {
                        var characterObject2:CharacterObject = new CharacterObject("character2_run_right", "character2_attack_right", 100, 20, 10000, 300, Resources.TAG_PURPLE, true);
                        
                        _playerCharacterArray.push(characterObject2);
                        _cashData -= Resources.CHARECTER2_CASH * Resources.CASH_BAR_SPEED; 
                    }
                }
            }
            else if( _MARGIN +  StageContext.instance.screenHeight/8 < event.stageX && event.stageX < _MARGIN +  StageContext.instance.screenHeight/8*2)
            {
                if( _MARGIN < event.stageY && event.stageY < _MARGIN +  StageContext.instance.screenHeight/8)
                {
                    if(_currentCash >= Resources.CHARECTER1_CASH)
                    {
                        var characterObject1:CharacterObject = new CharacterObject("character1_run_right", "character1_attack", 100, 40, 10000, 600, Resources.TAG_RED, true);
                        characterObject1.info.attackBoundsWidth *= 4; 
                        characterObject1.info.attackBoundsHeight = characterObject1.sprite.getContentWidth();
                        
                        _playerCharacterArray.push(characterObject1);
                        _cashData -= Resources.CHARECTER1_CASH * Resources.CASH_BAR_SPEED; 
                    }
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
                    intervalX = event.stageX - prevPoint.x;
                    if( intervalX + StageContext.instance.mainCamera.x > -512 )
                        intervalX = -512 - StageContext.instance.mainCamera.x;
                    
                    var rightSide:int = (StageContext.instance.screenWidth * _backGroundLayer.bgPageNum - StageContext.instance.screenWidth * 0.5) * -1;
                    if( intervalX + StageContext.instance.mainCamera.x < rightSide )
                        intervalX = rightSide - StageContext.instance.mainCamera.x;
                    
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
        
        private function intersectRect(rect1:Rectangle, rect2:Rectangle):Boolean
        {  
            if( rect1.contains(rect2.left, rect2.top) || 
                rect1.contains(rect2.left, rect2.bottom) ||
                rect1.contains(rect2.right, rect2.top) ||
                rect1.contains(rect2.right, rect2.bottom) )
            {
                return true;
            }
            
            return false;
        }
        
    }
}
