
h=50; // altura del cilindro
n=20; // el número de celdas en el círculo
dw=4.9; // distancia entre las caras de la celda
h1=2; // altura de la protuberancia del panal
w=0.5; // espacio entre celdas
an=30; // ángulo de inclinación de la celda

ds=(dw-w)/sin(360/6);
dc=((n*dw)/(2*PI))*2;
dh=dw*sin(360/6);


module st() {
difference() {
translate([dc/2, 0,0]) rotate([0,90,0]) cylinder(h1*2, ds/2, ds/2, $fn=6, true);
for (r1=[0:2])
translate([dc/2+h1, 0,0]) rotate([r1*120,0,0]) rotate([0,-an,0]) translate([0.01,-dw/2,0]) cube([h1*2,dw,dw]);
} // df

} // mod st;

module sotc() {
difference() {
union() {
cylinder(h+0.1, dc/2, dc/2, $fn=128, true);

for (mz=[0,1]) mirror([0,0,mz])
for (hn=[dh:dh*2:h/2+dh])
translate([0,0,hn]) mirror([0,0,mz])
for (r=[0:n-1]) {
	translate([0,0,dh/2]) rotate([0,0,360/n*r]) st();
	translate([0,0,-dh/2]) rotate([0,0,360/n/2]) rotate([0,0,360/n*r]) st();
} // for

} // un
for (mz=[0,1]) mirror([0,0,mz])
translate([0,0,h/2]) cylinder(ds*2, dc/2+h1*2, dc/2+h1*2, $fn=128);
} // df
} // mod sotc


sotc();