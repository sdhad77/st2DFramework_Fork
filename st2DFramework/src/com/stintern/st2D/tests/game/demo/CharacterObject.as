package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.progressBar;
    import com.stintern.st2D.display.sprite.Base;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.tests.game.demo.utils.Resources;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    import flash.events.Event;
    import flash.geom.Rectangle;
    
    public class CharacterObject extends Base
    {
        private var _runAniStr:String;
        private var _attAniStr:String;
        private var _info:CharacterInfo;
        private var _batchSprite:BatchSprite;
        private var _sprite:SpriteAnimation;
        private var _targetObject:CharacterObject;
        private var _attackScheduler:Scheduler = new Scheduler;
        
        private var _characterMovingLayer:CharacterMovingLayer = SceneManager.instance.getCurrentScene().getLayerByName("CharacterMovingLayer") as CharacterMovingLayer;
        private var _backGroundLayer:BackGroundLayer = SceneManager.instance.getCurrentScene().getLayerByName("BackGroundLayer") as BackGroundLayer;
        
        private var spriteBkg:Sprite;
        private var spriteFront:Sprite;
        private var _hpProgress:progressBar = new progressBar(); 
        
        public static const RUN:String = "RUN";
        public static const ATTACK:String = "ATTACK";
        
        private var _bulletArray:Vector.<Sprite> = new Vector.<Sprite>();
        private var _degree:Number = 0.0;
        
        /**
         * 캐릭터 Object를 생성합니다
         * @param runAniStr run 시 사용할 애니매이션 string
         * @param attAniStr attack 시 사용할 애니매이션 string
         * @param hp Character의 체력
         * @param power Character의 파워
         * @param speed Character의 이동속도
         * @param attackSpeed Character의 공격 속도
         * @param ally 아군일 경우 true, 적군일 경우 false 반환
         * 
         */
        public function CharacterObject(runAniStr:String, attAniStr:String, hp:Number, power:Number, speed:Number, attackSpeed:Number, type:uint, ally:Boolean)
        {
            _runAniStr = runAniStr;
            _attAniStr = attAniStr;
            _info = new CharacterInfo(hp, power, speed, attackSpeed, ally);
            _batchSprite = _characterMovingLayer.batchSprite;
            _targetObject = null;
            
            //스프라이트 생성
            spriteCreate();
            
            if(type == Resources.TAG_PURPLE || type == Resources.TAG_ENEMY)
            {
                _attackScheduler.addFunc(_info.attackSpeed, nearAttackFunc, 0);
            }
            else
            {
                _attackScheduler.addFunc(_info.attackSpeed, farAttackFunc, 0);
            }
        }
        
        private function spriteCreate():void
        {
            //RUN 애니메이션으로 스프라이트 생성
            _sprite = new SpriteAnimation();
            _sprite.createAnimationSpriteWithBatchSprite(_batchSprite, _runAniStr);
            
            //스프라이트 생성될 y좌표 랜덤 생성
            var yPositionRange:uint = (Math.floor(Math.random() * 20)*10);
            _sprite.setScaleWithWidthHeight(StageContext.instance.screenHeight/5, StageContext.instance.screenHeight/5);
            
            //생성된 스프라이트가 아군일 경우 화면 좌측에 성성, 우측으로 이동
            if(_info.ally == true)
            {
                _sprite.position.x = 0;
                _sprite.position.y = _sprite.height/2 + yPositionRange;
                _sprite.moveTo(StageContext.instance.screenWidth * _backGroundLayer.bgPageNum, _sprite.height, _info.speed);
            }
                //생성된 스프라이트가 적군일 경우 화면 우측에 성성, 좌측으로 이동
            else
            {
                _sprite.position.x = StageContext.instance.screenWidth * _backGroundLayer.bgPageNum;
                _sprite.position.y = _sprite.height/2 + yPositionRange;
                _sprite.moveTo(0, _sprite.height, _info.speed);
            }
            
            _batchSprite.addSprite(_sprite);
            setHpBar();
            _sprite.playAnimation();
            
            _info.setAttackBounds( _sprite.getContentWidth(), _sprite.getContentHeight() );
        }
        
        private function setHpBar():void
        {
            spriteBkg = new Sprite();
            spriteBkg.createSpriteWithBatchSprite(_batchSprite, "hp_bkg", _sprite.position.x, _sprite.position.y + _sprite.height*0.8);
            spriteBkg.scale.x = 3.0
            _batchSprite.addSprite(spriteBkg);
            
            spriteFront = new Sprite();
            spriteFront.createSpriteWithBatchSprite(_batchSprite, "hp_front", _sprite.position.x, _sprite.position.y + _sprite.height*0.8);
            spriteFront.scale.x = 3.0;
            spriteFront.scale.y = 0.8;
            _batchSprite.addSprite(spriteFront);
            
            _hpProgress.init(spriteFront, _info.hp, _info.hp, progressBar.DECREASE_TO_LEFT);
            _sprite.addChild(spriteFront);
            _sprite.addChild(spriteBkg);
        }
        
        /**
         * 캐릭터의 상태를 변경하는 함수입니다.
         * @param state 변경할 상태
         * @param charObject ATTACK 상태에서 쓰일 타겟 객체입니다.
         */
        public function setState(state:String, charObject:CharacterObject = null):void
        {
            if(state == "RUN")
            {
                _info.state = RUN;
                _sprite.setPlayAnimation(runAniStr);
                _sprite.playAnimation();
                _sprite.isMoving = true;
                _targetObject = null;
                
                _attackScheduler.stopScheduler();
            }
            else if(state == "ATTACK")
            {
                _info.state = ATTACK;
                _sprite.setPlayAnimation(_attAniStr);
                _sprite.playAnimation();
                _sprite.isMoving = false;
                _targetObject = charObject;
                
                if(tag == Resources.TAG_PURPLE || tag == Resources.TAG_ENEMY)
                {
                    nearAttackFunc();
                }
                else
                {
                    farAttackFunc();
                }
                
                _attackScheduler.startScheduler();
            }
        }
        
        private function nearAttackFunc(evt:Event = null):void
        {
            //this의 상태가 공격이고, 타겟이 존재할 경우
            if(_info.state==ATTACK && _targetObject)
            {
                //this의 power로 타겟의 체력 감소시킴
                _targetObject.info.hp -= _info.power;
                
                //타겟의 체력이 0이하가 될 경우
                if(_targetObject.info.hp <= 0)
                {
                    //타겟의 스케쥴러 멈춤
                    _targetObject.attackScheduler.stopScheduler();
                    
                    //this가 아군일경우, 즉 타겟이 적군일 경우 적군 삭제
                    if(_info.ally)
                    {
                        _characterMovingLayer.removeEnemyCharacterObject(_targetObject);
                    }
                        //this가 적군일경우, 즉 타겟이 아군일 경우 아군 삭제
                    else
                    {
                        _characterMovingLayer.removePlayerCharacterObject(_targetObject);
                    }
                    _characterMovingLayer.batchSprite.removeSprite(_targetObject.sprite);
                    
                    //this의 상태를 RUN으로 변경
                    setState("RUN");
                }
            }
        }
        
        private function farAttackFunc(evt:Event = null):void
        {
            //this의 상태가 공격이고, 타겟이 존재할 경우
            if(_info.state==ATTACK && _targetObject)
            {
                var bullet:Sprite = new Sprite();
                bullet.createSpriteWithBatchSprite(_batchSprite, "hp_front", sprite.position.x, sprite.position.y);
                _batchSprite.addSprite(bullet);
                
                _bulletArray.push(bullet);
                
                bullet.moveTo(_targetObject.sprite.position.x, _targetObject.sprite.position.y, 500);
                _targetObject.info.hp -= _info.power;
                
                //타겟의 체력이 0이하가 될 경우
                if(_targetObject.info.hp <= 0)
                {
                    //타겟의 스케쥴러 멈춤
                    _targetObject.attackScheduler.stopScheduler();
                    
                    //this가 아군일경우, 즉 타겟이 적군일 경우 적군 삭제
                    if(_info.ally)
                    {
                        _characterMovingLayer.removeEnemyCharacterObject(_targetObject);
                    }
                        //this가 적군일경우, 즉 타겟이 아군일 경우 아군 삭제
                    else
                    {
                        _characterMovingLayer.removePlayerCharacterObject(_targetObject);
                    }
                    _characterMovingLayer.batchSprite.removeSprite(_targetObject.sprite);
                    
                    //this의 상태를 RUN으로 변경
                    setState("RUN");
                }
                
            }
        }
        
        public function removeBullet(index:uint):void
        {
            _batchSprite.removeSprite(_bulletArray[index]);
            _bulletArray[index].dispose();
            _bulletArray.splice(index, 1);
        }
        
        public function getAttackBounds():Rectangle
        {
            return new Rectangle(
                _sprite.position.x - _info.attackBoundsWidth * 0.5, 
                _sprite.position.y - _info.attackBoundsHeight * 0.5,
                _info.attackBoundsWidth,
                _info.attackBoundsHeight);
        }
        
        //get set 함수들
        public function get sprite():SpriteAnimation       { return _sprite;          }
        public function get info():CharacterInfo           { return _info;            }
        public function get targetObject():CharacterObject { return _targetObject;    }
        public function get attackScheduler():Scheduler    { return _attackScheduler; }
        public function get hpProgress():progressBar       { return _hpProgress;      }
        public function get runAniStr():String             { return _runAniStr;       }
        public function get attAniStr():String             { return _attAniStr;       }
        public function get bulletArray():Vector.<Sprite>  { return _bulletArray;     }
        
        public function set info(value:CharacterInfo):void           { _info         = value; }
        public function set targetObject(value:CharacterObject):void { _targetObject = value; }
    }
}