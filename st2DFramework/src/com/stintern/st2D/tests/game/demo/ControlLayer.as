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
        
        private var _characterBtn1:Sprite;
        private var _characterBtn2:Sprite;
        
        private var _cashData:uint;
        private var _currentCash:uint = 0;
        private var _cashBarBg:Sprite;
        private var _cashBarFront:Sprite;
        private var _cashBarProgress:ProgressBar = new ProgressBar();
        
        private var _coolTimeBar1:Sprite;
        private var _coolTimeBar2:Sprite;
        private var _coolTimeProgress1:ProgressBar = new ProgressBar();
        private var _coolTimeProgress2:ProgressBar = new ProgressBar();
        private var _coolTimeData1:uint = 30;
        private var _coolTimeData2:uint = 30;

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
                _enemyCharacterArray.push(new CharacterObject("character3_run_left", "character3_attack_left", 1000, 30, 10000, 500, Resources.TAG_GREEN, false));
            }
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
        
        private function onCreatedButton():void
        {
            _characterBtn2 = new Sprite();
            _characterBtn2.createSpriteWithBatchSprite(_batchSprite, "character2_btn");
            _characterBtn2.setScaleWithWidthHeight(StageContext.instance.screenHeight/8, StageContext.instance.screenHeight/8);
            _characterBtn2.position.x = _MARGIN + _characterBtn2.width / 2 * _characterBtn2.scale.x;
            _characterBtn2.position.y = StageContext.instance.screenHeight - _MARGIN - _characterBtn2.height / 2 * _characterBtn2.scale.y;
            _batchSprite.addSprite(_characterBtn2);
            onCreatedCoolTime(1, _characterBtn2.position.x, _characterBtn2.position.y);
            
            var x:Number = _MARGIN + StageContext.instance.screenWidth/8;
            var y:Number = _characterBtn2.position.y;
            
            _characterBtn1 = new Sprite();
            _characterBtn1.createSpriteWithBatchSprite(_batchSprite, "character1_btn", x, y );
            _characterBtn1.setScaleWithWidthHeight(StageContext.instance.screenHeight/8, StageContext.instance.screenHeight/8);
            _batchSprite.addSprite(_characterBtn1);
            onCreatedCoolTime(2, _characterBtn1.position.x, _characterBtn1.position.y);
            
            onCreatedCashBar(_MARGIN + StageContext.instance.screenHeight/8*4, _characterBtn1.position.y );
            
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
            
            if(Resources.CASH_BAR_SPEED > 0)
            {
                _currentCash = _cashData/Resources.CASH_BAR_SPEED;
            }
            else
            {
                _currentCash = _cashData/1;
            }
            
            if( _currentCash <= Resources.CASH_BAR_SPEED )
            {
                _cashBarProgress.updateProgress(_currentCash);
            }
            else
            {
                _currentCash = _cashBarProgress.totalValue;
                _cashBarProgress.updateProgress(_currentCash);
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
        
        private function onCreatedCoolTime(characterIndex:uint, positionX:Number, positionY:Number):void
        {
            if(characterIndex == 1)
            {
                _coolTimeBar1 = new Sprite();
                _coolTimeBar1.createSpriteWithBatchSprite(_characterMovingLayer.batchSprite, "cooldown_front", positionX, positionY);
                _coolTimeBar1.setScaleWithWidthHeight(StageContext.instance.screenHeight/8, StageContext.instance.screenHeight/8);
                _coolTimeBar1.position.x = positionX;
                _coolTimeBar1.position.y = positionY;
                _batchSprite.addSprite(_coolTimeBar1);
                
                _coolTimeProgress1.init(_coolTimeBar1, _characterBtn2, _coolTimeData1, _coolTimeData1, ProgressBar.FROM_LEFT);
                _coolTimeBar1.isVisible = false;
            }
            else if(characterIndex == 2)
            {
                _coolTimeBar2 = new Sprite();
                _coolTimeBar2.createSpriteWithBatchSprite(_characterMovingLayer.batchSprite, "cooldown_front", positionX, positionY);
                _coolTimeBar2.setScaleWithWidthHeight(StageContext.instance.screenHeight/8, StageContext.instance.screenHeight/8);
                _coolTimeBar2.position.x = positionX;
                _coolTimeBar2.position.y = positionY;
                _batchSprite.addSprite(_coolTimeBar2);
                
                _coolTimeProgress2.init(_coolTimeBar2, _characterBtn1, _coolTimeData2, _coolTimeData2, ProgressBar.FROM_LEFT);
                _coolTimeBar2.isVisible = false;
            }
        }
        
        private function updateCoolTime():void
        {
            if( _batchSprite.imageLoaded == false )
                return;
            
            if(_coolTimeBar1.isVisible == true)
            {
                _coolTimeData1--;
                _coolTimeProgress1.updateProgress(_coolTimeData1);
                if(_coolTimeData1 == 0)
                {
                    _coolTimeBar1.isVisible = false;
                    _coolTimeData1 = 100;
                }
            }
            
            if(_coolTimeBar2.isVisible == true)
            {
                _coolTimeData2--;
                _coolTimeProgress2.updateProgress(_coolTimeData2);
                if(_coolTimeData2 == 0)
                {
                    _coolTimeBar2.isVisible = false;
                    _coolTimeData2 = 100;
                }
            }
        }
        
        override public function update(dt:Number):void
        {
            _cashData += dt;
            updateCash();
            updateCoolTime();
            
            if( _batchSprite.imageLoaded == false )
                return;
            
            for(var i:uint=0; i<_playerCharacterArray.length; i++)
            {
                if(_playerCharacterArray[i].info.state != CharacterObject.ATTACK)
                {
                    for(var j:uint=0; j<_enemyCharacterArray.length; j++)
                    {
                        if(intersectRect(_playerCharacterArray[i].getAttackBounds(), _enemyCharacterArray[j].sprite.rect))
                        {
                            _playerCharacterArray[i].setState(CharacterObject.ATTACK, _enemyCharacterArray[j]);
                            break;
                        }
                    }
                }
                
                for(var bulletIndex:uint=0; bulletIndex<_playerCharacterArray[i].bulletArray.length; ++bulletIndex)
                {
                    if( _playerCharacterArray[i].bulletArray[bulletIndex].isMoving == false )
                    {
                        _playerCharacterArray[i].removeBullet(bulletIndex);
                    }
                }
            }
            
            for(i=0; i<_enemyCharacterArray.length; ++i)
            {
                if(_enemyCharacterArray[i].info.state != CharacterObject.ATTACK)
                {
                    for(j=0; j<_playerCharacterArray.length; j++)
                    {
                        if(intersectRect(_enemyCharacterArray[i].getAttackBounds(), _playerCharacterArray[j].sprite.rect))
                        {
                            _enemyCharacterArray[i].setState(CharacterObject.ATTACK, _playerCharacterArray[j]);
                            break;
                        }
                    }
                }
                
                for(bulletIndex=0; bulletIndex<_enemyCharacterArray[i].bulletArray.length; ++bulletIndex)
                {
                    if( _enemyCharacterArray[i].bulletArray[bulletIndex].isMoving == false )
                    {
                        _enemyCharacterArray[i].removeBullet(bulletIndex);
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
                        _playerCharacterArray.push(new CharacterObject("character2_run_right", "character2_attack_right", 100, 20, 10000, 300, Resources.TAG_PURPLE, true));
                        _cashData -= Resources.CHARECTER2_CASH * Resources.CASH_BAR_SPEED; 
                        _coolTimeBar1.isVisible = true;
                    }
                }
            }
            else if( _MARGIN +  StageContext.instance.screenHeight/8 < event.stageX && event.stageX < _MARGIN +  StageContext.instance.screenHeight/8*2)
            {
                if( _MARGIN < event.stageY && event.stageY < _MARGIN +  StageContext.instance.screenHeight/8)
                {
                    if(_currentCash >= Resources.CHARECTER1_CASH)
                    {
                        _playerCharacterArray.push(new CharacterObject("character1_run_right", "character1_attack", 100, 40, 10000, 600, Resources.TAG_RED, true));
                        _playerCharacterArray[_playerCharacterArray.length-1].info.attackBoundsWidth *= 4;
                        _playerCharacterArray[_playerCharacterArray.length-1].info.attackBoundsHeight = _playerCharacterArray[_playerCharacterArray.length-1].info.attackBoundsWidth;
                        _cashData -= Resources.CHARECTER1_CASH * Resources.CASH_BAR_SPEED;
                        _coolTimeBar2.isVisible = true;
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
