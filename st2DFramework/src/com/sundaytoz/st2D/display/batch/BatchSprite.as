package com.sundaytoz.st2D.display.batch
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.BaseSprite;
    import com.sundaytoz.st2D.display.STSprite;
    import com.sundaytoz.st2D.utils.AssetLoader;
    import com.sundaytoz.st2D.utils.GameStatus;
    
    import flash.display.Bitmap;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.geom.Matrix3D;

    public class BatchSprite extends BaseSprite
    {
        private var _spriteCount:uint = 0;              //BatchSprite에 있는 Sprite 개수
        
        private var DATAS_PER_VERTEX:uint = 9;    // Vertex 당 필요한 vertex data
        private var VERTEX_COUNT:uint = 4;          // Sprite 당 필요한 Vertex 개수
        
        private var _updateRequired:Boolean = true;
        
        public function BatchSprite()
        {
        }
        
        public function dispose():void
        {
            destroyBuffers();
        }
        
        /**
         * BatchSprite 를 생성합니다. 
         * @param path BatchSprite 에 사용할 이미지 경로
         * @param onCreated 생성된 후 호출될 메소드
         * @param onProgress 생성중 진행 상황을 알 수 있는 메소드
         */
        public function createBatchSpriteWithPath(path:String, onCreated:Function, onProgress:Function = null ):void
        {
            AssetLoader.instance.loadImageTexture(path, onComplete, onProgress);
            function onComplete(object:Object, zOrder:uint):void
            {
                createBatchSpriteWithBitmap((object as Bitmap));
                
                onCreated();
            }
        }
        
        /**
         * 스프라이트에 사용할 텍스쳐를 초기화합니다. 
         * @param bitmap 텍스쳐에 사용할 비트맵객체
         * @param useMipMap 비트맵 밉맵을 생성할 지 여부
         */
        public function createBatchSpriteWithBitmap(bitmap:Bitmap):void
        {
            this.textureData = bitmap;
            
            var context:Context3D = StageContext.instance.context;
            this.texture = context.createTexture(bitmap.width, bitmap.height, Context3DTextureFormat.BGRA, false);
            uploadTextureWithMipmaps(this.texture, bitmap.bitmapData);      
        }
            
        /**
         * BatchSprite 에 새로운 Sprite 를 추가합니다. 
         * @param sprite 추가할 Sprite
         */
        public function addSprite(sprite:STSprite):void
        {
            // BatchSprite 의 텍스쳐에 sprite 의 텍스쳐가 있는지 확인
//            if( sprite.textureData != _textureData || )
//            {
//                
//            }
            
            var spriteMatrixRawData:Vector.<Number> = sprite.modelMatrix.rawData;
            var spriteVertexData:Vector.<Number> = sprite.vertexData;
            
            var targetIndex:int = _spriteCount * VERTEX_COUNT * DATAS_PER_VERTEX;
            var sourceIndex:int = 0;
            var sourceEnd:int = VERTEX_COUNT * DATAS_PER_VERTEX;
            
            // VertexData 를 생성합니다.
            while(sourceIndex < sourceEnd)
            {
                var x:Number = spriteVertexData[sourceIndex++];
                var y:Number = spriteVertexData[sourceIndex++];
                var z:Number = spriteVertexData[sourceIndex++];
                
                vertexData[targetIndex++] =   spriteMatrixRawData[0] * x + spriteMatrixRawData[1] * y + spriteMatrixRawData[2] * z + sprite.modelMatrix.position.x ;         // x
                vertexData[targetIndex++] =   spriteMatrixRawData[4] * x + spriteMatrixRawData[5] * y + spriteMatrixRawData[6] * z + sprite.modelMatrix.position.y;         // y
                vertexData[targetIndex++] =   spriteMatrixRawData[8] * x + spriteMatrixRawData[9] * y + spriteMatrixRawData[10] * z + sprite.modelMatrix.position.z;       // z
                
                vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // u 
                vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // v
                
                vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // r
                vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // g
                vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // b
                vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // a
            }
            
            // IndexData 를 생성합니다.
            for(var i:uint=_spriteCount; i<_spriteCount+1; ++i)
            {
                indexData.push(0 + i * VERTEX_COUNT);  
                indexData.push(1 + i * VERTEX_COUNT);
                indexData.push(2 + i * VERTEX_COUNT);
                indexData.push(0 + i * VERTEX_COUNT);
                indexData.push(2 + i * VERTEX_COUNT);
                indexData.push(3 + i * VERTEX_COUNT);
            }
            
            _spriteCount++;
            _updateRequired = true;
        }

        /**
         * BatchSprite 를 출력합니다. 
         */
        public function draw():void
        {
            if( _spriteCount == 0 )
                return;
            
            if( _updateRequired )
                updateBuffers();
            
            var context:Context3D = StageContext.instance.context;
            
            context.setTextureAt(0, this.texture);
            context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
            
            var mat:Matrix3D = new Matrix3D();
            mat.identity();
            mat.append(StageContext.instance.viewMatrix);
            mat.append(StageContext.instance.projectionMatrix);
            
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mat, true);
            
            context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);       // position
            context.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);      // tex coord
            context.setVertexBufferAt(2, vertexBuffer, 5, Context3DVertexBufferFormat.FLOAT_4);      // vertex rgba
                        
            context.drawTriangles(indexBuffer, 0, _spriteCount * 2);
            
            GameStatus.instance.increaseDrawCallCount();
        }
        
        /**
         * 새로운 스프라이트를 추가하였을 때 버퍼를 갱신합니다. 
         */
        private function updateBuffers():void
        {
            destroyBuffers();
            
            var numVertices:int = vertexData.length;
            var numIndices:int = indexData.length;
            var context:Context3D = StageContext.instance.context;
            
            if (numVertices == 0) 
                return;
            
            vertexBuffer = context.createVertexBuffer(numVertices/DATAS_PER_VERTEX, DATAS_PER_VERTEX);
            vertexBuffer.uploadFromVector(vertexData, 0, numVertices/DATAS_PER_VERTEX);
            
            indexBuffer = context.createIndexBuffer(numIndices);
            indexBuffer.uploadFromVector(indexData, 0, numIndices);
            
            _updateRequired = false;
        }
        
        /**
         * 버퍼를 삭제합니다. 
         */
        private function destroyBuffers():void
        {
            if (vertexBuffer)
            {
                vertexBuffer.dispose();
                vertexBuffer = null;
            }
            
            if (indexBuffer)
            {
                indexBuffer.dispose();
                indexBuffer = null;
            }
        }

    }
}