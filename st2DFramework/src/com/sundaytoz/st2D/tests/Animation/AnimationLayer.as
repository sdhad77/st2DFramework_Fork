package com.sundaytoz.st2D.tests.Animation
{
    import com.sundaytoz.st2D.animation.AnimationData;
    import com.sundaytoz.st2D.animation.AnimationManager;
    import com.sundaytoz.st2D.animation.datatype.Animation;
    import com.sundaytoz.st2D.display.Layer;
    import com.sundaytoz.st2D.display.STSprite;
    
    public class AnimationLayer extends Layer
    {
        private var spriteAnimation:STSprite = new STSprite();
        
        public function AnimationLayer()
        {
            AnimationData.instance.setAnimationData("res/atlas.png", "res/atlas.xml");
            
            //원하는 애니메이션 자유롭게 설정.              사용할 텍스쳐 이름                                         애니메이션 이름                    프레임 호출 순서                                                                      각 프레임 별 대기 시간(프레임) 다음 애니메이션
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("up",    new Array("up0","up1","up2","up1"),             new Array(8,8,8,8), "up"));
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("right", new Array("right0","right1","right2","right1"), new Array(8,8,8,8), "right"));
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("down",  new Array("down0","down1","down2","down1"),     new Array(8,8,8,8), "down"));
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("left",  new Array("left0","left1","left2","left1"),     new Array(8,8,8,8), "left"));   
            
            for(var j:int=0; j < 2; j++)
            {
                for(var i:int=0; i < 20; i++)
                {
                    STSprite.createSpriteWithPath("res/atlas.png", onCreated, null, i*32 + 100, j*32 + 100);
                }
            }
        }
        
        override public function update():void
        {
            AnimationManager.instance.update();
        }
        
        private function onCreated(sprite:STSprite):void
        {
            spriteAnimation = sprite;
            spriteAnimation.depth = 2;
            
            this.addSprite(spriteAnimation);
            AnimationManager.instance.addSprite(spriteAnimation, "down");
        }
    }
}