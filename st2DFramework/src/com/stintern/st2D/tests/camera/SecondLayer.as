package com.stintern.st2D.tests.camera
{
    import com.stintern.st2D.basic.Camera;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.Sprite;
    
    import flash.events.MouseEvent;
    
    public class SecondLayer extends Layer
    {
        private var _sprite:Sprite = new Sprite();
        
        private var _sprites:Array = new Array();
        private var _translation:Number = 0.0;
        
        private var _touchCount:uint = 0;
        
        private var _camera:Camera = new Camera();
        
        public function SecondLayer()
        {
            var width:uint = StageContext.instance.screenWidth;
            var height:uint = StageContext.instance.screenHeight;
            
            _camera.init(-width*0.5, -height*0.5, width, height);  
            setCameraOfLayer(_camera);
            
            _sprite.createSpriteWithPath("res/star.png", onCreated, null, width*0.5, height*0.5);
            addSprite(_sprite);
        }
        
        override public function update(dt:Number):void
        {
            
        }
        
        private function onCreated():void
        {
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_UP, onTouch);
        }
                
        private function onTouch(event:MouseEvent):void
        {            
            
        }
        
    }
}