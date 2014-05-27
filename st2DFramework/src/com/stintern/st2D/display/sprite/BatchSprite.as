package com.stintern.st2D.display.sprite
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.utils.AssetLoader;
    
    import flash.display.Bitmap;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DTextureFormat;
    
    /**
     * 하나의 텍스쳐를 이용하는 스프라이트의 경우 BatchSprite 를 이용하여 
     * 효율적으로 화면에 출력할 수 있습니다.  
     */
    public class BatchSprite extends DisplayObject
    {
        private var _sprites:Array = new Array();
        private var _updateRequired:Boolean = true;     //Vertex, Index Buffer 를 그리기 전에 갱신해야 하는 여부
        
        /**
         * 사용한 자원을 해제합니다.
         * 내부에 저장된 스프라이트의 자원은 해제하지 않습니다. 
         */
        public function dispose():void
        {
            while(_sprites.length)
            {
                _sprites.pop();
            }
            _sprites = null;
            
            destroyBuffers();
        }
        
        /**
         * BatchSprite 를 생성합니다. 
         * @param path BatchSprite 에 사용할 이미지 경로
         * @param pathXML path로 읽어온 이미지에서 사용할 frame 정보들을 가져올 xml 경로
         * @param onCreated 생성된 후 호출될 메소드
         * @param onProgress 생성중 진행 상황을 알 수 있는 메소드
         */
        public function createBatchSpriteWithPath(path:String, pathXML:String, onCreated:Function, onProgress:Function = null ):void
        {
            this.path = path;
            
            //애니메이션 데이터를 저장할 수 있게 path를 key로 하는 dictionary를 만들고 xml 데이터를 읽어옵니다.
            if(pathXML != null) 
                AnimationData.instance.createAnimationDictionary(path, pathXML);
            //xml파일을 사용하지 않는 단일 이미지 파일 일경우에는 Dictionary를 생성만 합니다.
            else 
                AnimationData.instance.createDictionary(path);
            
            //이미지 파일을 읽어옵니다.
            AssetLoader.instance.loadImageTexture(path, onComplete, onProgress);
                        
            function onComplete(object:Object, zOrder:uint):void
            {
                //이미지파일을 저장합니다.
                createTextureData((object as Bitmap));
                
                //읽어온 데이터들을 이제 사용할 수 있다고 표시해줍니다.
                AnimationData.instance.animationData[path]["available"] = true;
                
                if(pathXML == null) onCreated();
                else
                {
                    if(onCreated != null)
                        onCreated();
                }
            }
        }
        
        public function createBatchSpriteWithSWF(path:String, onComplete:Function):void
        {
            AssetLoader.instance.loadSWF(path, onLoad);
            
            function onLoad(result:Array):void
            {
                //애니메이션 데이터를 저장할 수 있게 path를 key로 하는 dictionary를 만들고 xml 데이터를 읽어옵니다.
                AnimationData.instance.createAnimationDictionaryWithSWF(path, result[1]);
                
                createTextureData(result[0]);
                
                //읽어온 데이터들을 이제 사용할 수 있다고 표시해줍니다.
                AnimationData.instance.animationData[path]["available"] = true;
                
                onComplete();
            }
            
        }
        
        /**
         * 스프라이트에 사용할 텍스쳐를 초기화합니다. 
         * @param bitmap 텍스쳐에 사용할 비트맵객체
         */
        public function createTextureData(bitmap:Bitmap):void
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
        public function addSprite(sprite:Sprite, sortFunc:Function = null):void
        {
            _sprites.push(sprite);
            if( sortFunc != null )
            {
                _sprites.sort(sortFunc);
                resetBuffer();
            }
            else
            {
                updateBufferData(sprite);
            }
            
            _updateRequired = true;
        }
        
        /**
         * 특정 스프라이트를 배치스프라이트에서 삭제합니다. 
         * 삭제된 스프라이트는 배치스프라이트를 출력할 때 출력되지 않습니다.
         * 하지만, 스프라이트 자체의 자원은 해제되지 않습니다.
         * 스프라이트 자체의 자원을 해제하려면 스프라이트의 dispose 함수를 사용하십시오.
         *  
         * @param sprite 삭제할 스프라이트 객체
         */
        public function removeSprite(sprite:Sprite):void
        {
            var removeIndex:uint;
            
            for(var i:uint=0; i<_sprites.length; ++i)
            {
                if( _sprites[i] == sprite )
                {
                    _sprites.splice(i, 1);
                    removeIndex = i;
                    break;
                }
            }
            
            // vertexData 갱신
            vertexData.splice(removeIndex *  DisplayObject.VERTEX_COUNT * DisplayObject.DATAS_PER_VERTEX, DisplayObject.VERTEX_COUNT * DisplayObject.DATAS_PER_VERTEX )
            
            // indexData 갱신
            for(i=0; i<DisplayObject.INDEX_COUNT_PER_SPRITE; ++i)
            {
                indexData.pop()
            }
            
            _updateRequired = true;
        }
        
        /**
         * 배치스프라이트에 등록된 모든 스프라이트들을 삭제합니다. 
         */
        public function removeAllSprites():void
        {
            while( _sprites.length )
            {
                _sprites.splice(0, 1);
            }
            
            vertexData.length = 0;
            indexData.length = 0;
            
            _updateRequired = true;
        }
        
        /**
         * VertexData, IndexData 배열에 새로운 스프라이트 정보를 추가합니다. 
         * @param sprite 추가할 스프라이트
         */
        private function updateBufferData(sprite:Sprite):void
        {
            //vertexData에 새로운 스프라이트 정보를 추가합니다.
            inputVertexDataAt(_sprites.length-1, sprite);
            
            // IndexData 를 추가합니다.
            inputIndexDataAt(_sprites.length-1);
        }
        
        private function resetBuffer():void
        {
            for(var i:uint=0; i<_sprites.length; ++i)
            {
                //vertexData에 새로운 스프라이트 정보를 추가합니다.
                inputVertexDataAt(i, _sprites[i]);
                
                // IndexData 를 추가합니다.
                inputIndexDataAt(i);    
            }
            
            updateBuffers();
        }
        
        private function resetIndexData():void
        {
            indexData.length = 0;
            
            for(var i:uint=0; i<_sprites.length; ++i)
            {
                inputIndexDataAt(i);
            }
        }
        
        /**
         * 새로운 스프라이트를 추가하였을 때 버퍼를 갱신합니다. 
         */
        public function updateBuffers():void
        {
            destroyBuffers();
            
            var numVertices:int = vertexData.length;
            var numIndices:int = indexData.length;
            var context:Context3D = StageContext.instance.context;
            
            if (numVertices == 0) 
                return;
            
            vertexBuffer = context.createVertexBuffer(numVertices/DisplayObject.DATAS_PER_VERTEX, DisplayObject.DATAS_PER_VERTEX);
            vertexBuffer.uploadFromVector(vertexData, 0, numVertices/DisplayObject.DATAS_PER_VERTEX);
            
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
        
        /**
         * 배치스프라이트를 화면에 출력하기 전에 스프라이트들의 모델 매트릭스에 따른
         * VertexBuffer 를 갱신합니다. 
         */
        public function updateSpriteMatrix():void
        {
            // 갱신할 VertexData 초기화
            vertexData.length = 0;
            
            for(var i:uint=0; i<_sprites.length; ++i)
            {
                var sprite:Sprite = _sprites[i];
                
                // 스프라이트의 model matrix 갱신
                sprite.update();
                
                inputVertexDataAt(i, sprite);
            }
            
            var context:Context3D = StageContext.instance.context;
            
            // 갱신한 vertexData 에 따라 vertexBuffer 를 갱신
            var numVertices:int = vertexData.length;
            //vertexBuffer = context.createVertexBuffer(numVertices/DisplayObject.DATAS_PER_VERTEX, DisplayObject.DATAS_PER_VERTEX);
            vertexBuffer.uploadFromVector(vertexData, 0, numVertices/DATAS_PER_VERTEX);
            
            resetIndexData();
            
            var numIndices:int = indexData.length;
            //indexBuffer = context.createIndexBuffer(numIndices);
            indexBuffer.uploadFromVector(indexData, 0, numIndices);
        }
        
        /**
         * VertexData 배열을 갱신합니다. 
         * @param index VertexData 배열에서 갱신할 시작 인덱스
         * @param sprite VertexData 를 갱신할 스프라이트 객체
         */
        private function inputVertexDataAt(index:uint, sprite:Sprite):void
        {
            var spriteMatrixRawData:Vector.<Number> = sprite.modelMatrix.rawData;
            var spriteVertexData:Vector.<Number> = sprite.vertexData;
            
            var targetIndex:int = index * VERTEX_COUNT * DATAS_PER_VERTEX;
            var sourceIndex:int = 0;
            var sourceEnd:int = VERTEX_COUNT * DATAS_PER_VERTEX;
            
            while(sourceIndex < sourceEnd)
            {
                try
                {
                    var x:Number = spriteVertexData[sourceIndex++];
                    var y:Number = spriteVertexData[sourceIndex++];
                    var z:Number = spriteVertexData[sourceIndex++];
                    
                    if(sprite.isVisible == false)
                    {
                        vertexData[targetIndex++] = 0;
                        vertexData[targetIndex++] = 0;
                        vertexData[targetIndex++] = 0;
                    }
                    else
                    {
                        vertexData[targetIndex++] =   spriteMatrixRawData[0] * x + spriteMatrixRawData[1] * y + spriteMatrixRawData[2] * z + sprite.modelMatrix.position.x ;         // x
                        vertexData[targetIndex++] =   spriteMatrixRawData[4] * x + spriteMatrixRawData[5] * y + spriteMatrixRawData[6] * z + sprite.modelMatrix.position.y;         // y
                        vertexData[targetIndex++] =   spriteMatrixRawData[8] * x + spriteMatrixRawData[9] * y + spriteMatrixRawData[10] * z + sprite.modelMatrix.position.z;       // z
                    }
                    
                    vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // u 
                    vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // v
                    
                    vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // r
                    vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // g
                    vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // b
                    vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // a
                }
                catch(e:Error)
                {
                    break;
                }
            }
        }
        
        private function inputIndexDataAt(index:uint):void
        {
            indexData.push(0 + index * VERTEX_COUNT);  
            indexData.push(1 + index * VERTEX_COUNT);
            indexData.push(2 + index * VERTEX_COUNT);
            indexData.push(0 + index * VERTEX_COUNT);
            indexData.push(2 + index * VERTEX_COUNT);
            indexData.push(3 + index * VERTEX_COUNT);
        }
        
        /**
         * 현재 배치스프라이트가 이미지를 불러왔는 지 확인합니다. 
         */
        public function get imageLoaded():Boolean
        {
            if( path == null )
            {
                throw new Error("path == null");
            }
            
            if( !(path in AnimationData.instance.animationData) )
            {
                throw new Error("아직 배치스프라이트를 생성하지 않았습니다.");
            }
                        
            return AnimationData.instance.animationData[path]["available"];
        }
        
        /**
         * 배치스프라이트에 등록된 스프라이트들의 배열을 반환합니다. 
         */
        public function get spriteArray():Array
        {
            return _sprites;
        }
        
        public function get updateRequired():Boolean
        {
            return _updateRequired;
        }
    }
}