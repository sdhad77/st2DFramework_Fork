package com.sundaytoz.st2D
{
    import com.sundaytoz.st2D.animation.AnimationData;
    import com.sundaytoz.st2D.animation.AnimationManager;
    import com.sundaytoz.st2D.animation.datatype.Animation;
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.STSprite;
    import com.sundaytoz.st2D.display.STSpriteManager;
    import com.sundaytoz.st2D.utils.Picking;
    import com.sundaytoz.st2D.utils.Vector2D;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.ui.Multitouch;
    import flash.ui.MultitouchInputMode;
    
    public class st2DFramework extends Sprite
    {
        private var sprite1:STSprite = new STSprite();
        private var sprite2:STSprite = new STSprite();
        private var sprite3:STSprite = new STSprite();
        private var sprite4:STSprite = new STSprite();
        private var sprite5:STSprite = new STSprite();
        private var sprite6:STSprite = new STSprite();
        private var sprite7:STSprite = new STSprite();
        private var sprite8:STSprite = new STSprite();
        private var sprite9:STSprite = new STSprite();
        
        
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
            
            
            AnimationData.instance.setAnimationData("res/skel.png", "res/skelAtlas.xml");
            
            //원하는 애니메이션 자유롭게 설정.              사용할 텍스쳐 이름                                         애니메이션 이름                    프레임 호출 순서                                                                   각 프레임 별 대기 시간(프레임) 다음 애니메이션
            AnimationData.instance.setAnimation("res/skel.png", new Animation("up",    new Array("up0","up1","up2","up1"),             new Array(8,8,8,8), "up"));
            AnimationData.instance.setAnimation("res/skel.png", new Animation("right", new Array("right0","right1","right2","right1"), new Array(8,8,8,8), "right"));
            AnimationData.instance.setAnimation("res/skel.png", new Animation("down",  new Array("down0","down1","down2","down1"),     new Array(8,8,8,8), "down"));
            AnimationData.instance.setAnimation("res/skel.png", new Animation("left",  new Array("left0","left1","left2","left1"),     new Array(8,8,8,8), "left"));
            
            
            
            sprite1.setTextureWithString("res/skel.png");      
            sprite1.position = new Vector2D(200, 800);
            
            sprite2.setTextureWithString("res/skel.png");      
            sprite2.position = new Vector2D(400, 800);
            
            sprite3.setTextureWithString("res/skel.png");      
            sprite3.position = new Vector2D(600, 800);
            
            sprite4.setTextureWithString("res/skel.png");      
            sprite4.position = new Vector2D(200.0, 550.0);
            
            sprite5.setTextureWithString("res/skel.png");      
            sprite5.position = new Vector2D(400.0, 550.0);
            
            sprite6.setTextureWithString("res/skel.png");      
            sprite6.position = new Vector2D(600.0, 550.0);
            
            sprite7.setTextureWithString("res/skel.png");      
            sprite7.position = new Vector2D(200.0, 300.0);
            
            sprite8.setTextureWithString("res/skel.png");      
            sprite8.position = new Vector2D(400.0, 300.0);
            
            sprite9.setTextureWithString("res/skel.png");      
            sprite9.position = new Vector2D(600.0, 300.0);
            
            //down 애니메이션 시작
            AnimationManager.instance.addSprite(sprite1, "down");
            AnimationManager.instance.addSprite(sprite2, "down");
            AnimationManager.instance.addSprite(sprite3, "down");
            AnimationManager.instance.addSprite(sprite4, "down");
            AnimationManager.instance.addSprite(sprite5, "down");
            AnimationManager.instance.addSprite(sprite6, "down");
            AnimationManager.instance.addSprite(sprite7, "down");
            AnimationManager.instance.addSprite(sprite8, "down");
            AnimationManager.instance.addSprite(sprite9, "down");
            
            addEventListener(Event.ENTER_FRAME, enterFrame);
            stage.addEventListener(MouseEvent.MOUSE_UP, onMouseClick);
        }
        private function enterFrame(e:Event):void 
        {
            update();
            
            draw(); 
        }
        
        private function update():void
        { 
            
            AnimationManager.instance.update();
        }
        
        private function draw():void
        {
            STSpriteManager.instance.drawAllSprites();
        }
        
        private function onMouseClick(e:MouseEvent): void
        {
            // Only accept clicks on the 3D simulation
            if (e.target != stage)
            {
                return;
            }
            var allSprite:Array = STSpriteManager.instance.getAllSprites();
            AnimationManager.instance.picked = Picking.pick(stage, allSprite, e.stageX, e.stageY);  //클릭된 sprite를 AnimationManger의 picked에 저장
        }
        
        
        
    }
}