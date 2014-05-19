package com.sundaytoz.st2D.display
{
    import com.sundaytoz.st2D.display.sprite.BatchSprite;
    import com.sundaytoz.st2D.display.sprite.STObject;
    import com.sundaytoz.st2D.display.sprite.STSprite;
    import com.sundaytoz.st2D.display.sprite.SpriteController;

    public class Layer extends STObject  
    {
        private var _spriteManager:SpriteController = new SpriteController();
        private var _batchSprite:BatchSprite;
        
        public function Layer()
        {
        }
        
        public function update(dt:Number):void
        {
            throw new Error("Layer 클래스는 update()추상함수를 포함합니다. 오버라이딩 해주세요 ");
        }
        
        public function dispose():void
        {
            _spriteManager.dispose();
            _spriteManager = null;
        }
        
        /**
         * 레이어에 새로운 스프라이트를 추가합니다. 
         * @param sprite 새롭게 추가할 스프라이트
         */
        public function addSprite(sprite:STSprite):void
        {
            _spriteManager.addSprite(sprite);
        }
        
        public function addBatchSprite(batchSprite:BatchSprite):void
        {
            _batchSprite = batchSprite;
        }

        
        /**
         * 레이어에 있는 스프라이트를 제거합니다. 
         * @param sprite 제거할 스프라이트 객체
         */
        public function removeSprite(sprite:STSprite):void
        {
            _spriteManager.removeSprite(sprite);
            sprite.dispose();
        }  
        
        /**
         * 레이어의 스프라이트 배열을 반환합니다.
         */
        public function getAllSprites():Array
        {
            return _spriteManager.getAllSprites();
        }
        
        /**
         * 레이어에 사용중인 batchSprite 를 리턴합니다. 
         */
        public function get batchSprite():BatchSprite
        {
            return _batchSprite;
        }
                
    }
}