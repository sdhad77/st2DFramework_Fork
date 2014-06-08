package com.stintern.st2D.demo
{
    import com.stintern.st2D.LayerSample.utils.Resources;
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.utils.Vector2D;
    
    public class GameBG extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _sprites:Vector.<Sprite> = new Vector.<Sprite>;
        private var _bgNum:int;
        
        public function GameBG()
        {
            _bgNum = 2;
            
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath(Resources.PATH_SPRITE_BACKGROUND, Resources.PATH_XML_BACKGROUND, onCreated, null, false);
            addBatchSprite(_batchSprite);
        }

        private function onCreated():void
        {
            var scaleX:Number = StageContext.instance.screenWidth/AnimationData.instance.animationData[_batchSprite.path]["frame"]["bg2"].frameWidth;
            var scaleY:Number = StageContext.instance.screenHeight/AnimationData.instance.animationData[_batchSprite.path]["frame"]["bg2"].frameHeight;
            var scale:Number = (scaleX>scaleY) ? scaleY : scaleX;
            
            for(var i:int=0; i<_bgNum; i++)
            {
                _sprites.push(new Sprite);
                _sprites[_sprites.length-1].createSpriteWithBatchSprite(_batchSprite, "bg2", StageContext.instance.screenWidth/2, StageContext.instance.screenHeight/2);
                _sprites[_sprites.length-1].setScale(new Vector2D(scaleX,scaleY));
                _sprites[_sprites.length-1].position.x += StageContext.instance.screenWidth*i;
                _sprites[_sprites.length-1].position.y = -_sprites[_sprites.length-1].height/2 * _sprites[_sprites.length-1].scale.y + StageContext.instance.screenHeight;
                _batchSprite.addSprite(_sprites[_sprites.length-1]);
            }
        }
        
        override public function update(dt:Number):void
        {
        }
        
        //get set 함수들
        public function get bgNum():int { return _bgNum; }
    }
}


