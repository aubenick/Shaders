Shader "Custom/ToonShader"
{
    Properties
    {
        _Color("Base Color", Color) = (1,1,1,1)
        _GradColor("Gradiant Color", Color) = (1,1,1,1)
        _LineColor("Outline Color", Color) = (1,1,1,1)
        _Thickness("Border Thickness", Range(0,1)) = 0.2
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf MyModel fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;

        };

        fixed4 _Color;
        fixed4 _LineColor;
        fixed4 _GradColor;
        float _Thickness;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        // Our own illumination model
        half4 LightingMyModel(SurfaceOutput s, half3 viewDir, UnityGI gi)
        {
            // Calculate a quantity similar to diffuse shading, 
            // but consider also the negative dot products
            float intensity = (dot(s.Normal, gi.light.dir) + 1.0) / 2.0;
            
            //Create Border
            float camDot = dot(s.Normal, viewDir);
            if (camDot < _Thickness) {
                return _LineColor;
            }

            if (intensity <= 0.5)
                intensity = 0;
            else if (intensity <= 0.7)
                intensity = 0.33;
            else if (intensity <= 0.9)
                intensity = 0.66;
            else
                intensity = 1;
            // Interpolate two colors based on the shading
            float4 c2 = _Color;
            float4 c1 = _GradColor;
            return intensity * c1 + (1 - intensity) * c2;
        }

        // We also need to add this function to define a new illumination model
        // Just use the standard function that calls "UnityGlobalIllumination"
        void LightingMyModel_GI(SurfaceOutput s, UnityGIInput data, inout UnityGI gi)
        {
            gi = UnityGlobalIllumination(data, 1.0, s.Normal);
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
