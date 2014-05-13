package com.sundaytoz.st2D
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.STSprite;
    import com.sundaytoz.st2D.display.STSpriteManager;
    import com.sundaytoz.st2D.utils.Vector2D;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    
    public class st2DFramework extends Sprite
    {
        private var sprite1:STSprite = new STSprite();
        private var sprite2:STSprite = new STSprite();
        
        public function st2DFramework()
        {
            super();
            
            // support autoOrients
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
                        
            StageContext.instance.init(stage, onInited);
		}
        
        private function onInited():void
        {
            sprite1.setTextureWithString("res/texture.png");      
            sprite1.position = new Vector2D(0.0, 2.0);
            
            sprite2.setTextureWithString("res/star.png");
            
            addEventListener(Event.ENTER_FRAME, enterFrame);
        }
        private function enterFrame(e:Event):void 
        {
            update();
            
            draw();
        }
        
        private function update():void
        {
            sprite1.position.x = sprite1.position.x + 0.1;  
        }
        
        private function draw():void
        {
            STSpriteManager.instance.drawAllSprites();
        }
        		
    }
}