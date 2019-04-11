// Conway's game of life

#ifdef GL_ES
precision highp float;
#endif

#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform int adjacentMultiplier;
uniform int diagonalMultiplier;
uniform int threshold;

uniform sampler2D ppixels;
uniform sampler2D drawLayer;

uniform sampler2D kernel;
uniform ivec2 kernelSize;

vec4 live = vec4(1,1,1,1);
vec4 dead = vec4(0.,0.,0.,1.);
vec4 blue = vec4(0.,0.,1.,1.);

void main( void ) {
	vec2 position = (gl_FragCoord.xy / resolution.xy);
	vec2 pixel = 1./resolution;

	float sum = 0.;

	for (int x = 0; x < kernelSize.x; x++) {
		for (int y = 0; y < kernelSize.y; y++) {
			vec2 offset = vec2(x - floor(kernelSize.x/2.), y - floor(kernelSize.y/2.));
			// float kernelValue = kernel[x * kernelSize.x + y];
			float kernelValue = texture2D(kernel, vec2(kernelSize.x - x - 0.5, kernelSize.y - y - 0.5) / kernelSize).g * 10 - 5;
			sum += texture2D(ppixels, position + pixel * offset).g * kernelValue;
		}
	}
	vec4 me = texture2D(ppixels, position);
	vec4 drawLayerPixel = texture2D(drawLayer, position);
	float b = 0.2126*drawLayerPixel.r + 0.7152*drawLayerPixel.g + 0.0722*drawLayerPixel.b;

	drawLayerPixel = b > 0.5 ? vec4(1,1,1,1) : vec4(0,0,0,0);

	if (me.g == 0 && sum > position.y * 5) {
		gl_FragColor = live + drawLayerPixel;
	} else {
		gl_FragColor = dead + drawLayerPixel;
	}
}