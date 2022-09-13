﻿Shader "AudioLink/Examples/Demo3"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "/Assets/AudioLink/Shaders/AudioLink.cginc"

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


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float noteno = i.uv.x * AUDIOLINK_ETOTALBINS;

                float4 spectrum_value = -AudioLinkLerpMultiline( ALPASS_DFT + float2( noteno, 0. ) ) * 0.5  + 0.55;

                //If we are below the spectrum line, discard the pixel.
                if( i.uv.y < spectrum_value.z )
                    discard;
                else if( i.uv.y < spectrum_value.z + 0.01 )
                    return 1.;

                return 0.1;
            }
            ENDCG
        }
    }
}