package com.sundaytoz.st2D.display
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.utils.GameStatus;
    
    import flash.display3D.Context3D;
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.geom.Matrix3D;
    

    /**
     * 스프라이트들을 관리하고 화면에 출력합니다. 
     */
    public class SpriteController
    {        
        private var _sprites:Array = new Array();
        private var _modelViewProjection:Matrix3D = new Matrix3D();
        
        /**
         * 사용한 자원을 해제합니다. 
         */
        public function dispose():void
        {
            for each( var sprite:STSprite in _sprites )
            {
                (sprite as STSprite).dispose();
                sprite = null;
            }
            
            _modelViewProjection = null;
        }
       
        /**
         * 화면에 출력할 스프라이트를 추가합니다. 
         */
        public function addSprite(sprite:STSprite):void
        {            
            _sprites.push(sprite);
            
            // depth 로 sorting ( depth가 같으면 zOrder 로 Sorting )
            if( _sprites.length >= 2)
            {
                _sprites.sort(sortingWithDepth);
            }
        }
       
        /**
         * 레이어에 등록한 모든 스프라이트들을 출력합니다. 
         */
        public function drawAllSprites():void
        {
            var context:Context3D = StageContext.instance.context;
            
            for each( var sprite:STSprite in _sprites )
            {
                if( sprite.textureData == null )
                    continue;
                
                if( sprite.isVisible == false )
                    continue;
                
                // 화면 밖의 스프라이트 인지 검사후 화면 밖이면 그리지 않음
                if( isInScreen(sprite) == false )
                    continue;
                
                context.setTextureAt(0, sprite.texture);
                context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
                
                sprite.update();
                
                _modelViewProjection.identity();
                _modelViewProjection.append(sprite.modelMatrix );
                _modelViewProjection.append(StageContext.instance.viewMatrix);
                _modelViewProjection.append(StageContext.instance.projectionMatrix);
                
                context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _modelViewProjection, true);
               
                context.setVertexBufferAt(0, sprite.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);       // position
                context.setVertexBufferAt(1, sprite.vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);      // tex coord
                context.setVertexBufferAt(2, sprite.vertexBuffer, 5, Context3DVertexBufferFormat.FLOAT_4);      // vertex rgba
                
                context.drawTriangles(sprite.indexBuffer, 0, sprite.numTriangle);
                
                GameStatus.instance.increaseDrawCallCount();
            }
            
        }
        
        /**
         * 스프라이트가 현재 스크린 안에 있는지 확인합니다. 
         */
        private function isInScreen(sprite:STSprite):Boolean
        {
            if( sprite.right < 0 || 
                sprite.top < 0 || 
                sprite.left > StageContext.instance.screenWidth || 
                sprite.bottom > StageContext.instance.screenHeight)
            {
                return false;
            }
            
            return true;
        }
        
        /**
         * 모든 스프라이트가 담긴 벡터를 반환합니다. 
         */
        public function getAllSprites():Array
        {
            return _sprites;
        }
        
        /**
         * 스프라이트 벡터에서 스프라이트를 삭제합니다.  
         * @param sprite    삭제할 스프라이트
         */
        internal function removeSprite(sprite:STSprite):void
        {
            for( var i:uint = 0; i<_sprites.length; ++i)
            {
                if( _sprites[i] == sprite )
                {
                    _sprites.splice(i, 1);
                }
            }
        }
        
        private function sortingWithDepth(lhs:STSprite, rhs:STSprite):int
        {
            if( lhs.depth < rhs.depth )
            {
                return -1;
            }
            else if( lhs.depth > rhs.depth )
            {
                return 1;
            }
            else
            {
                if( lhs.zOrder < rhs.zOrder )
                {
                    return -1;
                }
                else if( lhs.zOrder > rhs.zOrder )
                {
                    return 1;
                }
                else
                {
                    return 0;
                }
            }
        }
        
    }
}