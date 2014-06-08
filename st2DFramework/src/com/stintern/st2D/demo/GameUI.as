package com.stintern.st2D.demo
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.ProgressBar;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Event;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.utils.Vector2D;
    
    import flash.events.MouseEvent;

    public class GameUI extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _sprites:Vector.<Sprite> = new Vector.<Sprite>;
        
        private var _gameLayer:Game = SceneManager.instance.getCurrentScene().getLayerByName("GameLayer") as Game;
        
        private var prevPoint:Vector2D;
        private var _leftSide:int;
        private var _rightSide:int;
        
        private var _gpProgress:ProgressBar = new ProgressBar();
        
        public function GameUI()
        {
            this.name = "GameUILayer";
            
            _leftSide = -StageContext.instance.screenWidth/2;
            _rightSide = -(StageContext.instance.screenWidth * 2 - StageContext.instance.screenWidth/2);
            
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/system/gameUI.png", "res/system/gameUI.xml", loadCompleted, null, false);
            addBatchSprite(_batchSprite);
        }
        
        private function loadCompleted():void
        {
            var scaleX:Number = StageContext.instance.screenWidth/AnimationData.instance.animationData[_batchSprite.path]["frame"]["장면 1_0"].frameWidth;
            var scaleY:Number = StageContext.instance.screenHeight/AnimationData.instance.animationData[_batchSprite.path]["frame"]["장면 1_0"].frameHeight;
            var uiPosX:Number = StageContext.instance.screenWidth/2;
            var uiPosY:Number = StageContext.instance.screenHeight/2;
            var scale:Number = (scaleX>scaleY) ? scaleY : scaleX;
            
            for(var i:int = 0; i<9; i++)
            {
                _sprites.push(new Sprite);
                _sprites[i].createSpriteWithBatchSprite(_batchSprite, "장면 1_"+i.toString(), uiPosX, uiPosY);
                _sprites[i].setScale(new Vector2D(scaleX,scaleY));
                _sprites[i].setFrameStagePos("장면 1_"+i.toString());
                _batchSprite.addSprite(_sprites[i]);
            }

            _sprites[1].addEventListener("touch", unitCreateButton1);
            _sprites[2].addEventListener("touch", unitCreateButton2);
            _sprites[3].addEventListener("touch", unitCreateButton3);
            _sprites[4].addEventListener("touch", unitCreateButton4);
            _sprites[5].addEventListener("touch", unitCreateButton5);
            _sprites[6].addEventListener("touch", unitCreateButton6);
            
            _sprites[0].addChild(_sprites[7]);
            _sprites[0].addChild(_sprites[8]);
            _gpProgress.init(_sprites[8], _sprites[7], 100, _gameLayer.gamePoint, ProgressBar.FROM_LEFT);
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, buttonClick);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
        
        override public function update(dt:Number):void
        {
            if(_batchSprite.imageLoaded == false) return;
            
            //카메라 위치가 바뀐 경우에만 업데이트 하도록 조건 설정해야함
            if(1)
            {
                for(var i:int = 0; i<7; i++)
                {
                    _sprites[i].setTranslation(new Vector2D(-StageContext.instance.mainCamera.x,-StageContext.instance.mainCamera.y));
                    _sprites[i].setFrameStagePos("장면 1_"+i.toString());
                }
            }
            
            _gpProgress.updateProgress(_gameLayer.gamePoint);
        }
        
        private function buttonClick(evt:MouseEvent):void
        {
            //화면이 스크롤되서 ui sprite들의 좌표가 변경되었을때도 터치할수있게 좌표를 동적으로 설정해줌.
            Event.instance.touchCheck(evt.stageX-StageContext.instance.mainCamera.x-StageContext.instance.screenWidth/2, evt.stageY-StageContext.instance.mainCamera.y-StageContext.instance.screenHeight/2);
        }
        
        private function unitCreateButton1():void
        {
            if(_gameLayer.gamePoint > 5)
            {
                _gameLayer.gamePoint -= 5;
                _gameLayer.createCharacter("MAN1", "PLAYER");
            }
        }
        
        private function unitCreateButton2():void
        {
            if(_gameLayer.gamePoint > 8)
            {
                _gameLayer.gamePoint -= 8;
                _gameLayer.createCharacter("MAN3", "PLAYER");
            }
        }
        
        private function unitCreateButton3():void
        {
            if(_gameLayer.gamePoint > 10)
            {
                _gameLayer.gamePoint -= 10;
                _gameLayer.createCharacter("MAN2", "PLAYER");
            }
        }
        
        private function unitCreateButton4():void
        {
            if(_gameLayer.gamePoint > 15)
            {
                _gameLayer.gamePoint -= 15;
                _gameLayer.createCharacter("MAN4", "PLAYER");
            }
        }
        
        private function unitCreateButton5():void
        {
            if(_gameLayer.gamePoint > 10)
            {
                _gameLayer.gamePoint -= 10;
                _gameLayer.createCharacter("MAGE1", "PLAYER");
            }
        }
        
        private function unitCreateButton6():void
        {
            if(_gameLayer.gamePoint > 30)
            {
                _gameLayer.gamePoint -= 30;
                _gameLayer.createCharacter("MAGE2", "PLAYER");
            }
        }
        
        private function onMouseDown(event:MouseEvent):void
        {
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            prevPoint = new Vector2D(event.stageX, event.stageY);
        }
        
        private function onMouseMove(event:MouseEvent):void
        {   
            var intervalX:Number = event.stageX - prevPoint.x;
            
            if(intervalX + StageContext.instance.mainCamera.x > _leftSide) intervalX = _leftSide - StageContext.instance.mainCamera.x;
            else if(intervalX + StageContext.instance.mainCamera.x < _rightSide) intervalX = _rightSide - StageContext.instance.mainCamera.x;
            
            StageContext.instance.mainCamera.moveCamera(intervalX, 0.0);
            prevPoint.x = event.stageX;
        }
        
        private function onMouseUp(event:MouseEvent):void
        {
            StageContext.instance.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        }
        
        public function eventListenerClear():void
        {
            StageContext.instance.stage.removeEventListener(MouseEvent.CLICK, buttonClick);
            StageContext.instance.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            StageContext.instance.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
    }
}