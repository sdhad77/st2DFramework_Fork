class Info
{
    private var _hp:Number;
    private var _power:Number;
    private var _attackDelay:Number;
    private var _party:String;
    private var _attackRadius:Number;
    private var _state:String;
    
    public function Info(hp:Number, power:Number, attackDelay:Number, party:String, attackRadius:Number)
    {
        _hp = hp;
        _power = power;
        _attackDelay = attackDelay;
        _party = party;
        _attackRadius = attackRadius;
    }
    
    //get set 함수들
    public function get hp():Number           { return _hp;          }
    public function get power():Number        { return _power;       }
    public function get party():String        { return _party;       }
    public function get attackRadius():Number { return _attackRadius;}
    public function get attackDelay():Number  { return _attackDelay; }
    public function get state():String        { return _state;       }
    
    public function set hp(value:Number):void           { _hp           = value; }
    public function set power(value:Number):void        { _power        = value; }
    public function set party(value:String):void        { _party        = value; }
    public function set attackRadius(value:Number):void { _attackRadius = value; }
    public function set attackDelay(value:Number):void  { _attackDelay  = value; }
    public function set state(value:String):void        { _state        = value; }
}

package com.stintern.st2D.demo.datatype
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.demo.Game;
    import com.stintern.st2D.display.ProgressBar;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.utils.Vector2D;
    
    import flash.geom.Rectangle;

    public class Character
    {
        private var _sprite:SpriteAnimation;
        private var _info:Info;
        private var _stayAni:String;
        private var _walkAni:String;
        
        private var _target:Character;
        
        private var _batchSprite:BatchSprite;
        private var _spriteBkg:Sprite;
        private var _spriteFront:Sprite;
        private var _hpProgress:ProgressBar = new ProgressBar(); 
        
        private var _isCollision:Boolean = false;
        private var _isAttackAble:Boolean = true;
        
        private var _gameLayer:Game = SceneManager.instance.getCurrentScene().getLayerByName("GameLayer") as Game;
        
        public static const STAY:String   = "STAY";
        public static const ATTACK:String = "ATTACK";
        public static const WALK:String   = "WALK";
        public static const DEAD:String   = "DEAD";
        
        public function Character()
        {
        }
        
        /**
         * 캐릭터를 생성하는 함수 입니다.
         * @param batchSprite 캐릭터의 이미지가 존재하는 배치스프라이트
         * @param stayAniName 제자리에 대기 상태로 있을 경우의 애니메이션 이름
         * @param walkAniName 걷는 상태 일 경우의 애니메이션 이름
         * @param hp 체력
         * @param power 공격력
         * @param attackDelay 공격 쿨타임
         * @param party 아군,적군
         * @param scale 캐릭터의 크기 조정을 위한 스케일
         */
        public function create(batchSprite:BatchSprite, stayAniName:String, walkAniName:String, hp:Number, power:Number, attackDelay:Number, party:String, scale:Number = 1):void
        {
            _batchSprite = batchSprite;
            
            _sprite = new SpriteAnimation;
            _sprite.createAnimationSpriteWithBatchSprite(batchSprite, stayAniName, stayAniName);
            _sprite.setScale(new Vector2D(scale, scale))
            batchSprite.addSprite(_sprite);
            
            _stayAni = stayAniName;
            _walkAni = walkAniName;
            _info = new Info(hp, power, attackDelay, party, _sprite.width*_sprite.scale.x);
            setState(STAY);
            setHpBar();
        }
        
        /**
         * 다시 충돌할 수 있는 상태로 만들어 주는 함수입니다.
         * @param obj 의미없는 매개변수입니다. 스케쥴러때문에 존재함
         */
        public function resetIsCollision(obj:*):void
        {
            _isCollision = false;
        }
        
        /**
         * 다시 공격할 수 있는 상태로 만들어주는 함수입니다.
         * @param obj 의미없는 매개변수입니다. 스케쥴러때문에 존재함
         */
        public function resetIsAttackAble(obj:*):void
        {
            _isAttackAble = true;
        }
        
        /**
         * HPBar를 생성하는 함수입니다.
         */
        public function setHpBar():void
        {
            _spriteBkg = new Sprite();
            _spriteBkg.createSpriteWithBatchSprite(_batchSprite, "hpBar_0", _sprite.position.x, _sprite.position.y + _sprite.height*0.8*_sprite.scale.y);
            _spriteBkg.scale.x = 2.2;
            _spriteBkg.scale.y = 0.6;
            _spriteBkg.depth = _sprite.depth - 0.01;
            _batchSprite.addSprite(_spriteBkg);
            
            _spriteFront = new Sprite();
            _spriteFront.createSpriteWithBatchSprite(_batchSprite, "hpBar_1", _sprite.position.x, _sprite.position.y + _sprite.height*0.8*_sprite.scale.y);
            _spriteFront.scale.x = 2.2;
            _spriteFront.scale.y = 0.4;
            _spriteFront.depth = _sprite.depth - 0.02;
            _batchSprite.addSprite(_spriteFront);
            
            _hpProgress.init(_spriteFront, _spriteBkg, _info.hp, _info.hp, ProgressBar.FROM_LEFT);
            _sprite.addChild(_spriteFront);
            _sprite.addChild(_spriteBkg);
        }
        
        /**
         * 캐릭터의 상태를 변경하는 함수입니다.
         * @param state 변경할 상태
         */
        public function setState(state:String):void
        {
            if(state == STAY)
            {
                _info.state = STAY;
                _sprite.setPlayAnimation(_stayAni, _stayAni);
                _sprite.playAnimation();
                _sprite.moveStop();
                _target = null;
            }
            else if(state == WALK)
            {
                _info.state = WALK;
                _sprite.setPlayAnimation(_walkAni, _walkAni);
                _sprite.playAnimation();
                _target = null;
                
                if(_info.party == "PLAYER") _sprite.moveBy(StageContext.instance.screenWidth, 0, 30000);
                else _sprite.moveBy(-StageContext.instance.screenWidth, 0, 30000);
            }
            else if(state == DEAD)
            {
                if(_info.party == "PLAYER")
                {
                    for(var i:uint=0; i<_gameLayer.enemyChar.length; i++)
                    {
                        if(this == _gameLayer.enemyChar[i].target) _gameLayer.enemyChar[i].setState(WALK);
                    }
                    
                    _gameLayer.charBatch.removeSprite(_sprite);
                    _sprite.dispose();
                    _gameLayer.removeCharacterObject(this);
                }
                else
                {
                    for(i=0; i<_gameLayer.playerChar.length; i++)
                    {
                        if(this == _gameLayer.playerChar[i].target) _gameLayer.playerChar[i].setState(WALK);
                    }
                    
                    _gameLayer.charBatch.removeSprite(_sprite);
                    _sprite.dispose();
                    _gameLayer.removeCharacterObject(this);
                }
            }
            else trace("정의되지 않은 state입니다.");
        }
        
        /**
         * 공격가능 범위를 반환하는 함수입니다.
         * @return 공격가능 범위를 사각형 형태로 반환
         */
        public function attackRect():Rectangle
        {
            return new Rectangle(_sprite.position.x, _sprite.position.y, _info.attackRadius, _info.attackRadius);
        }
        
        //get set 함수들
        public function get sprite():SpriteAnimation { return _sprite;      }
        public function get info():Info              { return _info;        }
        public function get isCollision():Boolean    { return _isCollision; }
        public function get isAttackAble():Boolean   { return _isAttackAble;}
        public function get hpProgress():ProgressBar { return _hpProgress;  }
        public function get target():Character       { return _target;      }
        
        public function set sprite(value:SpriteAnimation):void { _sprite       = value; }
        public function set info(value:Info):void              { _info         = value; }
        public function set isCollision(value:Boolean):void    { _isCollision  = value; }
        public function set isAttackAble(value:Boolean):void   { _isAttackAble = value; }
        public function set hpProgress(value:ProgressBar):void { _hpProgress   = value; }
        public function set target(value:Character):void       { _target       = value; }
    }
}