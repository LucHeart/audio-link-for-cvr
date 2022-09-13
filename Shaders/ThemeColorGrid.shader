﻿Shader "AudioLink/Internal/ThemeColorGrid"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "AudioLink.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                uint2 themeColorLocation = (i.uv.y > .5) ?
                    ((i.uv.x < .5)? ALPASS_THEME_COLOR0 : ALPASS_THEME_COLOR1) :
                    ((i.uv.x < .5)? ALPASS_THEME_COLOR2 : ALPASS_THEME_COLOR3);
                fixed3 themeColor = AudioLinkData(themeColorLocation).rgb;
                fixed4 col = tex2D(_MainTex, i.uv);
                themeColor = lerp(themeColor, col.rgb, col.a *.25);
                return fixed4(themeColor, 1);
            }
            ENDCG
        }
    }
}
