package com.sundaytoz.st2D.display
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.utils.AssetLoader;
    import com.sundaytoz.st2D.utils.Vector2D;
    
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
        private var _globalPosition:Vector2D;
        private var _zOrder:int;
        
        private var _texture:Texture;
        private var _textureData:Bitmap;

        private var _modelMatrix:Matrix3D = new Matrix3D();
        
        private var _tag:int;
        
        private var _path:String;
        
        private var _rotation:Vector3D = new Vector3D();
        private var _translation:Vector3D = new Vector3D();
        
        private static var _meshIndexData:Vector.<uint> = Vector.<uint>  ([ 0, 1, 2, 0, 2, 3, ]);
        private var _meshVertexData:Vector.<Number> = Vector.<Number>
                                ([
                                //X, Y, Z,              U, V,       nX, nY, nZ,     R,  G, B, A
                                -0.5, 0.5,  0.5,      0,  0,      0, 0, 1,        1.0,1.0,1.0,1.0,
                                0.5,  0.5,  0.5,      1,  0,      0, 0, 1,        0.0,0.0,1.0,1.0,
                                0.5,  -0.5, 0.5,      1,  1,      0, 0, 1,        0.0,1.0,0.0,1.0,
                                -0.5, -0.5, 0.5,      0,  1,      0, 0, 1,        1.0,0.0,0.0,1.0
                                ]);
                        
        
        private var _vertexBuffer:VertexBuffer3D;
        private var _indexBuffer:IndexBuffer3D;
               
        public function STSprite()
        {
            _globalPosition = new Vector2D(0.0, 0.0);
        }

        /**
         * Bitmap 객체를 통해서 텍스쳐를 입힙니다. 
         * @param bitmap 입힐 비트맵 객체
         * @param useMipMap MipMap 을 생성 여부
         */
        public function setTextureWithBitmap(bitmap:Bitmap, useMipMap:Boolean=true):void
        {
            _textureData = bitmap;
            
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
            else
            {
                _texture.uploadFromBitmapData(bitmap.bitmapData);
            }
            
            _vertexBuffer = context.createVertexBuffer(_meshVertexData.length/12, 12); 
            _vertexBuffer.uploadFromVector(_meshVertexData, 0, _meshVertexData.length/12);
            
            _indexBuffer = context.createIndexBuffer(_meshIndexData.length);
            _indexBuffer.uploadFromVector(_meshIndexData, 0, _meshIndexData.length);
            
            STSpriteManager.instance.addSprite( this );
        }
        
        /**
         * 이미지의 파일 경로명으로 텍스쳐를 입힙니다. 
         */
        public function setTextureWithString(path:String):void
        {
            _path = path;
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
        
        internal function update():void
        {
            _modelMatrix.identity();
            
            // scale
            _modelMatrix.appendScale(_textureData.width, _textureData.height, 1);
            
            // rotate
            
            // translate
            _modelMatrix.appendTranslation(_globalPosition.x, _globalPosition.y, 0);
            
        }
        
        /**
         * UV 좌표값을 입력합니다. 
         */
        public function setUVCoord(u:Number, v:Number, width:Number, height:Number):void
        {
            if(_vertexBuffer != null)
            {
                _meshVertexData[3] = u;
                _meshVertexData[4] = v;
                
                _meshVertexData[3+12] = u+width;
                _meshVertexData[4+12] = v;
                
                _meshVertexData[3+12*2] = u+width;
                _meshVertexData[4+12*2] = v+height;
                
                _meshVertexData[3+12*3] = u;
                _meshVertexData[4+12*3] = v+height;
                
                _vertexBuffer.uploadFromVector(_meshVertexData, 0, _meshVertexData.length/12);
            }
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
        
        public function get position():Vector2D
        {
            return _globalPosition;
        }
        public function set position(position:Vector2D):void
        {
            _globalPosition = position;
        }
        
        public function get zOrder():int
        {
            return _zOrder;
        }
        public function set zOrder(zOrder:int):void
        {
            _zOrder = zOrder;
        }
        
        /**
         * 텍스쳐의 가로 길이를 리턴합니다. 
         */
        public function get width():Number
        {            
            return _textureData.width;
        }
        /**
         * 텍스쳐의 세로 길이를 리턴합니다. 
         */
        public function get height():Number
        {
            return _textureData.height;
        }
        
        public function get textureData():Bitmap
        {
            return _textureData;
        }
        
        public function get path():String
        {
            return _path;
        }
        public function set path(path:String):void
        {
            _path = path;
        }
        
        
    }
}
