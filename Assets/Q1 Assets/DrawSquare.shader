Shader "Custom/DrawSquare"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_Center("Center", Vector) = (0, 0, 0, 0)
		_Length("Radius", Float) = 10
		_BandColor("Band color", Color) = (1, 0, 0, 1)
		_BandWidth("Band width", Float) = 2
		_BandFade("Band fade", Float) = 0.2
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard fullforwardshadows

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			sampler2D _MainTex;

			struct Input
			{
				float2 uv_MainTex;
				float3 worldPos;
			};

			//Square information
			half _Glossiness;
			half _Metallic;
			fixed4 _Color;
			float3 _Center;
			float _Length;
			fixed4 _BandColor;
			float _BandWidth;
			float _BandFade;

			// #pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o)
			{
				// Albedo comes from a texture tinted by color
				fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
				o.Albedo = c.rgb;
				// Metallic and smoothness come from slider variables
				o.Metallic = _Metallic;
				o.Smoothness = _Glossiness;
				o.Alpha = c.a;


				// Draw square
				// Compute if object center + length contains current fragment
				
				
				
				if ((_Center.x + _Length >= IN.worldPos.x) && (_Center.x - _Length <= IN.worldPos.x) &&
					(_Center.z + _Length >= IN.worldPos.z) && (_Center.z - _Length <= IN.worldPos.z)) {
					// We are inside the square
					o.Albedo = _BandColor;
				}
				float newLength = _Length - _BandWidth;

				//Compute inner square
				if ((_Center.x + newLength >= IN.worldPos.x) && (_Center.x - newLength <= IN.worldPos.x) &&
					(_Center.z + newLength >= IN.worldPos.z) && (_Center.z - newLength <= IN.worldPos.z)) {
					// We are inside the square
					o.Albedo = c.rgb;
				}
			}
			ENDCG
		}
			FallBack "Diffuse"
}
