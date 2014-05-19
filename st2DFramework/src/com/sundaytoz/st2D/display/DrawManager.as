package com.sundaytoz.st2D.display
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.utils.GameStatus;
    
    import flash.display3D.Context3D;
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DCompareMode;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.geom.Matrix3D;

    public class DrawManager
    {
        private var _modelViewProjection:Matrix3D = new Matrix3D();
        
        public function DrawManager()
        {
        }
        
        /**
         * 현재 Scene 에 있는 레이어의 순서에 따라 레이어를 출력합니다. 
         */
        public function draw():void
        {
            var context:Context3D = StageContext.instance.context;
            
            context.clear(1, 1, 1);
            
            context.setDepthTest(false, Context3DCompareMode.LESS);            
            context.setProgram( StageContext.instance.shaderProgram );
            
            var layers:Array = SceneManager.instance.getCurrentScene().layerArray
            for( var i:uint=0; i<layers.length; ++i)
            {
                var layer:Layer = layers[i] as Layer;
                drawSprites( layer.getAllSprites() );
                
                if( layer.batchSprite != null )
                {
                    layer.batchSprite.draw();
                }
            }
            
            context.present();
        }
        
        /**
         * 레이어에 등록한 모든 스프라이트들을 출력합니다. 
         */
        public function drawSprites(sprites:Array):void
        {
            var context:Context3D = StageContext.instance.context;
            
            for each( var sprite:STSprite in sprites )
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
    }
}