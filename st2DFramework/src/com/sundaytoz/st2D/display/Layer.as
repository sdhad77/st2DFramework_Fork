package com.sundaytoz.st2D.display
{
    public class Layer extends STObject
    {
        private var spriteManager:SpriteController = new SpriteController();
        
        public function Layer()
        {
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