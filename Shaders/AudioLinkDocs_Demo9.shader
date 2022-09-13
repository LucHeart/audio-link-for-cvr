// Shader written by DomNomNom. MIT License.
Shader "AudioLink/Examples/Demo9"
{
    Properties
    {
        _AudioLinkBand("AudioLink Band", Int) = 0
    }
    SubShader
    {
        // Allow users to make this effect transparent.
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

        Blend SrcAlpha OneMinusSrcAlpha

        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #include "/Assets/AudioLink/Shaders/AudioLink.cginc"


            uniform uint _AudioLinkBand;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                // This is just the template vertex shader.
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }



            float4 frag (v2f i) : SV_Target
            {
                float2 grid_dimensions = float2(4,4);
                float2 uv = i.uv * grid_dimensions;
                uint2 grid_index = floor(uv);
                grid_index.y = (grid_dimensions.y-1) - grid_index.y;
                // Note: The following is a bit of a abuse of undocumented relationships between
                // ALPASS_THEME_COLOR0
                // ALPASS_THEME_COLOR1
                // ALPASS_THEME_COLOR2
                // ALPASS_THEME_COLOR3
                return AudioLinkData(ALPASS_THEME_COLOR0 + uint2(grid_index.x, 0));

            }
            ENDCG
        }
    }
}
