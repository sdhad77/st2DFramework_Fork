import com.stintern.st2D.animation.AnimationManager;
import com.stintern.st2D.display.Layer;
import com.stintern.st2D.display.sprite.STSprite;

class GameObject
{
    public var _sprite:STSprite;
    public var _info:ObjectInfo;
    public var _mStage:Layer;
    public static var loadingCnt:int = 0;
    
    public function GameObject(stage:Layer, path:String, hp:Number, power:Number, party:String)
    {
        _info = new ObjectInfo(hp, power, party);
        STSprite.createSpriteWithPath(path, onCreated);
    }
    
    private function onCreated(sprite:STSprite):void
    {
        _sprite = sprite;
        loadingCnt++;
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

package com.stintern.st2D.tests.game
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.AnimationManager;
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.STSprite;
    import com.stintern.st2D.utils.CollisionDetection;
    import com.stintern.st2D.utils.Picking;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    
    public class Game1 extends Layer
    {
        private var gameObject:Vector.<GameObject> = new Vector.<GameObject>;
        private var effectSprite:STSprite;
        private var testSprite:STSprite;
        private var sch:Scheduler = new Scheduler();
        private var gameStart:Boolean = false;
        
        public function Game1()
        {
            init();
        }
        
        override public function update(dt:Number):void
        {
 /*           if(gameStart)
            {
                for(var i:int=0; i < gameObject.length; i++)
                {
                    for(var j:int=0; j < gameObject.length; j++)
                    {
                        if(gameObject[i]._info._party != gameObject[j]._info._party)
                        {
                            if(CollisionDetection.collisionCheck(gameObject[i]._sprite, gameObject[j]._sprite))
                            {
                                effectSprite.isVisible = true;
                                effectSprite.position.x = (gameObject[i]._sprite.position.x + gameObject[j]._sprite.position.x)/2;
                                effectSprite.position.y = (gameObject[i]._sprite.position.y + gameObject[j]._sprite.position.y)/2;
                                AnimationManager.instance.playAnimation(effectSprite);
                                if(gameObject[i]._info._party == "PLAYER")
                                {
                                    AnimationManager.instance.moveBy(gameObject[i]._sprite, -5, 0, 0.5);
                                }
                                else
                                {
                                    AnimationManager.instance.moveBy(gameObject[j]._sprite, -5, 0, 0.5);
                                }
                            }
                        }
                    }
                }
            }*/
            
            AnimationManager.instance.update();
        }
        
        public function onCreated(sprite:STSprite):void
        {
            effectSprite = sprite;
            effectSprite.depth = 3;
            this.addSprite(effectSprite);
            effectSprite.isVisible = false;
            AnimationManager.instance.addSprite(effectSprite, "fire");
            AnimationManager.instance.pauseAnimation(effectSprite);
        }
        
        public function onCreated2(sprite:STSprite):void
        {
            testSprite = sprite;
            testSprite.depth = 5;
            this.addSprite(testSprite);
            testSprite.isVisible = true;
            
            testSprite.moveBy(300,300,30);
        }
        
        private function init():void
        {
            AnimationData.instance.setAnimationData("res/atlas.png", "res/atlas.xml");
            
            //원하는 애니메이션 자유롭게 설정.              사용할 텍스쳐 이름                                         애니메이션 이름                    프레임 호출 순서                                각 프레임 별 대기 시간(프레임) 다음 애니메이션
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("right", new Array("right0","right1","right2","right1"), 8, "right"));
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("left",  new Array("left0","left1","left2","left1"),     8, "left")); 
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("fire",  new Array("fire0","fire1","fire2","fire3",
                                                                                                  "fire4","fire5","fire6","fire7"),     6, null)); 
            
            for(var i:int=0; i< 10; i++)
            {
                gameObject.push(new GameObject(this, "res/atlas.png", 100, 10, "PLAYER"));
            }
            for(i=0; i< 10; i++)
            {
                gameObject.push(new GameObject(this, "res/atlas.png", 100, 10, "ENEMY"));
            }
            
            STSprite.createSpriteWithPath("res/atlas.png", onCreated);
            STSprite.createSpriteWithPath("res/star.png", onCreated2, null, 512, 384);
            
            sch.addFunc(2000, gameSetting, 0);
            sch.startScheduler();
        }
        
        private function gameSetting(event:TimerEvent):void
        {
            if(GameObject.loadingCnt != gameObject.length) return;
            
            sch.stopScheduler();
            
            for(var i:int=0; i < 10; i++)
            {
                gameObject[i]._sprite.depth = 2;
                this.addSprite(gameObject[i]._sprite);
                
                AnimationManager.instance.addSprite(gameObject[i]._sprite, "right");
                gameObject[i]._sprite.position.x = 100;

                gameObject[i]._sprite.position.y = i * 32 + 100;
                AnimationManager.instance.pauseAnimation(gameObject[i]._sprite);
            }
            
            for(i=10; i < 20; i++)
            {
                gameObject[i]._sprite.depth = 2;
                this.addSprite(gameObject[i]._sprite);
                
                AnimationManager.instance.addSprite(gameObject[i]._sprite, "left");
                gameObject[i]._sprite.position.x = 600;
                
                gameObject[i]._sprite.position.y = (i-10) * 32 + 100;
                AnimationManager.instance.pauseAnimation(gameObject[i]._sprite);
            }
            
            startGame();
        }
        
        private function startGame():void
        {
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
            
            for(var i:int=0; i < 20; i++)
            {
                AnimationManager.instance.playAnimation(gameObject[i]._sprite);
                if(gameObject[i]._info._party == "ENEMY") gameObject[i]._sprite.moveBy(-600, 0, 20);
            }
            
            gameStart = true;
        }
        
        private function onTouch(event:MouseEvent):void
        {
            var sprite:STSprite = Picking.pick(StageContext.instance.stage, getAllSprites(), event.stageX, event.stageY);
            sprite = null;
        }
    }
}