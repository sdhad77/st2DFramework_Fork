package com.stintern.st2D.tests.Animation
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    
    import flash.events.MouseEvent;
    
    public class SpriteMoveLayer extends Layer
    {
        private var _sprite:Vector.<SpriteAnimation> = new Vector.<SpriteAnimation>;
        private var _batchSprite:BatchSprite;
        
        public function SpriteMoveLayer()
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
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("down",  new Array("down0","down1","down2","down1"),     8, "down"));
            
            for(var i:int=0; i < 3; i++)
            {
                _sprite.push(new SpriteAnimation());
                _sprite[i].createAnimationSpriteWithBatchSprite(_batchSprite, "down", i*32 + 100, 32 + 100);
                _batchSprite.addSprite(_sprite[i]);
                _sprite[i].playAnimation();
            }
        }
        
        private function onTouch(event:MouseEvent):void
        {
            for(var i:int=0; i < _sprite.length; i++)
            {
                _sprite[i].moveBy(Math.random()*100, Math.random()*100, Math.random()*1000);
            }
        }
    }
}