
h=50; // altura del cilindro
n=20; // el número de celdas en el círculo
dw=4.9; // distancia entre las caras de la celda
h1=2; // altura de la protuberancia del panal
w=0.5; // espacio entre celdas
an=30; // ángulo de inclinación de la celda

roller_diameter=27; //dimetro de mango
roller_height=30; //largo de mango

wall_thick = 10; //ancho cilindro medio (desde el diametro mango)

ds=(dw-w)/sin(360/6); //cell effective size
dc=((n*dw)/(2*PI))*2; //cylinder
dh=dw*sin(360/6); //space between rows

module st() { //cell
    difference() {
        translate([dc/2, 0,0]) rotate([0,90,0]) cylinder(h1*2, ds/2, ds/2, $fn=6, true); //main body cell
    for (r1=[0:2])
        translate([dc/2+h1, 0,0]) rotate([r1*120,0,0]) rotate([0,-an,0]) translate([0.01,-dw/2,0]) cube([h1*2,dw,dw]); //faces cell
    } // df
} // mod st;


module sotc() { //all roll
    difference() {
        union() {
            cylinder(h+0.1, dc/2, dc/2, $fn=128, true); //main cyl

            for (mz=[0,1]) mirror([0,0,mz])
                for (hn=[dh:dh*2:h/2+dh])
                    translate([0,0,hn]) mirror([0,0,mz])
                        for (r=[0:n-1]) { //add cells
                            translate([0,0,dh/2]) rotate([0,0,360/n*r]) st();
                            translate([0,0,-dh/2]) rotate([0,0,360/n/2]) rotate([0,0,360/n*r]) st();
                        } // for
        } // un
    
        for (mz=[0,1]) mirror([0,0,mz])
            translate([0,0,h/2]) cylinder(ds*2, dc/2+h1*2, dc/2+h1*2, $fn=128); //cut off cylinder top and bottom
    } // df
    
    for (mz=[0,1]) mirror([0,0,mz])
            translate([0,0,h/2]) cylinder(ds, dc/2, dc/2, $fn=128); //collar
    
} // mod sotc

module pivot_joiner(){ //Pivot
    ech=5; //extra cylinder height

    difference(){
        union(){
            translate([0,0,13]) cylinder(d2=dc,d1=roller_diameter,h=ech,center=true); //botom cyl
            translate([0,0,-13]) cylinder(d1=dc,d2=roller_diameter,h=ech,center=true); //top cyl
            cylinder(d=roller_diameter,h=roller_height,center=true,$fn=90); //main cyl
        }
        //cylinder(d=16,h=32,center=true);
 
        /*for(t=[30:30:360]){
            rotate([0,0,t]) translate([8+2.5,0,0]) #cylinder(d=2.5,h=roller_height+ech,center=true,$fn=12);    
        }*/
    }
} // mod pivot_joiner


difference(){
    total_height = h + dc*2 + roller_height;
    union(){
        sotc();
        pivot_x = h/2 + ds*4;
        translate([0,0,pivot_x]) pivot_joiner();
        translate([0,0,-pivot_x]) pivot_joiner();
    }
    cylinder(d=roller_diameter-wall_thick,h=total_height,center=true,$fn=12);
}
