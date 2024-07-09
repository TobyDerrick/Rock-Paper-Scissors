shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0);
uniform float diamond_size = 10.;
uniform bool reverse = false;


void fragment(){
	float xFraction = fract(FRAGCOORD.x / diamond_size);
	float yFraction = fract(FRAGCOORD.y /diamond_size);
	
	float xDistance = abs(xFraction - 0.5);
	float yDistance = abs(yFraction - 0.5);
	
	if(reverse == false){
		if (xDistance + yDistance + UV.x + UV.y > progress * 4.){
			discard;
			}
	}
	
	if (reverse == true){
		if (xDistance + yDistance + UV.x + UV.y < progress * 4.){
			discard;
			}
	}
	
}

