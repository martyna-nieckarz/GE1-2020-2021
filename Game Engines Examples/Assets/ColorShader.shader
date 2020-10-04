﻿// Upgrade NOTE: upgraded instancing buffer 'Props' to new syntax.

Shader "Custom/ColorShader" {
	Properties {
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_PositionScale("PositionScale", Range(0, 100000)) = 250
		_Fade("Fade", Range(0, 1)) = 1
		_Offset("Offset", Range(0, 100000)) = 0
	}
	SubShader {
		Tags {"Queue" = "Transparent" "RenderType"="Transparent" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard alpha:fade
         
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		
		struct Input {
			float3 worldPos;
		};

		half _Glossiness;
		half _Metallic;
		half _Fade;
		half _Offset;

		float _PositionScale;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		float3 hsv_to_rgb(float3 HSV)
		{
			float3 RGB = HSV.z;

			float var_h = HSV.x * 6;
			float var_i = floor(var_h);   // Or ... var_i = floor( var_h )
			float var_1 = HSV.z * (1.0 - HSV.y);
			float var_2 = HSV.z * (1.0 - HSV.y * (var_h - var_i));
			float var_3 = HSV.z * (1.0 - HSV.y * (1 - (var_h - var_i)));
			if (var_i == 0) { RGB = float3(HSV.z, var_3, var_1); }
			else if (var_i == 1) { RGB = float3(var_2, HSV.z, var_1); }
			else if (var_i == 2) { RGB = float3(var_1, HSV.z, var_3); }
			else if (var_i == 3) { RGB = float3(var_1, var_2, HSV.z); }
			else if (var_i == 4) { RGB = float3(var_3, var_1, HSV.z); }
			else { RGB = float3(HSV.z, var_1, var_2); }

			return (RGB);
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			
			// You should assign the variable hue to a value between 0 and 1 
            // based on the distance of the vertex from the origin. 
            // You have some input variables to work with which are:
			//IN.worldPos.x
			//and 
			//IN.worldPos.y
			//(the vertex x and y) 
            // and some functions you can use sqrt, pow, abs. 
            // And the modulus operator %
            // You can also use the built in variable _Time 
            // that gives the time in seconds since the program started. It's a float.
            // float hue = 1;
            // fixed3 c = hsv_to_rgb(float3(hue, 1, 1));
            // o.Albedo = c.rgb;
            // // Metallic and smoothness come from slider variables
            // o.Metallic = _Metallic;
            // o.Smoothness = _Glossiness;
            // o.Alpha = _Fade;

            // Albedo comes from a texture tinted by color
            float dist = sqrt(pow(IN.worldPos.x, 2) + pow(IN.worldPos.z, 2));
            // hue 0 and 1.0
			float hue = abs(((dist / 20.0f) - _Time)) % 1.0;
            fixed3 c = hsv_to_rgb(float3(hue, 1, 1));
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = _Fade;
		}
		ENDCG
	}
	FallBack "Diffuse"
}

/*
Shader "Custom/CreatureColours" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_PositionScale("PositionScale", Range(0, 1000)) = 250
		_Fade("Fade", Range(0, 1)) = 1
	}
	SubShader {
		Tags {"Queue" = "Transparent" "RenderType"="Transparent" }
		LOD 200

		ZWrite On
		Cull Back
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask RGB
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard alpha:fade

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
		};

		half _Glossiness;
		half _Metallic;
		half _Fade;

		float _PositionScale;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// You should assign the variable hue to a value between 0 and 1 
            // based on the distance of the vertex from the origin. 
            // You have some input variables to work with which are:
			//IN.worldPos.x
			//and 
			//IN.worldPos.y
			//(the vertex x and y) 
            // and some functions you can use sqrt, pow, abs. 
            // And the modulus operator %
            // You can also use the built in variable _Time 
            // that gives the time in seconds since the program started. It's a float.
            // float hue = 1;
            // fixed3 c = hsv_to_rgb(float3(hue, 1, 1));
            // o.Albedo = c.rgb;
            // // Metallic and smoothness come from slider variables
            // o.Metallic = _Metallic;
            // o.Smoothness = _Glossiness;
            // o.Alpha = _Fade;

            // Albedo comes from a texture tinted by color
            float dist = sqrt(pow(IN.worldPos.x, 2) + pow(IN.worldPos.z, 2));
            // hue 0 and 1.0
			float hue = abs(((dist / 20.0f) - _Time)) % 1.0;
            fixed3 c = hsv_to_rgb(float3(hue, 1, 1));
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = _Fade;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
*/