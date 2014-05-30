package com.stintern.st2D.demo
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.demo.datatype.Character;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    import flash.events.MouseEvent;
    
    public class Game extends Layer
    {
        private var _playerChar:Vector.<Character>   = new Vector.<Character>;
        private var _enemyChar:Vector.<Character>    = new Vector.<Character>;
        private var _effect:Vector.<SpriteAnimation> = new Vector.<SpriteAnimation>;
        
        private var _charBatch:BatchSprite;
        private var _effectBatch:BatchSprite;
        private var _batchSpriteNum:int = 2;
        
        private var _sch:Scheduler = new Scheduler;
        
        private var _gameStart:Boolean = false;
        
        public function Game()
        {
            resourceLoad();
        }
        
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
        
        private function AnimationDelaySet():void
        {
            AnimationData.instance.setAnimationDelayNum(_effectBatch.path, "fire",  4);
            AnimationData.instance.setAnimationDelayNum(_effectBatch.path, "ice",   4);
            AnimationData.instance.setAnimationDelayNum(_effectBatch.path, "meteo", 4);
            
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "SkelRight",      8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "SkelUp",         8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "SkelDown",       8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "ManRight",       8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "ManUp",          8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "ManDown",        8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "SlimeRight",     8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "SlimeUp",        8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "SlimeDown",      8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "SlimeKingRight", 8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "SlimeKingUp",    8);
            AnimationData.instance.setAnimationDelayNum(_charBatch.path, "SlimeKingDown",  8);
        }
        
        private function gameSetting():void
        {
            AnimationDelaySet();
            
            for(var i:int=0; i< 10; i++)
            {
                _playerChar.push(new Character());
                
                _playerChar[i].create(_charBatch, "ManRight", 100, 10, "PLAYER");
                _playerChar[i].sprite.position.x = 100;
                _playerChar[i].sprite.position.y = i * 64 + 100;
                _playerChar[i].sprite.playAnimation();
            }
            
            for(i=0; i< 10; i++)
            {
                _enemyChar.push(new Character());
                
                _enemyChar[i].create(_charBatch, "SkelRight", 100, 10, "ENEMY");
                _enemyChar[i].sprite.position.x = 600;
                _enemyChar[i].sprite.position.y = i * 64 + 100;
                _enemyChar[i].sprite.moveBy(-550, 0, (i+1) * 1000);
                _enemyChar[i].sprite.reverseLeftRight();
                _enemyChar[i].sprite.playAnimation();
            }
            
            for(i=0; i< 20; i++)
            {
                _effect.push(new SpriteAnimation());
                
                _effect[i].createAnimationSpriteWithBatchSprite(_effectBatch, "fire");
                _effect[i].isVisible = false;
                _effectBatch.addSprite(_effect[i]);
            }
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
            
            _gameStart = true;
        }
        
        override public function update(dt:Number):void
        {
            if(_gameStart)
            {
                collisionCheck();
            }
        }
        
        private function collisionCheck():void
        {
            for(var i:int=0; i< 10; i++)
            {
                if(_playerChar[i].isCollision) continue;
                
                for(var j:int=0; j< 10; j++)
                {
                    if(_enemyChar[j].isCollision) continue;
                    
                    if(_playerChar[i].sprite.collisionCheck(_enemyChar[j].sprite))
                    {
                        _playerChar[i].info.hp -= _enemyChar[j].info.power;
                        
                        if(_playerChar[i].info.hp <= 0) _playerChar[i].sprite.isVisible = false;
                        else
                        {
                            _playerChar[i].isCollision = true;
                            _enemyChar[j].isCollision = true;
                            _sch.addFunc(100, _playerChar[i].resetIsCollision, 1);
                            _sch.addFunc(100, _enemyChar[j].resetIsCollision, 1);
                            _sch.startScheduler();
                            
                            createEffect((_playerChar[i].sprite.position.x + _enemyChar[j].sprite.position.x)/2, (_playerChar[i].sprite.position.y + _enemyChar[j].sprite.position.y)/2);
                        }
                    }
                }
            }
        }
        
        private function createEffect(x:Number, y:Number):void
        {
            for(var k:int=0; k< 20; k++)
            {
                if(!_effect[k].isPlaying)
                {
                    _effect[k].position.x = x;
                    _effect[k].position.y = y;
                    _effect[k].setPlayAnimation("fire");
                    _effect[k].isVisible = true;
                    _effect[k].playAnimation();
                    break;
                }
            }
        }
        
        private function onTouch(event:MouseEvent):void
        {
        }
    }
}