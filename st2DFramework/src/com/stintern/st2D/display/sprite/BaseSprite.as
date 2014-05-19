package com.stintern.st2D.display.sprite
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.textures.Texture;
    import flash.geom.Matrix;

    public class BaseSprite extends STObject
    {
        private var _path:String;
        
        private var _texture:Texture = null;
        private var _textureData:Bitmap = null;
        
        private var _indexData:Vector.<uint> = new Vector.<uint>();
        private var _vertexData:Vector.<Number> = new Vector.<Number>(); 
        
        private var _vertexBuffer:VertexBuffer3D;
        private var _indexBuffer:IndexBuffer3D;
        
        public function BaseSprite()
        {
            super();
        }
        
        /**
         * 밉맵을 만듭니다. 
         */
        protected function uploadTextureWithMipmaps(dest:Texture, src:BitmapData):void
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
        
        public function get path():String
        {
            return _path;
        }
        public function set path(path:String):void
        {
            _path = path;
        }
        
        public function get texture():Texture
        {
            return _texture;
        }
        public function set texture(texture:Texture):void
        {
            _texture = texture;
        }
        
        
        public function get textureData():Bitmap
        {
            return _textureData;
        }
        public function set textureData(bitmap:Bitmap):void
        {
            _textureData = bitmap;
        }
        
        public function get vertexData():Vector.<Number>
        {
            return _vertexData;
        }
        public function set vertexData(vertexData:Vector.<Number>):void
        {
            _vertexData = vertexData;
        }
        
        public function get indexData():Vector.<uint>
        {
            return _indexData;
        }
        public function set indexData(indexData:Vector.<uint>):void
        {
            _indexData = _indexData;
        }
        
        public function get vertexBuffer():VertexBuffer3D
        {
            return _vertexBuffer;
        }
        public function set vertexBuffer(vertexBuffer:VertexBuffer3D):void
        {
            _vertexBuffer = vertexBuffer;
        }
        
        public function get indexBuffer():IndexBuffer3D
        {
            return _indexBuffer;
        }
        public function set indexBuffer(indexBuffer:IndexBuffer3D):void
        {
            _indexBuffer = indexBuffer;
        }
    }
}