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
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    import flash.events.MouseEvent;
    
    public class TotalAnimationLayer extends Layer
    {
        private var _gameObject:Vector.<GameObject> = new Vector.<GameObject>;
        private var _effect:Vector.<SpriteAnimation> = new Vector.<SpriteAnimation>;
        private var _walk:SpriteAnimation = new SpriteAnimation;
        private var _gameStart:Boolean = false;
        private var _batchSprite:BatchSprite;
        private var _batchSprite2:BatchSprite;
        private var _batchSpriteNum:int = 2;
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
            _batchSprite2 = new BatchSprite();
            _batchSprite2.createBatchSpriteWithPath("res/skel.png", "res/skel.xml", loadCompleted);
            addBatchSprite(_batchSprite2);
            
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/effect.png", "res/effect.xml", loadCompleted);
            addBatchSprite(_batchSprite);
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
        }
        
        private function loadCompleted():void
        {   
            _batchSpriteNum--;
            if(_batchSpriteNum != 0) return;
            
            AnimationData.instance.setAnimationDelayNum(_batchSprite.path, "fire",  4);
            AnimationData.instance.setAnimationDelayNum(_batchSprite.path, "ice",   4);
            AnimationData.instance.setAnimationDelayNum(_batchSprite.path, "meteo", 4);
            
            AnimationData.instance.setAnimationDelayNum(_batchSprite2.path, "right", 8);
            AnimationData.instance.setAnimationDelayNum(_batchSprite2.path, "up",    8);
            AnimationData.instance.setAnimationDelayNum(_batchSprite2.path, "down",  8);
            
            for(var i:int=0; i< 20; i++)
            {
                _gameObject.push(new GameObject());
                
                if(i < 10)
                {
                    _gameObject[i].create(_batchSprite2, "right", 100, 10, "PLAYER");
                    _gameObject[i]._sprite.position.x = 100;
                    _gameObject[i]._sprite.position.y = i * 64 + 100;
                }
                else
                {
                    _gameObject[i].create(_batchSprite2, "right", 100, 10, "ENEMY");
                    _gameObject[i]._sprite.position.x = 600;
                    _gameObject[i]._sprite.position.y = (i-10) * 64 + 100;
                    _gameObject[i]._sprite.moveBy(-550, 0, (i-9)*1000);
                    _gameObject[i]._sprite.reverseLeftRight();
                }
                
                _batchSprite2.addSprite(_gameObject[i]._sprite);
                _gameObject[i]._sprite.playAnimation();
            }
            
            for(i=0; i< 20; i++)
            {
                _effect.push(new SpriteAnimation());
                _effect[i].createAnimationSpriteWithBatchSprite(_batchSprite, "fire");
                _effect[i].isVisible = false;
                _batchSprite.addSprite(_effect[i]);
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