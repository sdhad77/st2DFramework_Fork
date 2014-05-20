import com.stintern.st2D.display.Layer;
import com.stintern.st2D.display.sprite.STAnimation;

class GameObject
{
    public var _sprite:STAnimation;
    public var _info:ObjectInfo;
    public var _mStage:Layer;
    public static var loadingCnt:int = 0;
    
    public function GameObject(stage:Layer, path:String, hp:Number, power:Number, party:String)
    {
        _info = new ObjectInfo(hp, power, party);
        _sprite = new STAnimation;
        if(party == "PLAYER") _sprite.createAnimationSpriteWithPath(path, "right", onCreated);
        else _sprite.createAnimationSpriteWithPath(path, "left", onCreated);
    }
    
    private function onCreated():void
    {
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
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.STAnimation;
    
    public class Game1 extends Layer
    {
        private var gameObject:Vector.<GameObject> = new Vector.<GameObject>;
        private var testSprite:STAnimation = new STAnimation;
        private var gameStart:Boolean = false;
        private var _batchSprite:BatchSprite;
        
        public function Game1()
        {
            init();
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function init():void
        {
            AnimationData.instance.setAnimationData("res/atlas.png", "res/atlas.xml", loadCompleted);
            
            //원하는 애니메이션 자유롭게 설정.              사용할 텍스쳐 이름                                         애니메이션 이름                    프레임 호출 순서                                각 프레임 별 대기 시간(프레임) 다음 애니메이션
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("right", new Array("right0","right1","right2","right1"), 8, "right"));
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("left",  new Array("left0","left1","left2","left1"),     8, "left")); 
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("fire",  new Array("fire0","fire1","fire2","fire3",
                "fire4","fire5","fire6","fire7"),     6, "fire")); 
        }
        
        private function loadCompleted():void
        {   
            for(var i:int=0; i< 10; i++)
            {
                gameObject.push(new GameObject(this, "res/atlas.png", 100, 10, "PLAYER"));
            }
            for(i=0; i< 10; i++)
            {
                gameObject.push(new GameObject(this, "res/atlas.png", 100, 10, "ENEMY"));
            }
            
            testSprite.createAnimationSpriteWithPath("res/atlas.png", "fire", nullFunction, null, 512, 384);
            
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/atlas.png", onCreated);
            addBatchSprite(_batchSprite);
        }
        
        public function nullFunction():void
        {
        }
        
        private function onCreated():void
        {
            for(var i:int=0; i < 10; i++)
            {
                _batchSprite.addSprite(gameObject[i]._sprite);
                
                gameObject[i]._sprite.position.x = 100;
                gameObject[i]._sprite.position.y = i * 32 + 100;
            }
            
            for(i=10; i < 20; i++)
            {
                _batchSprite.addSprite(gameObject[i]._sprite);
                
                gameObject[i]._sprite.position.x = 600;
                gameObject[i]._sprite.position.y = (i-10) * 32 + 100;
            }
            
            testSprite.depth = 5;
            _batchSprite.addSprite(testSprite);
            
            startGame();
        }
        
        private function startGame():void
        {
            for(var i:int=0; i < 20; i++)
            {
                gameObject[i]._sprite.playAnimation();
                if(gameObject[i]._info._party == "ENEMY") gameObject[i]._sprite.moveBy(-600, 0, 20);
            }
            
            testSprite.playAnimation();
            
            gameStart = true;
        }
    }
}