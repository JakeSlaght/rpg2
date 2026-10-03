shader_type canvas_item;

uniform int color_selected = 0; //0 is DEFAULT

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 texture_default = texture(TEXTURE, UV);
	vec4 default_color = vec4(texture_default.r,texture_default.g,texture_default.b,texture_default.a);
	vec4 color_replacement = default_color;
	
	// { "LILAC": 6 }
	switch(color_selected) {
		case 0:
			color_replacement = default_color;
			break;
		case 1:
			color_replacement = vec4(texture_default.r, texture_default.g, 1.0, texture_default.a);
			break;
		case 2:
			color_replacement = vec4(1.0, texture_default.g, texture_default.b, texture_default.a);
			break;
		case 3:
			color_replacement = vec4(texture_default.r, 1.0, texture_default.b, texture_default.a);
			break;
		case 4:
			color_replacement = vec4(1.0, 1.0, texture_default.b, texture_default.a);
			break;
		case 5:
			color_replacement = vec4(1.0, texture_default.b, 1.0, texture_default.a);
			break;
		case 6:
			color_replacement = vec4(1.0, 0.647059, texture_default.b, texture_default.a);
			break;
	}
	
	// 1, 0, 1
	COLOR = color_replacement;
}
