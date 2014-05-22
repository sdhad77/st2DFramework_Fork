package com.stintern.st2D.tests.Animation
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    
    import flash.events.MouseEvent;
    
    public class AnimationChangeLayer extends Layer
    {
        private var sprite:Vector.<SpriteAnimation> = new Vector.<SpriteAnimation>;
        private var _batchSprite:BatchSprite;
        private var _loadCompleteObjectCnt:int = 0;
        private var _totalObjectNum:int = 0;
        
        public function AnimationChangeLayer()
        {
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/atlas.png", "res/atlas.xml", loadCompleted);
            addBatchSprite(_batchSprite);
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function loadCompleted():void
        {
            //원하는 애니메이션 자유롭게 설정.              사용할 텍스쳐 이름                                         애니메이션 이름                    프레임 호출 순서                                   각 프레임 별 대기 시간(프레임) 다음 애니메이션
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("up",    new Array("up0","up1","up2","up1"),             8, "up"));
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("right", new Array("right0","right1","right2","right1"), 8, "right"));
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("down",  new Array("down0","down1","down2","down1"),     8, "down"));
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("left",  new Array("left0","left1","left2","left1"),     8, "left"));
            
            _totalObjectNum = 1;
            
            for(var i:int=0; i < 1; i++)
            {
                sprite.push(new SpriteAnimation());
                sprite[i].createAnimationSpriteWithBatchSprite(_batchSprite, "down", i*32 + 100, 32 + 100);
                _loadCompleteObjectCnt++;
            }
            
            if(_loadCompleteObjectCnt == _totalObjectNum )
            {
                for(var i:int=0; i < 1; i++)
                {
                    _batchSprite.addSprite(sprite[i]);
                    sprite[i].playAnimation();
                }
            }
        }
        
        private function onTouch(event:MouseEvent):void
        {
            if(sprite[0].playAnimationName == "up") sprite[0].setPlayAnimation("down");
            else sprite[0].setPlayAnimation("up");
        }
    }
}