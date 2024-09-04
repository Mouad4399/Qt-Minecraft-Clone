void MAIN()
{
    vec4 baseColor = texture(baseTexture, UV0);
    vec4 crackColor = texture(crackTexture, UV0);

    // Blend the textures using the alpha of the crack texture
    vec4 blendedColor ;

    if(progress==0 || crackColor.a < 0.1){
        blendedColor = (baseColor);
    }else{
        // crackColor = vec4( 0.9,0.9,0.9 , 1 );
        // blendedColor.a=.1;
        // baseColor.a=0.6;
        blendedColor= baseColor *0.4+ vec4(0.1,0.1,0.1,1)*0.6;
        // discard;
    }

    // Apply gamma correction to make colors more vibrant
    vec3 correctedColor = pow(blendedColor.rgb, vec3(2));

    // Set the final color
    BASE_COLOR  = vec4(correctedColor, blendedColor.a);
    // FRAGCOLOR =  BASE_COLOR;


}
