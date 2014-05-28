import com.stintern.st2D.display.Layer;
import com.stintern.st2D.display.sprite.BatchSprite;
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
    
    public function create(batchSprite:BatchSprite, animationName:String, hp:Number, power:Number, party:String):void
    {
        _info = new ObjectInfo(hp, power, party);
        _sprite.createAnimationSpriteWithBatchSprite(batchSprite, animationName, animationName);
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
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.utils.AssetLoader;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    import flash.display.Bitmap;
    import flash.events.MouseEvent;
    
    public class TotalAnimationLayer extends Layer
    {
        private var _gameObject:Vector.<GameObject> = new Vector.<GameObject>;
        private var _effect:Vector.<SpriteAnimation> = new Vector.<SpriteAnimation>;
        private var _walk:SpriteAnimation = new SpriteAnimation;
        private var _gameStart:Boolean = false;
        private var _batchSprite:BatchSprite;
        private var _batchSprite2:BatchSprite;
        private var _sch:Scheduler = new Scheduler;
        
        public function TotalAnimationLayer()
        {
            init();
        }
        
        override public function update(dt:Number):void
        {
            if(_gameStart)
            {
                for(var i:int=0; i< 10; i++)
                {
                    if(_gameObject[i]._isCollision) continue;
                    for(var j:int=10; j< 20; j++)
                    {
                        if(_gameObject[j]._isCollision) continue;
                        if(_gameObject[i]._sprite.collisionCheck(_gameObject[j]._sprite))
                        {
                            _gameObject[i]._info._hp -= _gameObject[j]._info._power;
                            if(_gameObject[i]._info._hp <= 0) _gameObject[i]._sprite.isVisible = false;
                            else
                            {
                                _gameObject[i]._isCollision = true;
                                _gameObject[j]._isCollision = true;
                                _sch.addFunc(100, _gameObject[i].initIsCollision, 1);
                                _sch.addFunc(100, _gameObject[j].initIsCollision, 1);
                                _sch.startScheduler();
                                
                                for(var k:int=0; k< 20; k++)
                                {
                                    if(!_effect[k].isPlaying)
                                    {
                                        _effect[k].position.x = (_gameObject[i]._sprite.position.x + _gameObject[j]._sprite.position.x)/2;
                                        _effect[k].position.y = (_gameObject[i]._sprite.position.y + _gameObject[j]._sprite.position.y)/2;
                                        _effect[k].setPlayAnimation("fire");
                                        _effect[k].isVisible = true;
                                        _effect[k].playAnimation();
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
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
        }
        
        private function loadCompleted():void
        {   
            //원하는 애니메이션 자유롭게 설정.              사용할 텍스쳐 이름                                         애니메이션 이름                    프레임 호출 순서                                각 프레임 별 대기 시간(프레임)
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("right", new Array("right0","right1","right2","right1"), 8));
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("left",  new Array("left0","left1","left2","left1"),     8)); 
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("fire",  new Array("fire0","fire1","fire2","fire3",
                                                                                                  "fire4","fire5","fire6","fire7"),     4));
            for(var i:int=0; i< 20; i++)
            {
                _gameObject.push(new GameObject());
                
                if(i < 10)
                {
                    _gameObject[i].create(_batchSprite, "right", 100, 10, "PLAYER");
                    _gameObject[i]._sprite.position.x = 100;
                    _gameObject[i]._sprite.position.y = i * 64 + 100;
                }
                else
                {
                    _gameObject[i].create(_batchSprite, "left", 100, 10, "ENEMY");
                    _gameObject[i]._sprite.position.x = 600;
                    _gameObject[i]._sprite.position.y = (i-10) * 64 + 100;
                    _gameObject[i]._sprite.moveBy(-600, 0, (i-9)*1000);
                }
                
                _batchSprite.addSprite(_gameObject[i]._sprite);
                _gameObject[i]._sprite.playAnimation();
            }
            
            AssetLoader.instance.loadSWF("res/effect.swf", onLoad);
        }
        
        private function onLoad(bmp:Bitmap, xml:XML):void
        {
            //애니메이션 데이터를 저장할 수 있게 path를 key로 하는 dictionary를 만들고 xml 데이터를 읽어옵니다.
            AnimationData.instance.createAnimationDictionaryWithSWF( bmp.name, xml);
            
            _batchSprite2 = new BatchSprite();
            _batchSprite2.createSpriteWithBitmap(bmp);
            addBatchSprite(_batchSprite2);
            
            AnimationData.instance.setAnimationDelayNum(_batchSprite2.path, "fire", 4);
            AnimationData.instance.setAnimationDelayNum(_batchSprite2.path, "ice", 4);
            
            for(var i:int=0; i< 20; i++)
            {
                _effect.push(new SpriteAnimation());
                _effect[i].createAnimationSpriteWithBatchSprite(_batchSprite2, "fire");
                _effect[i].isVisible = false;
                _batchSprite2.addSprite(_effect[i]);
            }
            
            _gameStart = true;
        }
        
        private function onTouch(event:MouseEvent):void
        {
            for(var i:int=0; i < 20; i++)
            {
                _gameObject[i]._sprite.moveStop();
            }
        }
    }
}