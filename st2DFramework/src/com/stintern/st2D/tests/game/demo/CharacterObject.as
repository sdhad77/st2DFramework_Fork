package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.progressBar;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.utils.scheduler.Scheduler;

    public class CharacterObject
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
        private var _controlLayer:ControlLayer = SceneManager.instance.getCurrentScene().getLayerByName("ControlLayer") as ControlLayer;
        
        private var spriteBkg:Sprite;
        private var spriteFront:Sprite;
        private var _hpProgress:progressBar = new progressBar(); 
        
        public static const RUN:String = "RUN";
        public static const ATTACK:String = "ATTACK";
         
        
        /**
         * 캐릭터 Object를 생성합니다
         * @param characterName 캐릭터 종류를 확인할 characterName
         * @param hp Character의 체력
         * @param power Character의 파워
         * @param speed Character의 이동속도
         * @param attackSpeed Character의 공격 속도
         * @param ally 아군일 경우 true, 적군일 경우 false 반환
         * 
         */
        public function CharacterObject(runAniStr:String, attAniStr:String, hp:Number, power:Number, speed:Number, attackSpeed:Number, attackBoundsWidth:Number, attackBoundsHeight:Number, ally:Boolean)
        {
            _runAniStr = runAniStr;
            _attAniStr = attAniStr;
            _info = new CharacterInfo(hp, power, speed, attackSpeed, attackBoundsWidth, attackBoundsHeight, ally);
            _batchSprite = _characterMovingLayer.batchSprite;
            _targetObject = null;
            
            _attackScheduler.addFunc(attackSpeed, attackFunc, 0);
            _attackScheduler.startScheduler();
            function attackFunc():void
            {
                if(_info.state==ATTACK && _targetObject)
                {
                    _targetObject.info.hp -= _info.power;
                    trace(_targetObject.info.hp)
                    if(_targetObject.info.hp <= 0)
                    {
                        _targetObject.attackScheduler.stopScheduler();
                        if(_info.ally)
                        {
                            _controlLayer.removeEnemyCharacterObject(_targetObject);
                        }
                        else
                        {
                            _controlLayer.removePlayerCharacterObject(_targetObject);
                        }
                        _characterMovingLayer.batchSprite.removeSprite(_targetObject.sprite);
                        _info.state = RUN;
                        _sprite.setPlayAnimation(runAniStr);
                        _sprite.isMoving = true;
                        _targetObject = null;
                        _attackScheduler.stopScheduler();
                    }
                }
            }
            
            onCreated();
        }

        private function onCreated():void
        {
            _sprite = new SpriteAnimation();
            var x:Number = 0;
            var y:Number = 0;

            _sprite.createAnimationSpriteWithPath("res/demo/demo_spritesheet.png", _runAniStr, onSpriteCreated, null, x, y );
        }
        
        private function onSpriteCreated():void
        {
            var yPositionRange:uint = (Math.floor(Math.random() * 20)*10);
            _sprite.setScaleWithWidthHeight(StageContext.instance.screenHeight/5, StageContext.instance.screenHeight/5);
            if(_info.ally == true)
            {
                _sprite.position.x = 0;
                _sprite.position.y = _sprite.height/2 + yPositionRange;
                _batchSprite.addSprite(_sprite);
                _sprite.moveTo(StageContext.instance.screenWidth * _backGroundLayer.bgPageNum, _sprite.height, _info.speed);
            }
            else
            {
                _sprite.position.x = StageContext.instance.screenWidth * _backGroundLayer.bgPageNum;
                _sprite.position.y = _sprite.height/2 + yPositionRange;
                _batchSprite.addSprite(_sprite);
                _sprite.moveTo(0, _sprite.height, _info.speed);
            }
            setHpBar();
            _sprite.playAnimation();
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

        public function get sprite():SpriteAnimation
        {
            return _sprite;
        }

        public function get info():CharacterInfo
        {
            return _info;
        }

        public function set info(value:CharacterInfo):void
        {
            _info = value;
        }

        public function get targetObject():CharacterObject
        {
            return _targetObject;
        }

        public function set targetObject(value:CharacterObject):void
        {
            _targetObject = value;
        }

        public function get attackScheduler():Scheduler
        {
            return _attackScheduler;
        }

        public function get hpProgress():progressBar
        {
            return _hpProgress;
        }

        public function get runAniStr():String
        {
            return _runAniStr;
        }

        public function get attAniStr():String
        {
            return _attAniStr;
        }



    }
}