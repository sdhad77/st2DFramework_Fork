package com.sundaytoz.st2D.display.batch
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.STSprite;
    import com.sundaytoz.st2D.utils.AssetLoader;
    import com.sundaytoz.st2D.utils.GameStatus;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.textures.Texture;
    import flash.geom.Matrix;
    import flash.geom.Matrix3D;

    public class BatchSprite
    {
        private var _texture:Texture;
        private var _textureData:Bitmap;
        
        private var _indexData:Vector.<uint> = Vector.<uint>  ([ ]);
        private var _vertexData:Vector.<Number> = Vector.<Number> ([ ]);
        
        private var _vertexBuffer:VertexBuffer3D;
        private var _indexBuffer:IndexBuffer3D;
        
        private var _spriteCount:uint = 0;
        
        private var ELEMENT_PER_VERTEX:uint = 9;
        private var VERTEX_COUNT:uint = 4;
        
        private var _syncRequired:Boolean = true;
        
        public function BatchSprite()
        {
        }
        
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
            _textureData = bitmap;
            
            var context:Context3D = StageContext.instance.context;
            _texture = context.createTexture(bitmap.width, bitmap.height, Context3DTextureFormat.BGRA, false);
            
            
            uploadTextureWithMipmaps(_texture, bitmap.bitmapData);      
        }
        
        private function uploadTextureWithMipmaps(dest:Texture, src:BitmapData):void
        {
            var ws:int = src.width;
            var hs:int = src.height;
            var level:int = 0;
            var tmp:BitmapData;
            var transform:Matrix = new Matrix();
            
            var fillColor:uint = 0x00000000;
            
            tmp = new BitmapData(src.width, src.height, true, fillColor);
            
            while ( ws >= 1 && hs >= 1 )
            { 
                tmp.draw(src, transform, null, null, null, true); 
                dest.uploadFromBitmapData(tmp, level);
                transform.scale(0.5, 0.5);
                level++;
                ws >>= 1;
                hs >>= 1;
                if (hs && ws) 
                {
                    tmp.dispose();
                    tmp = new BitmapData(ws, hs, true, fillColor);
                }
            }
            tmp.dispose();
        }
            
        public function addSprite(sprite:STSprite):void
        {
            // BatchSprite 의 텍스쳐에 sprite 의 텍스쳐가 있는지 확인
//            if( sprite.textureData != _textureData || )
//            {
//                
//            }
            
            var x:Number, y:Number, z:Number;
            var rawMatrixData:Vector.<Number> = sprite.modelMatrix.rawData;

            var targetRawData:Vector.<Number>;
            
            var vertexData:Vector.<Number> = sprite.vertexData;
            
            var targetIndex:int = _spriteCount * VERTEX_COUNT * ELEMENT_PER_VERTEX;
            var sourceIndex:int = 0;
            var sourceEnd:int = VERTEX_COUNT * ELEMENT_PER_VERTEX;
            
            while(sourceIndex < sourceEnd)
            {
                x = vertexData[sourceIndex++];
                y = vertexData[sourceIndex++];
                z = vertexData[sourceIndex++];
                
                _vertexData[targetIndex++] =   rawMatrixData[0] * x + rawMatrixData[1] * y + rawMatrixData[2] * z + sprite.modelMatrix.position.x ;         // x
                _vertexData[targetIndex++] =   rawMatrixData[4] * x + rawMatrixData[5] * y + rawMatrixData[6] * z + sprite.modelMatrix.position.y;         // y
                _vertexData[targetIndex++] =   rawMatrixData[8] * x + rawMatrixData[9] * y + rawMatrixData[10] * z + sprite.modelMatrix.position.z;       // z
                
                _vertexData[targetIndex++] = vertexData[sourceIndex++];   // u 
                _vertexData[targetIndex++] = vertexData[sourceIndex++];   // v
                
                _vertexData[targetIndex++] = vertexData[sourceIndex++];   // r
                _vertexData[targetIndex++] = vertexData[sourceIndex++];   // g
                _vertexData[targetIndex++] = vertexData[sourceIndex++];   // b
                _vertexData[targetIndex++] = vertexData[sourceIndex++];   // a
            }
            
            for(var i:uint=_spriteCount; i<_spriteCount+1; ++i)
            {
                _indexData.push(0 + i * VERTEX_COUNT);  
                _indexData.push(1 + i * VERTEX_COUNT);
                _indexData.push(2 + i * VERTEX_COUNT);
                _indexData.push(0 + i * VERTEX_COUNT);
                _indexData.push(2 + i * VERTEX_COUNT);
                _indexData.push(3 + i * VERTEX_COUNT);
            }
            
            _spriteCount++;
            _syncRequired = true;
        }

        public function draw(mvpMatrix:Matrix3D):void
        {
            if( _spriteCount == 0 )
                return;
            
            if( _syncRequired )
                syncBuffers();
            
            var context:Context3D = StageContext.instance.context;
            
            context.setTextureAt(0, _texture);
            context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
            
            var mat:Matrix3D = new Matrix3D();
            mat.identity();
            //mat.append(sprite.modelMatrix );
            mat.append(StageContext.instance.viewMatrix);
            mat.append(StageContext.instance.projectionMatrix);
            
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mat, true);
            
            context.setVertexBufferAt(0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);       // position
            context.setVertexBufferAt(1, _vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);      // tex coord
            context.setVertexBufferAt(2, _vertexBuffer, 5, Context3DVertexBufferFormat.FLOAT_4);      // vertex rgba
                        
            context.drawTriangles(_indexBuffer, 0, _spriteCount * 2);
            
            GameStatus.instance.increaseDrawCallCount();
            
        }
        
        private function syncBuffers():void
        {
            if (_vertexBuffer == null)
            {
                createBuffers();
            }
            else
            {
                _vertexBuffer.uploadFromVector(_vertexData, 0, _vertexData.length);
                _indexBuffer.uploadFromVector(_indexData, 0, _indexData.length);
                _syncRequired = false;
            }
        }
        
        private function createBuffers():void
        {
            destroyBuffers();
            
            var numVertices:int = _vertexData.length;
            var numIndices:int = _indexData.length;
            var context:Context3D = StageContext.instance.context;
            
            if (numVertices == 0) return;
            
            _vertexBuffer = context.createVertexBuffer(numVertices/ELEMENT_PER_VERTEX, ELEMENT_PER_VERTEX);
            _vertexBuffer.uploadFromVector(_vertexData, 0, numVertices/ELEMENT_PER_VERTEX);
            
            _indexBuffer = context.createIndexBuffer(numIndices);
            _indexBuffer.uploadFromVector(_indexData, 0, numIndices);
            
            _syncRequired = false;
        }
        
        private function destroyBuffers():void
        {
            if (_vertexBuffer)
            {
                _vertexBuffer.dispose();
                _vertexBuffer = null;
            }
            
            if (_indexBuffer)
            {
                _indexBuffer.dispose();
                _indexBuffer = null;
            }
        }

    }
}