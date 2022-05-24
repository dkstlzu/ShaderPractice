Shader "Tutorial/010_TriplanarMapping"{
	Properties{
		_Color ("Tint", Color) = (0, 0, 0, 1)
		_MainTex ("Texture", 2D) = "white" {}
        _Sharpness ("Blend Sharpness", Range(1, 64)) = 1
	}

	SubShader{
		//the material is completely non-transparent and is rendered at the same time as the other opaque geometry
		Tags{ "RenderType"="Opaque" "Queue"="Geometry" }

		Pass{
			CGPROGRAM

			#include "UnityCG.cginc"

			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex;
			float4 _MainTex_ST;

			fixed4 _Color;
            float _Sharpness;

			struct appdata{
				float4 vertex : POSITION;
                float3 normal : NORMAL;
			};

			struct v2f{
				float4 position : SV_POSITION;
				float3 worldPos : TEXCOORD0;
                float3 normal : NORMAL;
			};

			v2f vert(appdata v){
				v2f o;
				o.position = UnityObjectToClipPos(v.vertex);
                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldPos = worldPos.xyz;
                float3 worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
                o.normal = normalize(worldNormal);
				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET{
                float2 uv_front = TRANSFORM_TEX(i.worldPos.xy, _MainTex);
                float2 uv_side = TRANSFORM_TEX(i.worldPos.zy, _MainTex);
                float2 uv_top = TRANSFORM_TEX(i.worldPos.xz, _MainTex);

                fixed4 col_front = tex2D(_MainTex, uv_front);
                fixed4 col_side = tex2D(_MainTex, uv_side);
                fixed4 col_top = tex2D(_MainTex, uv_top);

                float3 weight = i.normal;
                weight = abs(weight);
                weight /= weight.x + weight.y + weight.z;
                weight = pow(weight, _Sharpness);

                col_front *= weight.z;
                col_side *= weight.x;
                col_top *= weight.y;
                
                fixed4 col = col_front + col_side + col_top;
                
				col *= _Color;

				return col;
			}

			ENDCG
		}
	}
	FallBack "Standard"
}

