package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.display.sprite.Base;

    public class CharacterInfo extends Base
    {
        private var _hp:Number;
        private var _power:Number;
        private var _speed:Number
        private var _attackSpeed:Number
        private var _ally:Boolean;
        private var _state:String;
        
        private var _attackBoundsWidth:Number = 0.0;
        private var _attackBoundsHeight:Number = 0.0;
        
        /**
         * 캐릭터 정보 Object
         * @param hp Character의 체력
         * @param power Character의 파워
         * @param speed Character의 이동속도
         * @param attackSpeed Character의 공격 속도
         * @param ally 아군일 경우 true, 적군일 경우 false 반환
         * 
         */
        public function CharacterInfo(hp:Number, power:Number, speed:Number, attackSpeed:Number, attackBoundsWidth:Number, attackBoundsHeight:Number, ally:Boolean)
        {
            _hp = hp;
            _power = power;
            _speed = speed;
            _attackSpeed = attackSpeed;
            _ally = ally;
            _state = CharacterObject.RUN;
            setAttackBounds(attackBoundsWidth, attackBoundsHeight);
        }
        
        public function setAttackBounds(width:Number, height:Number):void
        {
            _attackBoundsWidth = width;
            _attackBoundsHeight = height;
        }
        
        public function get attackBoundsWidth():Number
        {
            return _attackBoundsWidth;
        }
        public function set attackBoundsWidth(width:Number):void
        {
            _attackBoundsWidth = width;
        }
        
        public function get attackBoundsHeight():Number
        {
            return _attackBoundsHeight;
        }
        public function set attackBoundsHeight(height:Number):void
        {
            _attackBoundsHeight = height;
        }
        
        public function get hp():Number
        {
            return _hp;
        }
        
        public function set hp(value:Number):void
        {
            _hp = value;
        }
        
        public function get power():Number
        {
            return _power;
        }
        
        public function get speed():Number
        {
            return _speed;
        }
        
        public function get attackSpeed():Number
        {
            return _attackSpeed;
        }
        
        public function get ally():Boolean
        {
            return _ally;
        }
        
        public function get state():String
        {
            return _state;
        }
        
        public function set state(value:String):void
        {
            _state = value;
        }
    }
}