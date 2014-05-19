package com.stintern.st2D.tests.game
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.AnimationManager;
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.Scene;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.STSprite;
    import com.stintern.st2D.utils.CollisionDetection;
    import com.stintern.st2D.utils.Vector2D;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    import flash.events.MouseEvent;
    
    public class DungGameLayer extends Layer
    {
        private var _dung:STSprite = new STSprite();
        private var _person:STSprite;
        private var _i:int=1;
        private var _translation:Number = 0.0;
        private var _sign:int = 1;
        private var _dungVector:Vector.<STSprite>;
        
        public function DungGameLayer()
        {
            _dungVector = new Vector.<STSprite>();
            
            AnimationData.instance.setAnimationData("res/dungGame.png", "res/atlas.xml");
            
            AnimationData.instance.setAnimation("res/dungGame.png", new Animation("dung",  new Array("dung0"),          8, "dung"));
            AnimationData.instance.setAnimation("res/dungGame.png", new Animation("char",  new Array("char0", "char1"), 8, "char"));
            
            var dungScheduler:Scheduler = new Scheduler();
            dungScheduler.addFunc((Math.floor(Math.random() * 4)+1) * 400, createStar, 0);
            dungScheduler.startScheduler();
            
            function createStar():void
            {
                STSprite.createSpriteWithPath("res/dungGame.png", dungCreated, null, Math.floor(Math.random(  ) * StageContext.instance.screenWidth), StageContext.instance.screenHeight);
            }
            STSprite.createSpriteWithPath("res/dungGame.png", personCreated, null, Math.floor(Math.random(  ) * StageContext.instance.screenWidth), StageContext.instance.screenHeight);
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
        }
        
        override public function update(dt:Number):void
        {
            if(AnimationManager.instance != null)
                AnimationManager.instance.update();
            
            if( _person != null)
            {
                _person.setTranslation( new Vector2D( (Math.sin(_translation) + 1) * StageContext.instance.screenWidth * 0.5, _person.position.y ) );
                _translation += 0.03 * (_sign);
                  
                var popCheckNum:uint = 0;
                for(var i:uint=0; i<_dungVector.length; i++)
                {
                    trace("_dungVector.length : " + _dungVector.length);
                    if(0 < _dungVector[i].position.y && _dungVector[i].position.y < _person.position.y + _person.height * 1.8)
                    {
                        trace(0 + "    <    " + _dungVector[i].position.y  + "    <    " + ( _person.position.y + _person.height));
                        if(CollisionDetection.collisionCheck(_dungVector[i], _person))
                        {
                            AnimationManager.instance.allPause();
                            for(var k:uint=0; k<_dungVector.length; k++)
                                _dungVector.pop();
                            for(var s:uint=0, array:Array = getAllSprites(); s<getAllSprites().length; s++)
                                AnimationManager.instance.removeSprite(array[s]);
                            
                            
                
                            var scene:Scene = new Scene();
                            var secondSceneLayer:EndLayer = new EndLayer();
                            scene.addLayer(secondSceneLayer);
                            
                            SceneManager.instance.pushScene(scene);
                            
                            StageContext.instance.stage.removeEventListener(MouseEvent.CLICK, onTouch);
                        }
                    }
                    else
                    {
                        trace(_dungVector.length);
                        if(_dungVector[i].position.y < -_person.position.y)
                        {
                            _dungVector[i].isVisible = false;
                            popCheckNum++;
                        }
                    }
                }
        
                    
            }
        }
        
        private function dungCreated(sprite:STSprite):void
        {
            _dung = sprite;
            _dung.setScale(new Vector2D(2,2));
            _dungVector.push(sprite);
            this.addSprite(_dung);
            AnimationManager.instance.addSprite(_dung, "dung");
            AnimationManager.instance.pauseAnimation(_dung);
            _dung.moveTo(_dung.position.x, -_person.position.y*2, Math.floor(Math.random(  ) * 3)+3);
        }
        
        private function personCreated(sprite:STSprite):void
        {
            sprite.position = new Vector2D( StageContext.instance.screenWidth * 0.5, 100);
            _person = sprite;
            _person.setScale(new Vector2D(2,2));
            this.addSprite(_person);
            AnimationManager.instance.addSprite(_person, "char");
        }
        
        private function onTouch(event:MouseEvent):void
        {
            _sign *= -1;
        }
    
    }
}