package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.utils.Vector2D;
    
    import flash.events.MouseEvent;
    
    public class ControlLayer extends Layer
    {
        private var mouseDownFlag:Boolean = false;
        private var prevPoint:Vector2D;
        private var _backGroundLayer:BackGroundLayer;
        
        public function ControlLayer()
        {
            _backGroundLayer = SceneManager.instance.getCurrentScene().getLayerByName("BackGroundLayer") as BackGroundLayer;
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function onTouch(event:MouseEvent):void
        {
            if(event.stageX < 200)
            {               
                var _player:CharacterObject = new CharacterObject("res/dungGame.png", 100, 100, 20, true);
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



