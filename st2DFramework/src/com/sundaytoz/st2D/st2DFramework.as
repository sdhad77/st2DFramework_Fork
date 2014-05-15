package com.sundaytoz.st2D
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.Scene;
    import com.sundaytoz.st2D.tests.TestLayer;
    
    import flash.display.Sprite;
    import flash.events.Event;
    
    public class st2DFramework extends Sprite
    {
        public function st2DFramework()
        {
            super();
            
            StageContext.instance.init(stage, onInited);
        }
        
        private function onInited():void
        {
            var testLayer:TestLayer = new TestLayer();
            Scene.instance.addLayer(testLayer);
            
            addEventListener(Event.ENTER_FRAME, enterFrame);
        }
        
        private function enterFrame(e:Event):void 
        {
            update();
            
            draw();
        }
        
        private function update():void
        {
            
        }
        
        private function draw():void
        {
            StageContext.instance.draw();
        }
        
    }
}