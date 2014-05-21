package com.stintern.st2D.display.sprite
{
    import com.stintern.st2D.utils.Vector2D;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.textures.Texture;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

    public class DisplayObject extends Base
    {
        private var _path:String;
        
        private var _position:Vector2D = new Vector2D(0.0, 0.0);
        
        private var _texture:Texture = null;
        private var _textureData:Bitmap = null;
        
        private var _indexData:Vector.<uint> = new Vector.<uint>();
        private var _vertexData:Vector.<Number> = new Vector.<Number>(); 
        
        private var _vertexBuffer:VertexBuffer3D;
        private var _indexBuffer:IndexBuffer3D;
        
        public var DATAS_PER_VERTEX:uint = 9;    // Vertex 당 필요한 vertex data
        public var VERTEX_COUNT:uint = 4;          // Sprite 당 필요한 Vertex 개수
        
        public function DisplayObject()
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
        
        /**
         * 텍스쳐의 가로 길이를 리턴합니다. 
         */
        public function get textureWidth():Number
        {            
            return _textureData.width;
        }
        /**
         * 텍스쳐의 세로 길이를 리턴합니다. 
         */
        public function get textureHeight():Number
        {
            return _textureData.height;
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
        
        
        
        public function get left():Number
        {
            return _position.x - this.textureData.width * 0.5;
        }
        public function get right():Number
        {
            return _position.x + this.textureData.width * 0.5;
        }
        public function get top():Number
        {
            return _position.y + this.textureData.height * 0.5;
        }
        public function get bottom():Number
        {
            return _position.y - this.textureData.height * 0.5;
        }

        public function get position():Vector2D
        {
            return _position;
        }
        public function set position(position:Vector2D):void
        {
            _position = position;
        }
    }
}