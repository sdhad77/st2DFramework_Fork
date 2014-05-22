package com.stintern.st2D.display.sprite
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.AnimationFrame;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.utils.AssetLoader;
    import com.stintern.st2D.utils.Vector2D;
    
    import flash.display.Bitmap;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DTextureFormat;
    import flash.geom.Matrix3D;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.Vector3D;
    
    public class Sprite extends DisplayObjectContainer 
    {
        private var _scale:Vector2D = new Vector2D(1.0, 1.0);
        private var _rotateAxis:Vector3D = new Vector3D(0.0, 0.0, 0.0);
        private var _rotateDegree:Number = 0;
        
        private var _frame:Rectangle = new Rectangle(0, 0, 0, 0);
        private var _depth:Number = 0;

        private var _modelMatrix:Matrix3D = new Matrix3D();
        
        /**
        *  이미지를 연속해서 생성할 때 AssetLoader 가 이미지를 비동기적으로 불러오면서 용량이 작아 먼저 불려진 이미지가 
        *  STSpriteManager 의 STSprite 컨테이너에 먼저 추가되서 출력 시 먼저 그려질 수 가 있기 때문에 이를 방지하기 위해
        *  Sprite 를 생성한 순서를 가짐
         */
        private var _zOrder:int = -1;  // 이미지가 생성된 순서 
        
        private var _isMoving:Boolean;
        private var _increaseX:Number;         //지금 움직이는중이면 얼마만큼씩 움직여야 하는지
        private var _increaseY:Number;         //지금 움직이는중이면 얼마만큼씩 움직여야 하는지
        private var _destX:int;                //이동중일때 목적지의 좌표
        private var _destY:int;                //이동중일때 목적지의 좌표
               
        public function Sprite()
        {
            super();
            
            indexData.push( 0, 1, 2, 0, 2, 3 );
            vertexData.push(
                    //X, Y, Z,              U, V,            R,  G, B, A
                    -0.5, 0.5,  0.5,      0,  0,              1.0,1.0,1.0,1.0,
                    0.5,  0.5,  0.5,      1,  0,             0.0,0.0,1.0,1.0,
                    0.5,  -0.5, 0.5,      1,  1,             0.0,1.0,0.0,1.0,
                    -0.5, -0.5, 0.5,      0,  1,             1.0,0.0,0.0,1.0
                );
            
            _isMoving = false;
            _increaseX = 0;
            _increaseY = 0;
            _destX = 0;
            _destY = 0;
        }
        
        /**
         * 파일 경로를 이용해서 스프라이트를 생성합니다.  
         * @param path  이미지 경로
         * @param onCreated 스프라이트가 생성된 후 불려질 콜백 함수
         * @param onProgress 스프라이트가 생성되는 과정에서 불려질 콜백 함수
         * @param x 스프라이트를 처음에 위치시킬 X 좌표
         * @param y 스프라이트를 처음에 위치시킬 Y 좌표
         */
        public function createSpriteWithPath(path:String, onCreated:Function, onProgress:Function = null,  x:Number=0, y:Number=0 ):void
        {
            this.path = path;
            
            position.x = x;
            position.y = y;
                        
            AssetLoader.instance.loadImageTexture(path, onComplete, onProgress);
            function onComplete(object:Object, zOrder:uint):void
            {
                this.zOrder = zOrder;
                
                initBuffer();
                initTexture((object as Bitmap));
                
                update();
                
                onCreated();
            }
        }
        
        /**
         * 생성한 BatchSprite 를 통해서 새로운 Sprite를 만듭니다.  
         * @param batchSprite 사용할 Batch sprite
         * @param imageName 스프라이트 이미지에서 사용할 이미지 이름
         * @param onCreated 생성 후 호출될 콜백 함수
         * @param x 새로운 Sprite 의 초기 X 위치
         * @param y 새로운 Sprite 의 초기 Y 위치
         */
        public function createSpriteWithBatchSprite(batchSprite:BatchSprite, imageName:String, x:Number = 0, y:Number=0):void
        {
            getSpriteInBatchSprite(batchSprite, imageName);
            
            this.path = batchSprite.path;
            
            position.x = x;
            position.y = y;
            
            this.zOrder = AssetLoader.instance.increaseImageNo();
            
            update();
        }
        
        /**
         * 배치스프라이트를 사용하는 Sprite 일 경우 배치스프라이트 내부에 있는 이미지로 변경할 수 있습니다. 
         * @param batchSprite 사용하고 있는 배치스프라이트
         * @param imageName 사용할 이미지의 이름
         */
        public function getSpriteInBatchSprite(batchSprite, imageName):void
        {
            if( batchSprite == null )
            {
                throw new Error("batchSprite is null");
            }
            
            // BatchSprite 에서 사용할 이미지의 UV 좌표를 읽어옵니다.
            var uvCoord:Array = getUVCoord(batchSprite, imageName);
            if( uvCoord == null )
            {
                throw new Error("아직 애니메이션 데이터가 로딩중입니다.");  
            }
            updateUVCoord(uvCoord);
        }
        
        /**
         * Batchsprite 이미지에서 스프라이트가 사용할 이미지의 uv 좌표를 알아옵니다. 
         * @param imageName xml 상에 기입된 이미지의 이름
         * @return uv 좌표
         */
        private function getUVCoord(batchSprite:BatchSprite, imageName:String):Array
        {
            var uvCoord:Array = new Array();
            
            //Batchsprite 이미지에 이미지가 하나만 존재하여 xml파일을 사용하지 않는 경우
            if(AnimationData.instance.animationData[batchSprite.path]["type"] == 0)
            {
                frame.width = batchSprite.textureData.width;
                frame.height = batchSprite.textureData.height;
                
                uvCoord.push(0, 0);   //left top
                uvCoord.push(1, 0);   //right top
                uvCoord.push(1, 1);   //right bottom
                uvCoord.push(0, 1);   //left bottom
                
                return uvCoord;
            }
            
            //Batchsprite 이미지에 이미지가 여러개 존재하여 xml 파일을 사용하는 경우
            if(AnimationData.instance.animationData[batchSprite.path]["type"] == 1)
            {
                if(AnimationData.instance.animationData[batchSprite.path]["available"] == true)
                {
                    //현재 프레임 정보
                    var tempFrame:AnimationFrame = AnimationData.instance.animationData[batchSprite.path]["frame"][imageName];
                    
                    //uv좌표 변경하는 방식
                    frame.width = tempFrame.width;
                    frame.height = tempFrame.height;
                    
                    var width:uint = batchSprite.textureWidth;
                    var height:uint = batchSprite.textureHeight;
                    
                    uvCoord.push(tempFrame.x/width, tempFrame.y/height);                                                                                            //left top
                    uvCoord.push(tempFrame.x/width + tempFrame.width/width, tempFrame.y/height);                                                    //right top
                    uvCoord.push(tempFrame.x/width + tempFrame.width/width, tempFrame.y/height + tempFrame.height/height);             //right bottom
                    uvCoord.push(tempFrame.x/width, tempFrame.y/height + tempFrame.height/height);                                                  //left bottom
                    
                    tempFrame = null;
                    
                    return uvCoord;
                }
            }
            
            return null;
        }
        
        /**
         * 스프라이트의 VertexData UV 좌표를 갱신합니다. 
         * @param uvCoord 갱신할 UV 좌표
         */
        private function updateUVCoord(uvCoord:Array):void
        {
            var uvIndex:uint = 0;
            for(var i:uint=0; i<VERTEX_COUNT; i++)
            {
                vertexData[3 + i * DATAS_PER_VERTEX] = uvCoord[uvIndex++];
                vertexData[4 + i * DATAS_PER_VERTEX] = uvCoord[uvIndex++];
            }
        }
                
        /**
         * 스프라이트에 사용할 텍스쳐를 초기화합니다. 
         * @param bitmap 텍스쳐에 사용할 비트맵객체
         * @param useMipMap 비트맵 밉맵을 생성할 지 여부
         */
        public function initTexture(bitmap:Bitmap, useMipMap:Boolean=true):void
        {
            textureData = bitmap;
            _frame.width = textureData.width;
            _frame.height = textureData.height;
            
            var context:Context3D = StageContext.instance.context; 
            texture = context.createTexture(bitmap.width, bitmap.height, Context3DTextureFormat.BGRA, false);
            if( useMipMap )
            {
                uploadTextureWithMipmaps(texture, bitmap.bitmapData);                
            }
            else
            {
                texture.uploadFromBitmapData(bitmap.bitmapData);
            }
        }
        
        /**
         * 스프라이트의 Scale, Rotation, Translation 을 변경합니다. 
         */
        public function update():void
        {
            //스프라이트가 이동중이면 이동시킵니다.
            move();
            
            _modelMatrix.identity();
            
            // scale
            _modelMatrix.appendScale(_frame.width * scale.x, _frame.height * scale.y, 1);
            
            // rotate
            _modelMatrix.appendRotation( _rotateDegree, _rotateAxis );
            
            // translate
            _modelMatrix.appendTranslation(position.x, position.y, _depth);
            
        }
        
        /**
         * UV 좌표값을 입력합니다. 
         */
        public function setUVCoord(u:Number, v:Number, width:Number, height:Number):void
        {
            if(vertexBuffer != null)
            {
                vertexData[3] = u;
                vertexData[4] = v;
                
                vertexData[3+9] = u+width;
                vertexData[4+9] = v;
                
                vertexData[3+9*2] = u+width;
                vertexData[4+9*2] = v+height;
                
                vertexData[3+9*3] = u;
                vertexData[4+9*3] = v+height;
                
                vertexBuffer.uploadFromVector(vertexData, 0, vertexData.length/9);
            }
        }
        
        /**
         * 스프라이트를 확대 및 축소 시킵니다.  <br/>
         * 사용한 파라미터 axis 는 값을 복사한 뒤 null 로 셋팅됩니다.
         * @param scale 확대 및 축소 시킬 비율
         */
        public function setScale(scale:Vector2D):void
        {
            _scale.x = scale.x;
            _scale.y = scale.y;
            
            scale = null;
        }
        
        /**
         * 특정 픽셀의 길이로 스프라이트를 확대 및 축소 시킵니다. 
         */
        public function setScaleWithWidthHeight(width:uint, height:uint):void
        {
            scale.x = width / _frame.width;
            scale.y = height / _frame.height;
        }
        
        /**
         * 스프라이트를 회전시킵니다. <br/>
         * 사용한 파라미터 axis 는 값을 복사한 뒤 null 로 셋팅됩니다.
         * @param degree 회전할 각도
         * @param axis 회전 축
         */
        public function setRotate(degree:Number, axis:Vector3D):void
        {
            _rotateDegree = degree;
            _rotateAxis.x = axis.x;
            _rotateAxis.y = axis.y;
            _rotateAxis.z = axis.z;
            
            axis = null;
        }
        
        /**
         * 스프라이트를 목적지로 이동시킵니다. <br/>
         * 사용한 파라미터 dest 는 값을 복사한 뒤 null 로 셋팅됩니다.
         * @param dest 이동할 목적지
         */
        public function setTranslation(dest:Vector2D):void
        {
            //자식이 있을 경우 같이 이동
            if( hasChild() )
            {
                var children:Array = getAllChildren();
                for(var i:uint=0; i<children.length; ++i)
                {
                    var sprite:Sprite = children[i] as Sprite;
                    
                    sprite.setTranslation(new Vector2D(dest.x - position.x + sprite.position.x, dest.y -  position.y + sprite.position.y));
                }
            }
            
            position.x = dest.x;
            position.y = dest.y;
            
            dest = null;
        }
        
        
        /**
         * 사용한 자원을 해제합니다. 
         */
        public function dispose():void
        {
            AssetLoader.instance.removeImage(path);
            
            if( texture != null )
                texture.dispose();
            texture = null;
            
            if( textureData.bitmapData != null )
                textureData.bitmapData.dispose(); 
            textureData.bitmapData = null;
            
            _modelMatrix = null;
            _rotateAxis = null;
            
            _scale = null;
            position = null;
            _rotateAxis = null;
            
            position = null;
        }
        
        /**
         * 스프라이트 출력에 필요한 버퍼를 초기화합니다. 
         */
        protected function initBuffer():void
        {
            var context:Context3D = StageContext.instance.context; 
            
            vertexBuffer = context.createVertexBuffer(vertexData.length/9, 9); 
            vertexBuffer.uploadFromVector(vertexData, 0, vertexData.length/9);
            
            indexBuffer = context.createIndexBuffer(indexData.length);
            indexBuffer.uploadFromVector(indexData, 0, indexData.length);
        }
        
        /**
         * update에서 호출되는 함수로, 스프라이트를 이동시켜야 할 경우 이동시키는 함수입니다. 
         */
        private function move():void
        {
            //움직이는 중이면
            if(_isMoving)
            {
                //원하는 지점에 도달 하였으면
                if((Math.abs(_destX - position.x) <= 1) && (Math.abs(_destY - position.y) <= 1)) 
                {
                    _isMoving = false;
                }
                //원하는 지점에 아직 도달하지 못했으면
                else
                {
//                    position.x += _increaseX;
//                    position.y += _increaseY;
                    setTranslation(new Vector2D(position.x + _increaseX, position.y + _increaseY));
                }
            }
        }
        
        /**
         * 특정 좌표로 스프라이트를 이동시키는 함수입니다.</br>
         * time으로 이동 거리를 나눈값을 더해서 이동합니다. 
         * @param x 이동할 좌표 x
         * @param y 이동할 좌표 y
         * @param time 이동을 완료하는데 얼마나 시간을 걸리게 할 것인지
         */
        public function moveTo(x:int, y:int, second:int):void
        {
            _isMoving = true;
            _destX = x;
            _destY = y;
            _increaseX = (x - position.x)/(second*60);
            _increaseY = (y - position.y)/(second*60);
        }
        
        /**
         * 스프라이트의 현재 위치에서 x,y만큼 이동 시키는 함수입니다.
         * @param x 현재 좌표에 더할 좌표
         * @param y 현재 좌표에 더할 좌표
         * @param second 이동을 완료하는데 얼마나 시간을 걸리게 할 것인지
         */
        public function moveBy(x:int, y:int, second:int):void
        {
            moveTo(position.x + x, position.y + y, second);
        }
        
        /**
         * 스프라이트의 이동을 중지합니다.</br>
         * 현재 좌표에서 가장가까운 정수 좌표로 이동시키고, 목적지 좌표도 현재 좌표와 동일하도록 변경하여 중지시킵니다.
         */
        public function moveStop():void
        {
            position.x = Math.floor(position.x);
            position.y = Math.floor(position.y);
            _destX = position.x;
            _destY = position.y;
        }
        
        /**
         *  스프라이트들의 충돌을 체크합니다. (박스 체크) 
         * @param lhs 충돌 체크할 상대 스트라이트
         * @return 충돌 여부
         */
        public function collisionCheck(lhs:Sprite):Boolean
        {
            var rect1:Rectangle = new Rectangle(this.position.x - (this.width/2), this.position.y - (this.height/2), this.width, this.height);
            var rect2:Rectangle = new Rectangle(lhs.position.x - (lhs.width/2), lhs.position.y - (lhs.height/2), lhs.width, lhs.height);
            
            var result:Boolean = rect1.containsRect(rect2);
            rect1 = rect2 = null;
            
            return result;
        }
        

        /** Property */
        public function getContentWidth():Number
        {
            return frame.width * scale.x;
        }
        public function getContentHeight():Number
        {
            return frame.height * scale.y;
        }
        
        public function get numTriangle():int
        {
            return indexData.length/3;
        }
        
        public function get modelMatrix():Matrix3D
        {
            return _modelMatrix;
        }
        public function set modelMatrix(modelMatrix:Matrix3D):void
        {
            _modelMatrix = modelMatrix;
        }
       
        public function get depth():Number
        {
            return _depth;
        }
        public function set depth(depth:Number):void
        {
            _depth = depth;
        }

        
        public function get scale():Vector2D
        {
            return _scale;
        }

        public function get frame():Rectangle
        {
            return _frame;
        }
          
        public function set frame(value:Rectangle):void
        {
            _frame = value;
         }

        
        /**
        * 프레임의 가로 길이를 리턴합니다. 
        */
        public function get width():Number
        {            
            return _frame.width;
        }
        /**
        * 프레임의 세로 길이를 리턴합니다. 
        */
        public function get height():Number
        {
            return _frame.height;
        }
        
        public function get zOrder():int
        {
            return _zOrder;
        }
        public function set zOrder(zOrder:int):void
        {
            _zOrder = zOrder;
        }

        public function get isMoving():Boolean
        {
            return _isMoving;
        }

        public function set isMoving(value:Boolean):void
        {
            _isMoving = value;
        }


    }
}
