package com.stintern.st2D.display
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.DisplayObject;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.utils.GameStatus;
    
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
                if( layer.isVisible == false )
                    continue;
                
                drawSprites( layer, layer.getAllSprites() );
                
                drawBatchSprites( layer, layer.batchSpriteArray );
            }
            
            context.present();
        }

        /**
         * 레이어에 등록한 모든 스프라이트들을 출력합니다.  
         * @param layer 스프라이트들이 등록되어 있는 레이어
         * @param spriteArray 출력할 스프라이트
         */
        private function drawSprites( layer:Layer, spriteArray:Array ):void
        {
            var context:Context3D = StageContext.instance.context;
                        
            for each( var sprite:Sprite in spriteArray )
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
                _modelViewProjection.append(layer.viewMatrix);
                _modelViewProjection.append(StageContext.instance.projectionMatrix);
                
                context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _modelViewProjection, true);
                
                context.setVertexBufferAt(0, sprite.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);       // position
                context.setVertexBufferAt(1, sprite.vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);      // tex coord
                context.setVertexBufferAt(2, sprite.vertexBuffer, 5, Context3DVertexBufferFormat.FLOAT_4);      // vertex rgba
                
                context.drawTriangles(sprite.indexBuffer, 0, sprite.numTriangle);
                
                GameStatus.instance.increaseDrawCallCount();
                
                //자식 스프라이트가 있을 경우 그려줍니다.
                if( sprite.hasChild() )
                {
                    drawSprites( layer, sprite.getAllChildren() );
                }
            }
        }
        

        /**
         * BatchSprite 를 출력합니다. 
         * @param layer 출력할 BatchSprite 들이 있는 레이어
         * @param batchSpriteArray 출력할 BatchSprite 들의 배열
         * 
         */
        private function drawBatchSprites(layer, batchSpriteArray:Array):void
        {
            for(var spriteIdx:uint=0; spriteIdx<batchSpriteArray.length; ++spriteIdx)
            {
                var batchSprite:BatchSprite = (batchSpriteArray[spriteIdx] as BatchSprite);
                
                if( batchSprite.spriteArray.length == 0 )
                    continue;
                
                // 화면 밖의 스프라이트 인지 검사후 화면 밖이면 그리지 않음
                if( isInScreen(batchSprite) == false )
                    continue;
                
                if( batchSprite.updateRequired )
                    batchSprite.updateBuffers();
                
                batchSprite.updateSpriteMatrix();
                
                var context:Context3D = StageContext.instance.context;
                
                context.setTextureAt(0, batchSprite.texture);
                context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
                
                var mat:Matrix3D = new Matrix3D();
                mat.identity();
                mat.append(layer.viewMatrix);
                mat.append(StageContext.instance.projectionMatrix);
                
                context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mat, true);
                
                context.setVertexBufferAt(0, batchSprite.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);       // position
                context.setVertexBufferAt(1, batchSprite.vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);      // tex coord
                context.setVertexBufferAt(2, batchSprite.vertexBuffer, 5, Context3DVertexBufferFormat.FLOAT_4);      // vertex rgba
                
                context.drawTriangles(batchSprite.indexBuffer, 0, batchSprite.vertexData.length / (DisplayObject.VERTEX_COUNT * DisplayObject.DATAS_PER_VERTEX) * 2);
                
                GameStatus.instance.increaseDrawCallCount();
            }
        }
        
        
        
        /**
         * 스프라이트가 현재 스크린 안에 있는지 확인합니다. 
         */
        private function isInScreen(sprite:DisplayObject):Boolean
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