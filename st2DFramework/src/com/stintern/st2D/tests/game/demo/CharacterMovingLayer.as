package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.STSprite;
    
    import flash.events.MouseEvent;

    public class CharacterMovingLayer extends Layer
    {
        
        private var _backGround:STSprite;
        private var _bgPageNum:uint = 0;
        private var _layer:Layer;
        
        public function CharacterMovingLayer()
        {
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
            
            
        }
        

        
        private function onTouch(event:MouseEvent):void
        {
            
//            var _player:CharacterObject = new CharacterObject(this, "res/star.png", 100, 100, 20, true);
            
        }
        
        override public function update(dt:Number):void
        {
        }
        
        
        public static function createCharacter(layer:Layer):void
        {
            
            var _player:CharacterObject = new CharacterObject(layer, "res/dungGame.png", 100, 100, 20, true);
        }
    }
}