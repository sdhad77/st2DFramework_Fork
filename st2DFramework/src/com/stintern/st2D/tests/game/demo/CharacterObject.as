package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;

    public class CharacterObject
    {
        private var _sprite:SpriteAnimation = new SpriteAnimation();
        private var _info:CharacterInfo;
        private var _characterMovingLayer:CharacterMovingLayer = SceneManager.instance.getCurrentScene().getLayerByName("CharacterMovingLayer") as CharacterMovingLayer;
        private var _backGroundLayer:BackGroundLayer = SceneManager.instance.getCurrentScene().getLayerByName("BackGroundLayer") as BackGroundLayer;
        private var _batchSprite:BatchSprite;
        private var sprite:SpriteAnimation;
         
            
        public function CharacterObject(path:String, hp:Number, power:Number, speed:Number, ally:Boolean)
        {
            _info = new CharacterInfo(hp, power, speed, ally);
            _batchSprite = _characterMovingLayer.batchSprite;

            onCreated();
        }

        private function onCreated():void
        {
            sprite = new SpriteAnimation();
            var x:Number = 0;
            var y:Number = 0;
            sprite.createAnimationSpriteWithPath("res/dungGame.png", "char", onSpriteCreated, null, x, y );
        }
        
        private function onSpriteCreated():void
        {
            sprite.setScaleWithWidthHeight(StageContext.instance.screenHeight/5, StageContext.instance.screenHeight/5);
   //         sprite.position.y = sprite.height*3;
            sprite.position.y = 200;
            _batchSprite.addSprite(sprite);
            sprite.moveTo(StageContext.instance.screenWidth * _backGroundLayer.bgPageNum, sprite.height*3, _info.speed);
            sprite.playAnimation();
        }
        
        private function onCreated1():void
        {
            _characterMovingLayer.addSprite(_sprite);
        }
    }
}


class CharacterInfo
{
    private var _hp:Number;
    private var _power:Number;
    private var _speed:Number
    private var _ally:Boolean;
    
    public function CharacterInfo(hp:Number, power:Number, speed:Number, ally:Boolean)
    {
        _hp = hp;
        _power = power;
        _speed = speed;
        _ally = ally;
    }

    public function get hp():Number
    {
        return _hp;
    }

    public function get power():Number
    {
        return _power;
    }

    public function get speed():Number
    {
        return _speed;
    }

    public function get ally():Boolean
    {
        return _ally;
    }
}