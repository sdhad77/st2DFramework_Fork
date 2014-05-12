package com.sundaytoz.st2D.display
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.utils.AssetLoader;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.textures.Texture;
    import flash.geom.Matrix;
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;
    
    public class STSprite
    {
        private var _globalPosition:Vector3D = new Vector3D();
        private var _zOrder:int;
        
        private var _texture:Texture;
        private var _textureData:Bitmap;
        
        private var _modelMatrix:Matrix3D = new Matrix3D();
        
        private var _tag:int;
        
        private var _rotation:Vector3D = new Vector3D();
        
        private static var _meshIndexData:Vector.<uint> = Vector.<uint>  ([ 0, 1, 2, 0, 2, 3, ]);
        private var _meshVertexData:Vector.<Number> = Vector.<Number>([
                            //X,  Y,  Z,   U, V,   nX, nY, nZ		
                            -1, -1,  1,   0, 0,   0,  0,  1,
                            1, -1,  1,   1, 0,   0,  0,  1,
                            1,  1,  1,   1, 1,   0,  0,  1,
                            -1,  1,  1,   0, 1,   0,  0,  1
                        ]);
                        
        
        private var _vertexBuffer:VertexBuffer3D;
        private var _indexBuffer:IndexBuffer3D;
               
        public function STSprite()
        {
            _meshVertexData 
            
            trace(_meshVertexData[0]);
        }

        public function setTextureWithBitmap(bitmap:Bitmap, useMipMap:Boolean=true):void
        {
            var context:Context3D = StageContext.instance.context; 
            if( context == null )
            {
                throw new Error("먼저 StageContext 를 초기화 한뒤 사용해주세요");
                return ;
            }
            
            _texture = context.createTexture(bitmap.width, bitmap.height, Context3DTextureFormat.BGRA, false);
            if( useMipMap )
            {
                uploadTextureWithMipmaps(_texture, bitmap.bitmapData);                
            }
            
            _vertexBuffer = context.createVertexBuffer(_meshVertexData.length/8, 8); 
            _vertexBuffer.uploadFromVector(_meshVertexData, 0, _meshVertexData.length/8);
            
            _indexBuffer = context.createIndexBuffer(_meshIndexData.length);
            _indexBuffer.uploadFromVector(_meshIndexData, 0, _meshIndexData.length);
            
            STSpriteManager.instance.addSprite( this );
        }
        
        public function setTextureWithString(path:String):void
        {
            var context:Context3D = StageContext.instance.context; 
            if( context == null )
            {
                throw new Error("먼저 StageContext 를 초기화 한뒤 사용해주세요");
                return ;
            }
            
            AssetLoader.instance.loadImageTexture(path, onComplete);
            
            function onComplete(object:Object):void
            {
                setTextureWithBitmap(object as Bitmap);
            }
        }
        
        public function update():void
        {
            _modelMatrix.identity();
            
            // scale
            
            // rotate
            _modelMatrix.appendRotation(_rotation.x, Vector3D.Y_AXIS);
            _rotation.x += 1.0;
            
            // translate
            _modelMatrix.appendTranslation(_globalPosition.x, _globalPosition.y, _globalPosition.z);
            
        }

        public function setPosition(position:Vector3D):void
        {
            _globalPosition = position;
        }
        
        public function setUVCoord(x:Number, y:Number, width:Number, height:Number):void
        {
            _meshVertexData[3] = x;
            _meshVertexData[4] = y;
            
            _meshVertexData[3+8] = x+width;
            _meshVertexData[4+8] = y;
            
            _meshVertexData[3+8*2] = x+width;
            _meshVertexData[4+8*2] = y+height;
            
            _meshVertexData[3+8*3] = x;
            _meshVertexData[4+8*3] = y+height;
        }
        
        /**
         * 밉맵을 만듭니다. 
         */
        private function uploadTextureWithMipmaps(dest:Texture, src:BitmapData):void
        {
            var ws:int = src.width;
            var hs:int = src.height;
            var level:int = 0;
            var tmp:BitmapData;
            var transform:Matrix = new Matrix();
            
            tmp = new BitmapData(src.width, src.height, true, 0x00000000);
            
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
                    tmp = new BitmapData(ws, hs, true, 0x00000000);
                }
            }
            tmp.dispose();
        }
        
        /** Property */
        public function get numTriangle():int
        {
            return _meshIndexData.length/3;
        }
        public function get vertexBuffer():VertexBuffer3D
        {
            return _vertexBuffer;
        }
        
        public function get indexBuffer():IndexBuffer3D
        {
            return _indexBuffer;
        }
        
        public function get texture():Texture
        {
            return _texture;
        }
        
        public function get modelMatrix():Matrix3D
        {
            return _modelMatrix;
        }
        public function set modelMatrix(modelMatrix:Matrix3D):void
        {
            _modelMatrix = modelMatrix;
        }
        
        public function get tag():int
        {
            return _tag;
        }
        public function set tag(tag:int):void
        {
            _tag = tag;
        }
        
        public function get zOrder():int
        {
            return _zOrder;
        }
        public function set zOrder(zOrder:int):void
        {
            _zOrder = zOrder;
        }
        
    }
}