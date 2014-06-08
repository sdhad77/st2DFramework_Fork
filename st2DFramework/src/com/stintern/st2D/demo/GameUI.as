package com.stintern.st2D.demo
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Event;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.utils.Vector2D;
    
    import flash.events.MouseEvent;

    public class GameUI extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _sprite1:Sprite;
        private var _sprite2:Sprite;
        private var _sprite3:Sprite;
        private var _sprite4:Sprite;
        private var _sprite5:Sprite;
        
        private var _gameLayer:Game = SceneManager.instance.getCurrentScene().getLayerByName("GameLayer") as Game;
        
        private var prevPoint:Vector2D;
        private var _leftSide:int;
        private var _rightSide:int;
        
        public function GameUI()
        {
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
            
            _sprite1 = new Sprite;
            _sprite1.createSpriteWithBatchSprite(_batchSprite, "장면 1_0", uiPosX, uiPosY);
            _sprite1.setScale(new Vector2D(scaleX,scaleY));
            _sprite1.setFrameStagePos("장면 1_0");
            _batchSprite.addSprite(_sprite1);
            
            _sprite2 = new Sprite;
            _sprite2.createSpriteWithBatchSprite(_batchSprite, "장면 1_1", uiPosX, uiPosY);
            _sprite2.setScale(new Vector2D(scaleX,scaleY));
            _sprite2.setFrameStagePos("장면 1_1");
            _sprite2.addEventListener("touch", unitCreateButton1);
            _batchSprite.addSprite(_sprite2);
            
            _sprite3 = new Sprite;
            _sprite3.createSpriteWithBatchSprite(_batchSprite, "장면 1_2", uiPosX, uiPosY);
            _sprite3.setScale(new Vector2D(scaleX,scaleY));
            _sprite3.setFrameStagePos("장면 1_2");
            _sprite3.addEventListener("touch", unitCreateButton2);
            _batchSprite.addSprite(_sprite3);
            
            _sprite4 = new Sprite;
            _sprite4.createSpriteWithBatchSprite(_batchSprite, "장면 1_3", uiPosX, uiPosY);
            _sprite4.setScale(new Vector2D(scaleX,scaleY));
            _sprite4.setFrameStagePos("장면 1_3");
            _sprite4.addEventListener("touch", unitCreateButton3);
            _batchSprite.addSprite(_sprite4);
            
            _sprite5 = new Sprite;
            _sprite5.createSpriteWithBatchSprite(_batchSprite, "장면 1_4", uiPosX, uiPosY);
            _sprite5.setScale(new Vector2D(scaleX,scaleY));
            _sprite5.setFrameStagePos("장면 1_4");
            _sprite5.addEventListener("touch", unitCreateButton4);
            _batchSprite.addSprite(_sprite5);
            
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
                _sprite1.setTranslation(new Vector2D(-StageContext.instance.mainCamera.x,-StageContext.instance.mainCamera.y));
                _sprite1.setFrameStagePos("장면 1_0");
                
                _sprite2.setTranslation(new Vector2D(-StageContext.instance.mainCamera.x,-StageContext.instance.mainCamera.y));
                _sprite2.setFrameStagePos("장면 1_1");
                
                _sprite3.setTranslation(new Vector2D(-StageContext.instance.mainCamera.x,-StageContext.instance.mainCamera.y));
                _sprite3.setFrameStagePos("장면 1_2");
                
                _sprite4.setTranslation(new Vector2D(-StageContext.instance.mainCamera.x,-StageContext.instance.mainCamera.y));
                _sprite4.setFrameStagePos("장면 1_3");
                
                _sprite5.setTranslation(new Vector2D(-StageContext.instance.mainCamera.x,-StageContext.instance.mainCamera.y));
                _sprite5.setFrameStagePos("장면 1_4");
            }
        }
        
        private function buttonClick(evt:MouseEvent):void
        {
            //화면이 스크롤되서 ui sprite들의 좌표가 변경되었을때도 터치할수있게 좌표를 동적으로 설정해줌.
            Event.instance.touchCheck(evt.stageX-StageContext.instance.mainCamera.x-StageContext.instance.screenWidth/2, evt.stageY-StageContext.instance.mainCamera.y-StageContext.instance.screenHeight/2);
        }
        
        private function unitCreateButton1():void
        {
            _gameLayer.createCharacter("MAN", "PLAYER");
        }
        
        private function unitCreateButton2():void
        {
            _gameLayer.createCharacter("SKELETON", "PLAYER");
        }
        
        private function unitCreateButton3():void
        {
            _gameLayer.createCharacter("SLIME", "PLAYER");
        }
        
        private function unitCreateButton4():void
        {
            _gameLayer.createCharacter("SLIMEKING", "PLAYER");
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
    }
}