Shader "Learning/GerstnerWater"
{
    Properties
    {
        _BaseColor("Base Color", COLOR) = (74, 162, 255, 1)

        _WhiteCapColor("White Cap Color Color", COLOR) = (1, 1, 1, 1)
        _WhiteCaps("White Caps", Float) = 0.5

        _WaveA ("Wave A", Vector) = (1,0,0.5,10)//Rough names for testing
	_WaveB ("Wave B", Vector) = (0,1,0.25,20)
	_WaveC ("Wave C", Vector) = (1,1,0.15,10)
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent" 
            "RenderPipeline" = "UniversalRenderPipeline"
        }

        Pass
        {
            Name "Gerstner Waves"
            HLSLPROGRAM
            
            #pragma target 4.5
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
            };
 
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 normal : NORMAL;
            };

            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                half4 _WhiteCapColor;
            CBUFFER_END

            float4 GerstnerWave(float4 wave, float4 p, float3 tangent, float3 binormal)
            {
                float steepness = wave.z;
                float wavelength = wave.w;
                float k = 2 * 3.14 / wavelength;
                float c = sqrt(9.8 / k);
                float2 d = normalize(wave.xy);
                float f = k * (dot(d, p.xz) - c * _Time.y);
                float a = steepness / k;

                tangent += float3
                (
                    1 - d.x * d.x * (steepness * sin(f)),
                    d.x * (steepness * cos(f)),
                    -d.x * d.y * (steepness * sin(f))
                );
                binormal += float3
                (
                    -d.x * d.y * (steepness * sin(f)),
                    d.y * (steepness * cos(f)),
                    1 - d.y * d.y * (steepness * sin(f))
                );
                return float4
                (
                    d.x * (a * cos(f)),
                    a * sin(f),
                    d.y * (a * cos(f)),
                    0
                );
            }

            float4 _WaveA, _WaveB, _WaveC;
            float _WhiteCaps;

            v2f vert (appdata v)
            {
                v2f o;

                float4 gridPoint = mul(unity_ObjectToWorld, v.vertex);
		float3 tangent = float3(1, 0, 0);
		float3 binormal = float3(0, 0, 1);
		float3 p = gridPoint;

		p += GerstnerWave(_WaveA, gridPoint, tangent, binormal);
		p += GerstnerWave(_WaveB, gridPoint, tangent, binormal);
		p += GerstnerWave(_WaveC, gridPoint, tangent, binormal);

		gridPoint.xyz = p;

		v.vertex = mul(unity_WorldToObject, gridPoint);
		
                v.normal = normalize(v.vertex);

                o.vertex = TransformObjectToHClip(v.vertex.xyz);
                o.normal = v.normal;

                return o;
            }

            half4 frag(v2f IN) : SV_TARGET
            {
                return _BaseColor + (_WhiteCapColor * (saturate(IN.normal.y) * _WhiteCaps));
            }
            
            ENDHLSL
        }
    }
}
