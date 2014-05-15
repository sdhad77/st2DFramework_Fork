package com.sundaytoz.st2D
{
    import com.sundaytoz.st2D.animation.AnimationData;
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.STSprite;
    import com.sundaytoz.st2D.display.STSpriteManager;
    import com.sundaytoz.st2D.utils.Vector2D;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import com.sundaytoz.st2D.animation.datatype.Animation;
    import com.sundaytoz.st2D.animation.AnimationManager;
    
    public class st2DFramework extends Sprite
    {
        private var sprite1:STSprite = new STSprite();
        private var sprite2:STSprite = new STSprite();
        private var sprite3:STSprite = new STSprite();
        private var sprite4:STSprite = new STSprite();
        
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
            
            sprite3.setTextureWithString("res/atlas.png");      
            sprite3.position = new Vector2D(384.0, 512.0);
            
            sprite4.setTextureWithString("res/atlas.png");      
            sprite4.position = new Vector2D(384.0, 256.0);
            
            AnimationData.instance.setAnimationData("res/atlas.png", "res/atlas.xml");
            
            //원하는 애니메이션 자유롭게 설정.              사용할 텍스쳐 이름                                         애니메이션 이름                    프레임 호출 순서                                                                        각 프레임 별 대기 시간(프레임) 다음 애니메이션
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("up",    new Array("up0","up1","up2","up1"),             new Array(8,8,8,8), "up"));
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("right", new Array("right0","right1","right2","right1"), new Array(8,8,8,8), "right"));
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("down",  new Array("down0","down1","down2","down1"),     new Array(8,8,8,8), "down"));
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("left",  new Array("left0","left1","left2","left1"),     new Array(8,8,8,8), "left"));
            
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("broken",new Array("broken0","broken1","broken2",
                                                                "broken3","broken4","broken5","broken6","broken7","broken8","broken9"), new Array(8,8,8,8,8,8,8,8,8,8), "broken")); 
 
            //down 애니메이션 시작
            AnimationManager.instance.addSprite(sprite3, "down");
            AnimationManager.instance.addSprite(sprite4, "broken");
           
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
            
            AnimationManager.instance.update();
        }
        
        private function draw():void
        {
            STSpriteManager.instance.drawAllSprites();
        }
        		
    }
}