class Info
{
    private var _hp:Number;
    private var _power:Number;
    private var _party:String;
    
    public function Info(hp:Number, power:Number, party:String)
    {
        _hp = hp;
        _power = power;
        _party = party;
    }
    
    //get set 함수들
    public function get hp():Number   { return _hp;    }
    public function get power():Number{ return _power; }
    public function get party():String{ return _party; }
    
    public function set hp(value:Number):void    { _hp    = value; }
    public function set power(value:Number):void { _power = value; }
    public function set party(value:String):void { _party = value; }
}

package com.stintern.st2D.demo.datatype
{
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;

    public class Character
    {
        private var _sprite:SpriteAnimation;
        private var _info:Info;
        private var _state:String;
        
        private var _isCollision:Boolean = false;
        private var _isAttack:Boolean    = false;
        
        public static const STATE_STAY:String   = "STAY";
        public static const STATE_ATTACK:String = "ATTACK";
        public static const STATE_WALK:String   = "WALK";
        
        public function Character()
        {
        }
        
        public function create(batchSprite:BatchSprite, animationName:String, hp:Number, power:Number, party:String):void
        {
            _info = new Info(hp, power, party);
            _state = STATE_STAY;
            
            _sprite = new SpriteAnimation;
            _sprite.createAnimationSpriteWithBatchSprite(batchSprite, animationName, animationName);
            batchSprite.addSprite(_sprite);
        }
        
        public function resetIsCollision(obj:*):void
        {
            _isCollision = false;
        }
        
        public function resetIsAttack(obj:*):void
        {
            _isAttack = false;
        }
        
        //get set 함수들
        public function get sprite():SpriteAnimation { return _sprite;      }
        public function get info():Info              { return _info;        }
        public function get state():String           { return _state;       }
        public function get isCollision():Boolean    { return _isCollision; }
        public function get isAttack():Boolean       { return _isAttack;    }
        
        public function set sprite(value:SpriteAnimation):void { _sprite      = value; }
        public function set info(value:Info):void              { _info        = value; }
        public function set state(value:String):void           { _state       = value; }
        public function set isCollision(value:Boolean):void    { _isCollision = value; }
        public function set isAttack(value:Boolean):void       { _isAttack    = value; }
    }
}