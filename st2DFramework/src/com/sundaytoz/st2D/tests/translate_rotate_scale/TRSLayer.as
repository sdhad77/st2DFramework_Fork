package com.sundaytoz.st2D.tests.translate_rotate_scale
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.Layer;
    import com.sundaytoz.st2D.display.Scene;
    import com.sundaytoz.st2D.display.SceneManager;
    import com.sundaytoz.st2D.display.sprite.STSprite;
    import com.sundaytoz.st2D.tests.batch.BatchSpriteLayer;
    import com.sundaytoz.st2D.utils.Vector2D;
    
    import flash.events.MouseEvent;
    import flash.geom.Vector3D;

    public class TRSLayer extends Layer
    {
        private var _sprites:Vector.<STSprite> = new Vector.<STSprite>();
        
        private var _translation:Number = 0.0;
        private var _degree:Number = 0.0;
        private var _scale:Number = 0.0;
        
        public function TRSLayer()
        {
            for(var i:uint = 0; i<3; ++i)
            {
                STSprite.createSpriteWithPath("res/star.png", onCreated);
            }
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
        }
        
        override public function update(dt:Number):void
        {
            if( _sprites.length == 3 )
            {
                _sprites[0].setScale( new Vector2D( Math.sin(_scale) + 0.1, Math.cos(_scale) + 0.1) );
                _sprites[1].setRotate(Math.sin(_degree) * 360, new Vector3D(0.0, 0.0, 1.0) );    
                _sprites[2].setTranslation( new Vector2D( (Math.sin(_translation) + 1) * StageContext.instance.screenWidth * 0.5, _sprites[2].position.y ) );    
                
                _scale += 0.01;
                _degree += 0.01;
                _translation += 0.05;
            }
        }        
        
        private function onCreated(sprite:STSprite):void
        {
            sprite.position = new Vector2D( StageContext.instance.screenWidth * 0.5, 
                                                            _sprites.length * StageContext.instance.screenHeight * 0.3 + sprite.height );
            
            trace( sprite.position.x + ", " + sprite.position.y );
            _sprites.push(sprite);
            
            addSprite(sprite);
            
        }
        
        private function onTouch(event:MouseEvent):void
        {
            var testLayer:BatchSpriteLayer = new BatchSpriteLayer();
            
            var scene:Scene = new Scene();
            scene.addLayer(testLayer);
            
            SceneManager.instance.pushScene(scene);
            
            StageContext.instance.stage.removeEventListener(MouseEvent.CLICK, onTouch);
        }
    }
}