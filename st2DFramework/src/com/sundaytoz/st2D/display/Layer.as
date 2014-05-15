package com.sundaytoz.st2D.display
{
    public class Layer extends STObject
    {
        private var spriteManager:SpriteController = new SpriteController();
        
        public function Layer()
        {
        }
        
        public function update():void
        {
            throw new Error("Layer 클래스는 update()추상함수를 포함합니다. 오버라이딩 해주세요 ");
        }
        
        public function addSprite(sprite:STSprite):void
        {
            spriteManager.addSprite(sprite);
        }
        public function removeSprite(sprite:STSprite):void
        {
            spriteManager.removeSprite(sprite);
            sprite.clean();
        }  
        
        public function drawAllSprites():void
        {
            spriteManager.drawAllSprites();
        }
        
        public function getAllSprites():Array
        {
            return spriteManager.getAllSprites();
        }
        
        
    }
}