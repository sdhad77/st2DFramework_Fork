package com.sundaytoz.st2D.display
{
    import com.adobe.utils.PerspectiveMatrix3D;
    import com.sundaytoz.st2D.basic.StageContext;
    
    import flash.display3D.Context3D;
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DCompareMode;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.geom.Matrix3D;
    

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
            
            
            context.setDepthTest(true, Context3DCompareMode.LESS);
            
            for each( var sprite:STSprite in _sprites )
            {
                // 화면 밖의 스프라이트 인지 검사
                
                // 화면 안의 스프라이트인 경우 출력
                
                
                context.setProgram( StageContext.instance.shaderProgram );
                context.setTextureAt(0, sprite.texture);
                context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
                
                sprite.update();
                
                modelViewProjection.identity();
                modelViewProjection.append(sprite.modelMatrix );
                modelViewProjection.append(StageContext.instance.viewMatrix);
                modelViewProjection.append(StageContext.instance.projectionMatrix);
                
                context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, modelViewProjection, true);
                
                // position
                context.setVertexBufferAt(0, sprite.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
                // tex coord
                context.setVertexBufferAt(1, sprite.vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
                // vertex rgba
                context.setVertexBufferAt(2, sprite.vertexBuffer, 8, Context3DVertexBufferFormat.FLOAT_4);
                
                
                context.drawTriangles(sprite.indexBuffer, 0, sprite.numTriangle);
                
            }
            context.present();
        }
        
    }
}