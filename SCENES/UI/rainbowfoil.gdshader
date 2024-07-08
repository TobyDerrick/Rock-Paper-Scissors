shader_type canvas_item;

uniform float rainbow_repetitions: hint_range(0.0, 5, 0.1);
uniform float rainbow_offset: hint_range(-2.0, 2.0, 0.1);
uniform float mask_offset = -15.0; 

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment(){
	//rainbow effect
	vec2 uv = UV;
    
    uv *= 2.0;
    uv -= vec2(1.0);
	
	float x = FRAGCOORD.x / (1.0 / SCREEN_PIXEL_SIZE.x);
	vec3 colour = hsv2rgb(vec3(x * rainbow_repetitions + rainbow_offset, 1.0, 1.0));
    
	float s = sin((x * (PI * 2.0)) + mask_offset);
	COLOR = vec4(clamp(colour * s, 0.0, 1.0), 1.0);
}