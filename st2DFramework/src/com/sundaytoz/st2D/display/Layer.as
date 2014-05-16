package com.sundaytoz.st2D.display
{
    public class Layer extends STObject  
    {
        private var spriteManager:SpriteController = new SpriteController();
        
        public function Layer()
        {
        }
        
        public function update(dt:Number):void
        {
            throw new Error("Layer 클래스는 update()추상함수를 포함합니다. 오버라이딩 해주세요 ");
        }
        
        /**
         * 레이어에 새로운 스프라이트를 추가합니다. 
         * @param sprite 새롭게 추가할 스프라이트
         */
        public function addSprite(sprite:STSprite):void
        {
            spriteManager.addSprite(sprite);
        }

        
        /**
         * 레이어에 있는 스프라이트를 제거합니다. 
         * @param sprite 제거할 스프라이트 객체
         */
        public function removeSprite(sprite:STSprite):void
        {
            spriteManager.removeSprite(sprite);
            sprite.clean();
        }  
    
        
        /**
         * 레이어에 있는 모든 스프라이트를 그립니다. 
         */
        public function drawAllSprites():void
        {
            spriteManager.drawAllSprites();
        }
        
        /**
         * 레이어의 스프라이트 배열을 반환합니다.
         */
        public function getAllSprites():Array
        {
            return spriteManager.getAllSprites();
        }
                
    }
}