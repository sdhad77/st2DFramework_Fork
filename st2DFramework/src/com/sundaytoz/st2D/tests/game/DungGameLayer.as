package com.sundaytoz.st2D.tests.game
{
    import com.sundaytoz.st2D.animation.AnimationData;
    import com.sundaytoz.st2D.animation.AnimationManager;
    import com.sundaytoz.st2D.animation.datatype.Animation;
    import com.sundaytoz.st2D.animation.datatype.AnimationFrame;
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.Layer;
    import com.sundaytoz.st2D.display.STSprite;
    import com.sundaytoz.st2D.display.Scene;
    import com.sundaytoz.st2D.display.SceneManager;
    import com.sundaytoz.st2D.tests.RestartLayer;
    import com.sundaytoz.st2D.tests.Animation.STSpriteMoveToLayer;
    import com.sundaytoz.st2D.utils.CollisionDetection;
    import com.sundaytoz.st2D.utils.Vector2D;
    import com.sundaytoz.st2D.utils.scheduler.Scheduler;
    
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
            
            AnimationData.instance.setAnimation("res/dungGame.png", new Animation("dung",  new Array("dung0"),     new Array(8), "dung"));
            AnimationData.instance.setAnimation("res/dungGame.png", new Animation("char",  new Array("char0", "char1"),     new Array(8, 8), "char"));
            
            var dungScheduler:Scheduler = new Scheduler();
            dungScheduler.addFunc((Math.floor(Math.random() * 3)+1) * 550, createStar, 0);
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
            AnimationManager.instance.update();
            if( _person != null)
            {
                _person.setTranslation( new Vector2D( (Math.sin(_translation) + 1) * StageContext.instance.screenWidth * 0.5, _person.position.y ) );
                _translation += 0.03 * (_sign);
  
				var popCheckNum:uint = 0;
				for(var i:uint=0; i<_dungVector.length; i++)
				{
					if(0 < _dungVector[i].position.y && _dungVector[i].position.y < _person.position.y)
					{
						if(CollisionDetection.collisionCheck(_dungVector[i], _person))
						{
							var scene:Scene = new Scene();
							var secondSceneLayer:RestartLayer = new RestartLayer();
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
				
				for(var j:uint; j<popCheckNum; j++)
				{
					_dungVector.pop();
				}
            }
        }
        
        private function dungCreated(sprite:STSprite):void
        {
            _dung = sprite;
			_dungVector.push(sprite);
            this.addSprite(_dung);
            AnimationManager.instance.addSprite(_dung, "dung");
            AnimationManager.instance.pauseAnimation(_dung);
            AnimationManager.instance.moveTo(_dung, _dung.position.x, -_person.position.y*2, Math.floor(Math.random(  ) * 3)+2);
        }
        
        private function personCreated(sprite:STSprite):void
        {
            sprite.position = new Vector2D( StageContext.instance.screenWidth * 0.5, 100);
            _person = sprite;
            this.addSprite(_person);
			AnimationManager.instance.addSprite(_person, "char");
        }
        
        private function onTouch(event:MouseEvent):void
        {
            _sign *= -1;
        }
        
    }
}