package com.sundaytoz.st2D.display
{
    import com.sundaytoz.st2D.basic.StageContext;
    
    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.geom.Matrix3D;
    import com.adobe.utils.PerspectiveMatrix3D;
    

    public class STSpriteManager
    {
        // 싱글톤 관련 변수들
        private static var _instance:STSpriteManager;
        private static var _creatingSingleton:Boolean = false;
        
        private var _sprites:Vector.<STSprite> = new Vector.<STSprite>;
        
        private var modelViewProjection:Matrix3D = new Matrix3D();
        private var viewMatrix:Matrix3D = new Matrix3D();
        private var projectionMatrix:PerspectiveMatrix3D = new PerspectiveMatrix3D();
        
        public function STSpriteManager()
        {
            if (!_creatingSingleton){
                throw new Error("[Context] 싱글톤 클래스 - new 연산자를 통해 생성 불가");
            }
        }
        
        public static function get instance():STSpriteManager
        {
            if (!_instance){
                _creatingSingleton = true;
                _instance = new STSpriteManager();
                _creatingSingleton = false;
            }
            return _instance;
        }
        
        public function addSprite(sprite:STSprite):void
        {
            // zOrder 에 맞게 추가
            
            
            _sprites.push(sprite);
        }
        
        public function drawAllSprites():void
        {
            var context:Context3D = StageContext.instance.context;
            
            context.clear(0, 0, 0);
            context.setProgram( StageContext.instance.shaderProgram );
            
            for(var i:uint=0; i<_sprites.length; ++i)
            {
                // 화면 밖의 스프라이트 인지 검사
                
                // 화면 안의 스프라이트인 경우 출력
                
                
                
                modelViewProjection.identity();
                modelViewProjection.append(_sprites[i].modelMatrix );
                modelViewProjection.append(StageContext.instance.viewMatrix);
                modelViewProjection.append(StageContext.instance.projectionMatrix);
                
                context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, modelViewProjection, true);
                context.setVertexBufferAt(0, _sprites[i].vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3); //Position
                context.setVertexBufferAt(1, _sprites[i].vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3); //Tex coord
                
                context.setTextureAt(0, _sprites[i].texture);
                context.drawTriangles(_sprites[i].indexBuffer, 0, _sprites[i].numTriangle);
                
            }
            
            context.present();
            
        }
        
            
    }
}