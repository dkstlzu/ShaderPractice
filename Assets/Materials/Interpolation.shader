Shader "Tutorial/009_Interpolation"
{
	// Properties
    // {
	// 	_Color ("Tint", Color) = (0, 0, 0, 1)
    //     _SecondaryColor ("Second", Color) = (1, 1, 1, 1)
    //     _Blend ("Blend", Range(0, 1)) = 0
	// }

	// SubShader
    // {
	// 	Tags{ "RenderType"="Opaque" "Queue"="Geometry" }

	// 	Pass{
	// 		CGPROGRAM

	// 		#include "UnityCG.cginc"

	// 		#pragma vertex vert
	// 		#pragma fragment frag

    //         float _Blend;

	// 		fixed4 _Color;
	// 		fixed4 _SecondaryColor;

	// 		struct appdata{
	// 			float4 vertex : POSITION;
	// 		};

	// 		struct v2f{
	// 			float4 position : SV_POSITION;
    //         };

	// 		v2f vert(appdata v){
	// 			v2f o;
	// 			o.position = UnityObjectToClipPos(v.vertex);
	// 			return o;
	// 		}

	// 		//the fragment shader function
	// 		fixed4 frag(v2f i) : SV_TARGET{
	// 			fixed4 col = lerp(_Color, _SecondaryColor, _Blend);
	// 			return col;
	// 		}

	// 		ENDCG
	// 	}
	// }

	Properties
    {
		_MainTex ("Tint", 2D) = "white" {}
        _SecondaryTex ("Second", 2D) = "black" {}
        _BlendTex ("Blend", 2D) = "balck" {}
	}

	SubShader
    {
		Tags{ "RenderType"="Opaque" "Queue"="Geometry" }

		Pass{
			CGPROGRAM

			#include "UnityCG.cginc"

			#pragma vertex vert
			#pragma fragment frag

            sampler2D _BlendTex;
            fixed4 _BlendTex_ST;

			sampler2D _MainTex;
			fixed4 _MainTex_ST;
			sampler2D _SecondaryTex;
			fixed4 _SecondaryTex_ST;

			struct appdata{
				float4 vertex : POSITION;
                float2 uv : TEXCOORD;
			};

			struct v2f{
				float4 position : SV_POSITION;
                float2 uv : TEXCOORD;
            };

			v2f vert(appdata v){
				v2f o;
				o.position = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
				return o;
			}

            //the fragment shader
            fixed4 frag(v2f i) : SV_TARGET{
                //calculate UV coordinates including tiling and offset
                // float2 main_uv = TRANSFORM_TEX(i.uv, _MainTex);
                // float2 secondary_uv = TRANSFORM_TEX(i.uv, _SecondaryTex);

                //read colors from textures
                fixed4 main_color = tex2D(_MainTex, i.uv);
                fixed4 secondary_color = tex2D(_SecondaryTex, i.uv);
                fixed4 blend_value = tex2D(_BlendTex, i.uv);

                //interpolate between the colors
                fixed4 col = lerp(main_color, secondary_color, blend_value.r);
                return col;
            }

			ENDCG
		}
	}
    
	Fallback "VertexLit"
}