import com.stintern.st2D.display.Layer;
import com.stintern.st2D.display.sprite.SpriteAnimation;

import flash.events.Event;

class GameObject
{
    public var _sprite:SpriteAnimation = new SpriteAnimation;
    public var _info:ObjectInfo;
    public var _isCollision:Boolean = false;
    
    public function GameObject()
    {
    }
    
    public function create(path:String, animationName:String, onCreated:Function, hp:Number, power:Number, party:String):void
    {
        _info = new ObjectInfo(hp, power, party);
        _sprite.createAnimationSpriteWithPath(path, animationName, onCreated);
    }
    
    public function initIsCollision(evt:Event):void
    {
        _isCollision = false;
    }
}

class ObjectInfo
{
    public var _hp:Number;
    public var _power:Number;
    public var _party:String;
    
    public function ObjectInfo(hp:Number, power:Number, party:String)
    {
        _hp = hp;
        _power = power;
        _party = party;
    }
}

package com.stintern.st2D.tests.Animation
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.utils.CollisionDetection;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    public class TotalAnimationLayer extends Layer
    {
        private var gameObject:Vector.<GameObject> = new Vector.<GameObject>;
        private var effect:Vector.<SpriteAnimation> = new Vector.<SpriteAnimation>;
        private var gameStart:Boolean = false;
        private var _batchSprite:BatchSprite;
        private var _loadCompleteObjectCnt:int = 0;
        private var _totalObjectNum:int = 0;
        private var _sch:Scheduler = new Scheduler;
        
        public function TotalAnimationLayer()
        {
            init();
        }
        
        override public function update(dt:Number):void
        {
            if(gameStart)
            {
                for(var i:int=0; i< 10; i++)
                {
                    if(gameObject[i]._isCollision) continue;
                    for(var j:int=10; j< 20; j++)
                    {
                        if(gameObject[j]._isCollision) continue;
                        if(CollisionDetection.collisionCheck(gameObject[i]._sprite, gameObject[j]._sprite))
                        {
                            gameObject[i]._info._hp -= gameObject[j]._info._power;
                            if(gameObject[i]._info._hp <= 0) gameObject[i]._sprite.isVisible = false;
                            else
                                {
                                gameObject[i]._isCollision = true;
                                gameObject[j]._isCollision = true;
                                _sch.addFunc(100, gameObject[i].initIsCollision, 1);
                                _sch.addFunc(100, gameObject[j].initIsCollision, 1);
                                _sch.startScheduler();
                                
                                for(var k:int=0; k< 20; k++)
                                {
                                    if(!effect[k].isPlaying)
                                    {
                                        effect[k].position.x = (gameObject[i]._sprite.position.x + gameObject[j]._sprite.position.x)/2;
                                        effect[k].position.y = (gameObject[i]._sprite.position.y + gameObject[j]._sprite.position.y)/2;
                                        effect[k].isVisible = true;
                                        effect[k].playAnimation();
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        private function init():void
        {
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/atlas.png", "res/atlas.xml", loadCompleted);
            addBatchSprite(_batchSprite);
        }
        
        private function loadCompleted():void
        {   
            //원하는 애니메이션 자유롭게 설정.              사용할 텍스쳐 이름                                         애니메이션 이름                    프레임 호출 순서                                각 프레임 별 대기 시간(프레임) 다음 애니메이션
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("right", new Array("right0","right1","right2","right1"), 8, "right"));
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("left",  new Array("left0","left1","left2","left1"),     8, "left")); 
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("fire",  new Array("fire0","fire1","fire2","fire3",
                                                                                                  "fire4","fire5","fire6","fire7"),     4, null)); 
            _totalObjectNum = 40;
            
            for(var i:int=0; i< 20; i++)
            {
                effect.push(new SpriteAnimation());
                effect[i].createAnimationSpriteWithPath("res/atlas.png", "fire", gameSetting);
            }
            
            for(i=0; i< 10; i++)
            {
                gameObject.push(new GameObject());
                gameObject[i].create("res/atlas.png", "right", gameSetting, 100, 10, "PLAYER");
            }
            
            for(i=10; i< 20; i++)
            {
                gameObject.push(new GameObject());
                gameObject[i].create("res/atlas.png", "left", gameSetting, 100, 10, "ENEMY");
            }
        }
        
        private function gameSetting():void
        {
            _loadCompleteObjectCnt++;
            if(_loadCompleteObjectCnt != _totalObjectNum) return ;
            
            for(var i:int=0; i < 20; i++)
            {
                if(gameObject[i]._info._party == "PLAYER")
                {
                    gameObject[i]._sprite.position.x = 100;
                    gameObject[i]._sprite.position.y = i * 64 + 100;
                }
                else
                {
                    gameObject[i]._sprite.position.x = 600;
                    gameObject[i]._sprite.position.y = (i-10) * 64 + 100;
                }
                
                gameObject[i]._sprite.depth = 2;
                _batchSprite.addSprite(gameObject[i]._sprite);
            }
            
            for(i=0; i < 20; i++)
            {
                effect[i].depth = 5;
                effect[i].isVisible = false;
                _batchSprite.addSprite(effect[i]);
            }

            startGame();
        }
        
        private function startGame():void
        {
            for(var i:int=0; i < 20; i++)
            {
                gameObject[i]._sprite.playAnimation();
                if(gameObject[i]._info._party == "ENEMY") gameObject[i]._sprite.moveBy(-600, 0, i-9);
            }

            gameStart = true;
        }
    }
}