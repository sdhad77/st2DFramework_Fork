package com.sundaytoz.st2D.tests.game
{
    import com.sundaytoz.st2D.animation.AnimationData;
    import com.sundaytoz.st2D.animation.AnimationManager;
    import com.sundaytoz.st2D.animation.datatype.Animation;
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.Layer;
    import com.sundaytoz.st2D.display.STSprite;
    import com.sundaytoz.st2D.display.Scene;
    import com.sundaytoz.st2D.display.SceneManager;
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
        
        public function DungGameLayer()
        {
            AnimationData.instance.setAnimationData("res/atlas.png", "res/atlas.xml");
            
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("broken",  new Array("broken0","broken1","broken2","broken3", "broken4","broken5","broken6","broken7", "broken8","broken9"),     new Array(8,8,8,8,8,8,8,8,8,8), "broken"));
            
            var dungScheduler:Scheduler = new Scheduler();
            dungScheduler.addFunc((Math.floor(Math.random() * 3)+1) * 800, createStar, 0);
            dungScheduler.startScheduler();
            
            function createStar():void
            {
                STSprite.createSpriteWithPath("res/atlas.png", dungCreated, null, Math.floor(Math.random(  ) * StageContext.instance.screenWidth), StageContext.instance.screenHeight);
            }
            
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
            STSprite.createSpriteWithPath("res/star.png", _personCreated);
                
        }
        
        override public function update(dt:Number):void
        {
            AnimationManager.instance.update();
            if( _person != null)
            {
                _person.setTranslation( new Vector2D( (Math.sin(_translation) + 1) * StageContext.instance.screenWidth * 0.5, _person.position.y ) );
                _translation += 0.03 * (_sign);
                
                if( _person.position.y - _person.height < _dung.position.y &&  _dung.position.y  <  _person.position.y )
                {
					if(_dung.isVisible){
	                    if(CollisionDetection.collisionCheck(_dung, _person))
	                    {
	                        var scene:Scene = new Scene();
	                        var secondSceneLayer:STSpriteMoveToLayer = new STSpriteMoveToLayer();
	                        scene.addLayer(secondSceneLayer);
	                        
	                        SceneManager.instance.pushScene(scene);
	                        
	                        StageContext.instance.stage.removeEventListener(MouseEvent.CLICK, onTouch);
	                    }
						else
						{
							_dung.isVisible = false;
						}
					}
					
                }
				else
				{
					if(_dung.position.y < -_person.position.y)
					{
						_dung.isVisible = false;
					}
				}
            }
        }
        
        private function dungCreated(sprite:STSprite):void
        {
            _dung = sprite;
            this.addSprite(_dung);
            AnimationManager.instance.addSprite(_dung, "broken");
            AnimationManager.instance.pauseAnimation(_dung);
            AnimationManager.instance.moveTo(_dung, _dung.position.x, -_person.position.y*2, 3);
        }
        
        private function _personCreated(sprite:STSprite):void
        {
            sprite.position = new Vector2D( StageContext.instance.screenWidth * 0.5, sprite.height );
            
            _person = sprite;
            
            this.addSprite(_person);
        }
        
        private function onTouch(event:MouseEvent):void
        {
            _sign *= -1;
        }
        
    }
}