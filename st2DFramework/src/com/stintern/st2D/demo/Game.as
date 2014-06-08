package com.stintern.st2D.demo
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.demo.datatype.Character;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.utils.Vector2D;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    import flash.geom.Rectangle;
    
    public class Game extends Layer
    {
        private var _playerChar:Vector.<Character>   = new Vector.<Character>;
        private var _enemyChar:Vector.<Character>    = new Vector.<Character>;
        private var _effect:Vector.<SpriteAnimation> = new Vector.<SpriteAnimation>;
        private var _effectIdx:uint;
        
        private var _charBatch:BatchSprite;
        private var _effectBatch:BatchSprite;
        private var _batchSpriteNum:int = 2;
        
        private var _enemyCreateSch:Scheduler = new Scheduler;
        
        private var _gameBGLayer:GameBG = SceneManager.instance.getCurrentScene().getLayerByName("GameBGLayer") as GameBG;
        
        public function Game()
        {
            this.name = "GameLayer";
            
            resourceLoad();
        }
        
        /**
         * 리소스 읽어오는 함수입니다.
         */
        private function resourceLoad():void
        {
            _charBatch = new BatchSprite();
            _charBatch.createBatchSpriteWithPath("res/character/char.png", "res/character/char.xml", loadCompleted);
            addBatchSprite(_charBatch);
            
            _effectBatch = new BatchSprite();
            _effectBatch.createBatchSpriteWithPath("res/effect/effect.png", "res/effect/effect.xml", loadCompleted);
            addBatchSprite(_effectBatch);
        }
        
        private function loadCompleted():void
        {   
            _batchSpriteNum--;
            if(_batchSpriteNum != 0) return;
            
            gameSetting();
        }
         
        /**
         * 게임이 시작되기전 세팅을 하는 함수입니다.
         */
        private function gameSetting():void
        {
            //애니메이션 딜레이 설정
            AnimationDelaySet();
            
            //이펙트 객체 생성
            for(var i:int=0; i< 10; i++)
            {
                _effect.push(new SpriteAnimation());
                
                _effect[i].createAnimationSpriteWithBatchSprite(_effectBatch, "fire");
                _effect[i].isVisible = false;
                _effectBatch.addSprite(_effect[i]);
            }
            
            _effectIdx = 0;
            
            //성 생성
            createBuilding("CASTLE", "PLAYER", 0);
            createBuilding("CASTLE", "ENEMY", StageContext.instance.screenWidth*_gameBGLayer.bgNum);
            
            //적 자동생성 기능
            _enemyCreateSch.addFunc(5000, enemyCreate, 20);
            _enemyCreateSch.startScheduler();
            
            function enemyCreate():void
            {
                createCharacter("MAN3", "ENEMY");
            }
        }
        
        /**
         * 애니메이션의 프레임 별 딜레이를 설정하는 함수입니다.
         */
        private function AnimationDelaySet():void
        {
            AnimationData.instance.setAnimationDelayNum(_effectBatch.path, "fire",  4);
            AnimationData.instance.setAnimationDelayNum(_effectBatch.path, "ice",   4);
            AnimationData.instance.setAnimationDelayNum(_effectBatch.path, "meteo", 4);
            
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "Skeleton",    8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "Man1",        8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "Man2",        8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "Man3",        8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "Mage1",       8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "Mage2",       8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "Mage2Attack", 8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "Slime",       8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "SlimeKing",   8);
        }
        
        override public function update(dt:Number):void
        {
            collisionChec();
            attack();
        }
        
        /**
         * 모든 캐릭터들의 충돌을 검사하는 함수입니다.
         */
        private function collisionChec():void
        {
            //먼저 플레이어 캐릭터의 공격범위와 적군의 충돌을 검사합니다.
            for(var i:int=0; i<_playerChar.length; i++)
            {
                //플레이어 캐릭터가 공격상태가 아니면 넘어감. 공격상태가 아닌경우 -> 공격한지 얼마 안되서 쿨타임 기다리는중
                if(!_playerChar[i].isAttackAble) continue;
                //타겟이 이미 존재할 경우에는 바로 공격 개시
                else if(_playerChar[i].target != null) _playerChar[i].setState(Character.ATTACK);
                //타겟이 없으니 적군들을 상대로 충돌 검사
                else
                {
                    for(var j:int=0; j<_enemyChar.length; j++)
                    {
                        //타겟을 찾았으면
                        if(collisionCheckRect(_playerChar[i].attackRect(), _enemyChar[j].sprite.rect))
                        {
                            //타겟으로 설정하고 공격개시
                            _playerChar[i].target = _enemyChar[j];
                            _playerChar[i].setState(Character.ATTACK);
                        }
                    }
                }
            }
            
            //적 캐릭터의 공격범위와 플레이어의 충돌을 검사합니다.
            for(i=0; i<_enemyChar.length; i++)
            {
                //적 캐릭터가 공격상태가 아니면 넘어감. 공격상태가 아닌경우 -> 공격한지 얼마 안되서 쿨타임 기다리는중
                if(!_enemyChar[i].isAttackAble) continue;
                //타겟이 이미 존재할 경우에는 바로 공격 개시
                else if(_enemyChar[i].target != null) _enemyChar[i].setState(Character.ATTACK);
                //타겟이 없으니 플레이어를 상대로 충돌 검사
                else
                {
                    for(j=0; j<_playerChar.length; j++)
                    {
                        //타겟을 찾았으면
                        if(collisionCheckRect(_enemyChar[i].attackRect(), _playerChar[j].sprite.rect))
                        {
                            //타겟으로 설정하고 공격개시
                            _enemyChar[i].target = _playerChar[j];
                            _enemyChar[i].setState(Character.ATTACK);
                        }
                    }
                }
            }
        }
        
        private function attack():void
        {
            for(var i:int=0; i<_playerChar.length; i++)
            {
                if(_playerChar[i].info.state == Character.ATTACK && _playerChar[i].isAttackAble == true) _playerChar[i].attack();
            }
            
            for(i=0; i<_enemyChar.length; i++)
            {
                if(_enemyChar[i].info.state == Character.ATTACK && _enemyChar[i].isAttackAble == true) _enemyChar[i].attack();
            }
        }
        
        /**
         * 이펙트를 생성하는 함수입니다.
         * @param x 생성할 x좌표
         * @param y 생성할 y좌표
         */
        public function createEffect(x:Number, y:Number):void
        {
            if(_effectIdx == _effect.length) _effectIdx = 0;
            _effect[_effectIdx].position.x = x;
            _effect[_effectIdx].position.y = y;
            _effect[_effectIdx].setPlayAnimation("fire");
            _effect[_effectIdx].isVisible = true;
            _effect[_effectIdx].playAnimation();
            _effectIdx++;
        }
        
        /**
         * 사각 충돌 검사하는 간단한 함수입니다.
         * @param s1 사각형1
         * @param s2 사각형2
         * @return 충돌이면 true 아니면 fasle
         */
        public function collisionCheckRect(s1:Rectangle, s2:Rectangle):Boolean
        {
            if(s1.left <= s2.right && s2.left <= s1.right && s1.top <= s2.bottom && s2.top <= s1.bottom)
            {
                s1 = null;
                s2 = null;
                return true;
            }
            else
            {
                s1 = null;
                s2 = null;
                return false;
            }
        }
        
        /**
         * 특정 캐릭터를 삭제하는 함수입니다.
         * @param character 삭제할 캐릭터
         */
        public function removeCharacterObject(character:Character):void
        {
            //임시벡터 생성
            var tempVector:Vector.<Character>;
            
            //아군, 적군이냐에 따라 벡터 선택
            if(character.info.party == "PLAYER") tempVector = _playerChar;
            else tempVector = enemyChar;
            
            //벡터를 돌면서 해당 캐릭터 찾기
            for(var i:uint=0; i<tempVector.length; ++i)
            {
                //캐릭터를 찾았으면
                if( tempVector[i] == character )
                {
                    //자식 제거. HP바 같은것들
                    for(var j:uint=0; j<tempVector[i].sprite.getAllChildren().length; j++)
                    {
                        var child:Sprite = tempVector[i].sprite.getAllChildren()[j];
                        _charBatch.removeSprite(child);
                        child.dispose();
                    }
                    
                    //벡터에서 캐릭터 제거
                    tempVector.splice(i, 1);
                    break;
                }
            }
            
            tempVector = null;
        }
        
        /**
         * 캐릭터를 생성하는 함수입니다.
         * @param charName 생성할 캐릭터의 이름
         * @param party 생성할 캐릭터의 소속
         */
        public function createCharacter(charName:String, party:String):void
        {
            var current:Character;
            
            //아군이면
            if(party == "PLAYER")
            {
                //우선 new
                _playerChar.push(new Character());
                current = _playerChar[_playerChar.length-1];
                
                //이름으로 캐릭터 찾아서 추가
                if     (charName == "MAN1")      current.create(_charBatch, "Man1", "Man1", 100, 10, 700, "PLAYER", "CHAR", 3);
                else if(charName == "MAN2")      current.create(_charBatch, "Man2", "Man2", 150, 20, 700, "PLAYER", "CHAR", 3);
                else if(charName == "MAN3")      current.create(_charBatch, "Man3", "Man3", 120, 15, 700, "PLAYER", "CHAR", 3);
                else if(charName == "MAGE1")     current.create(_charBatch, "Mage1", "Mage1", 80, 15, 700, "PLAYER", "CHAR", 3);
                else if(charName == "MAGE2")     current.create(_charBatch, "Mage2", "Mage2", 200, 30, 700, "PLAYER", "CHAR", 3);
                else if(charName == "SKELETON")  current.create(_charBatch, "Skeleton", "Skeleton", 100, 15, 700, "PLAYER", "CHAR", 3);
                else if(charName == "SLIME")     current.create(_charBatch, "Slime", "Slime", 100, 15, 700, "PLAYER", "CHAR", 3);
                else if(charName == "SLIMEKING") current.create(_charBatch, "SlimeKing", "SlimeKing", 200, 30, 1000, "PLAYER", "CHAR", 3);
                else
                {
                    //없는 이름일경우 pop 해서 벡터 원위치 시킴
                    trace("존재하지 않는 캐릭터입니다.");
                    current = null;
                    _playerChar.pop();
                    return;
                }
                
                //캐릭터와 관계없는 공통작업. 위치지정, 공격범위 설정, 걷기 상태 설정
                current.sprite.setTranslation(new Vector2D(0,StageContext.instance.screenHeight*0.42 + current.sprite.height*current.sprite.scale.y/2));
                current.info.attackRadius = current.sprite.width * current.sprite.scale.x;
                current.setState(Character.WALK);
            }
            //적군이면
            else
            {
                //우선 new
                _enemyChar.push(new Character());
                current = _enemyChar[_enemyChar.length-1];
                
                //이름으로 캐릭터 찾아서 추가
                if     (charName == "MAN1")      current.create(_charBatch, "Man1", "Man1", 100, 10, 700, "ENEMY", "CHAR", 3);
                else if(charName == "MAN2")      current.create(_charBatch, "Man2", "Man2", 150, 20, 700, "ENEMY", "CHAR", 3);
                else if(charName == "MAN3")      current.create(_charBatch, "Man3", "Man3", 120, 15, 700, "ENEMY", "CHAR", 3);
                else if(charName == "MAGE1")     current.create(_charBatch, "Mage1", "Mage1", 80, 15, 700, "ENEMY", "CHAR", 3);
                else if(charName == "MAGE2")     current.create(_charBatch, "Mage2", "Mage2", 200, 30, 700, "ENEMY", "CHAR", 3);
                else if(charName == "SKELETON")  current.create(_charBatch, "Skeleton", "Skeleton", 100, 10, 700, "ENEMY", "CHAR", 3);
                else if(charName == "SLIME")     current.create(_charBatch, "Slime", "Slime", 100, 15, 700, "ENEMY", "CHAR", 3);
                else if(charName == "SLIMEKING") current.create(_charBatch, "SlimeKing", "SlimeKing", 200, 30, 1000, "ENEMY", "CHAR", 3);
                else
                {
                    //없는 이름일경우 pop 해서 벡터 원위치 시킴
                    trace("존재하지 않는 캐릭터입니다.");
                    current = null;
                    _enemyChar.pop();
                    return;
                }
                
                //캐릭터와 관계없는 공통작업. 위치지정, 공격범위 설정, 걷기 상태 설정
                current.sprite.reverseLeftRight();
                current.sprite.setTranslation(new Vector2D(StageContext.instance.screenWidth*_gameBGLayer.bgNum,StageContext.instance.screenHeight*0.42 + current.sprite.height*current.sprite.scale.y/2));
                current.info.attackRadius = current.sprite.width * current.sprite.scale.x;
                current.setState(Character.WALK);
            }
            
            current = null;
        }
        
        public function createBuilding(charName:String, party:String, x:Number):void
        {
            var current:Character;
            
            //아군이면
            if(party == "PLAYER")
            {
                //우선 new
                _playerChar.push(new Character());
                current = _playerChar[_playerChar.length-1];
                
                //이름으로 캐릭터 찾아서 추가
                if(charName == "CASTLE") current.create(_charBatch, "castle", "castle", 2000, 30, 400, "PLAYER", "BUILD", 2.5);
                else
                {
                    //없는 이름일경우 pop 해서 벡터 원위치 시킴
                    trace("존재하지 않는 캐릭터입니다.");
                    current = null;
                    _playerChar.pop();
                    return;
                }
                
                //캐릭터와 관계없는 공통작업. 위치지정, 공격범위 설정
                current.sprite.setTranslation(new Vector2D(x,StageContext.instance.screenHeight*0.42 + current.sprite.height*current.sprite.scale.y/2));
                current.info.attackRadius = current.sprite.width * current.sprite.scale.x;
            }
                //적군이면
            else
            {
                //우선 new
                _enemyChar.push(new Character());
                current = _enemyChar[_enemyChar.length-1];
                
                //이름으로 캐릭터 찾아서 추가
                if(charName == "CASTLE") current.create(_charBatch, "castle", "castle", 2000, 30, 400, "ENEMY", "BUILD", 2.5);
                else
                {
                    //없는 이름일경우 pop 해서 벡터 원위치 시킴
                    trace("존재하지 않는 캐릭터입니다.");
                    current = null;
                    _enemyChar.pop();
                    return;
                }
                
                //캐릭터와 관계없는 공통작업. 위치지정, 공격범위 설정
                current.sprite.reverseLeftRight();
                current.sprite.setTranslation(new Vector2D(x,StageContext.instance.screenHeight*0.42 + current.sprite.height*current.sprite.scale.y/2));
                current.info.attackRadius = current.sprite.width * current.sprite.scale.x;
            }
            
            current = null;
        }
        
        //get set 함수들
        public function get charBatch():BatchSprite         { return _charBatch;  }
        public function get playerChar():Vector.<Character> { return _playerChar; }
        public function get enemyChar():Vector.<Character>  { return _enemyChar;  }
        
        public function set charBatch(value:BatchSprite):void         { _charBatch  = value; }
        public function set playerChar(value:Vector.<Character>):void { _playerChar = value; }
        public function set enemyChar(value:Vector.<Character>):void  { _enemyChar  = value; }
    }
}