package com.stintern.st2D.tests.Animation
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.utils.AssetLoader;
    
    import flash.display.Bitmap;

    public class SwfAnimationLayer extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _iceEffect:SpriteAnimation = new SpriteAnimation;
        private var _fireEffect:SpriteAnimation = new SpriteAnimation;
        
        public function SwfAnimationLayer()
        {
            // SWF 파일을 로드
            AssetLoader.instance.loadSWF("res/effect.swf", onLoad);
        }
        
        private function onLoad(bmp:Bitmap, xml:XML):void
        {
            //애니메이션 데이터를 저장할 수 있게 path를 key로 하는 dictionary를 만들고 xml 데이터를 읽어옵니다.
            AnimationData.instance.createAnimationDictionaryWithSWF( bmp.name, xml);
            
            // 배치스프라이트 생성
            _batchSprite = new BatchSprite();
            _batchSprite.createSpriteWithBitmap(bmp);
            addBatchSprite(_batchSprite);
          
            // 초기값으로 설정된 프레임 반복 횟수를 4로 설정
            AnimationData.instance.setAnimationDelayNum(_batchSprite.path, "ice", 4); 
            AnimationData.instance.setAnimationDelayNum(_batchSprite.path, "fire", 4);

            // 배치 스프라이트를 이용해서 스프라이트 애니메이션 객체를 생성
            _iceEffect.createAnimationSpriteWithBatchSprite(_batchSprite, "ice", "ice", 300, 300);
            _fireEffect.createAnimationSpriteWithBatchSprite(_batchSprite, "fire", "fire", 600, 300);
            
            // 배치 스프라이트에 생성한 객체를 등록
            _batchSprite.addSprite(_iceEffect);
            _batchSprite.addSprite(_fireEffect);
            
            // 애니메이션을 재생
            _iceEffect.playAnimation();
            _fireEffect.playAnimation();
        }

        override public function update(dt:Number):void
        {
        }
    }
}