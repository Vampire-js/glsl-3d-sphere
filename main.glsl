
float sphereSDF(vec3 p, float r) {
    return length(p) - r;
}

vec3 getNormal(vec3 p) {
    vec2 e = vec2(0.001, 0); 
    return normalize(vec3(
        sphereSDF(p + e.xyy, 1.0) - sphereSDF(p - e.xyy, 1.0),
        sphereSDF(p + e.yxy, 1.0) - sphereSDF(p - e.yxy, 1.0),
        sphereSDF(p + e.yyx, 1.0) - sphereSDF(p - e.yyx, 1.0)
    ));
}

vec3 phongLighting(vec3 p, vec3 normal, vec3 lightPos, vec3 cameraPos) {
    vec3 lightDir = normalize(lightPos - p);
    vec3 viewDir = normalize(cameraPos - p);
    vec3 reflectDir = reflect(-lightDir, normal); 

    float diff = max(dot(normal, lightDir), 0.0); 
    vec3 diffuse = diff * vec3(1.0, 0.8, 0.7); 

    return diffuse;
}

float rayMarch(vec3 ro, vec3 rd) {
    float t = 0.0;
    for (int i = 0; i < 100; i++) {
        vec3 p = ro + t * rd;
        float d = sphereSDF(p, 1.0);
        if (d < 0.001) {
            return t;
        }
        t += d;
        if (t > 100.0) break;
    }
    return -1.0; 
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

   
    vec3 ro = vec3(0, 0, -1.4); 
    vec3 rd = normalize(vec3(uv, 0.3)); 

    vec3 lightPos = vec3(2.0, 2.0, -2.0);
    vec3 cameraPos = ro;


    float t = rayMarch(ro, rd);
    if (t > 0.0) {
    
        vec3 hitPos = ro + t * rd;
        vec3 normal = getNormal(hitPos);


        vec3 color = phongLighting(hitPos, normal, lightPos, cameraPos);

        fragColor = vec4(color, 1.0);
    } else {
    
        fragColor = vec4(0.1, 0.1, 0.1, 1.0);
    }
}
