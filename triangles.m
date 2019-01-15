function triangles()

%Inputs
start_time = datestr(clock());
start_time = strrep (start_time, ' ', '_');
start_time = strrep (start_time, ':', '-');

%Define all colour patches (xcentre,ycentre,x1,y1,x2,y2,x3,y3), 1 row per patch
P = dlmread('triangles_layout.txt');


%Asign colours to given points (x,y,r,g,b)
%N = [0,0,244/255,217/255,66/255;
%1000,1000,244/255,176/255,66/255;
%2000,2000,244/255,119/255,66/255];
N = [1100,1200,1,0.980392156862745,0;
400,1200,1,0.454901960784314,0.0392156862745098;
%1415,1225,0.63921568627451,0.172549019607843,0.00392156862745098;
%1415,1225,0.0549019607843137,0.0431372549019608,0.129411764705882;
%1415,1225,0.137254901960784,0.556862745098039,0.403921568627451;
%1415,1225,0.435294117647059,0.458823529411765,0.419607843137255;
1800,1200,0.631372549019608,0.666666666666667,0.105882352941176;
%1415,1225,0.584313725490196,0.749019607843137,0.650980392156863;
%1415,1225,0,0,0;
2500,1200,0.909803921568627,0.874509803921569,0.698039215686274;

-200,-200,1,1,1;
-200,800,1,1,1;
-200,1600,1,1,1;

-200,2650,1,1,1;
700,2650,1,1,1;
1400,2650,1,1,1;
2100,2650,1,1,1;

3030,2650,1,1,1;
3030,1600,1,1,1;
3030,800,1,1,1;

3030,-200,1,1,1
2100,-200,1,1,1
1400,-200,1,1,1
700,-200,1,1,1
];
N_centres = N(:,1:2);
N_colours = N(:,3:5);

%For each patch, calculate centre coordinates, node coordinates and distances from nodes
centres = P(:,1:2);

for i = 1:size(centres,1);
  for j = 1:size(N_centres,1);
    vector = centres(i,:)-N_centres(j,:);
    dist(i,j) = (vector(1)^2 + vector(2)^2);
  endfor;
endfor;

%For each patch, invert distances (larger number required for smaller distance), then normalise so each line adds to 1 and cumsum along lines
dist = 1./dist;
for i = 1:size(dist,1);
  dist(i,:) = dist(i,:)/sum(dist(i,:));
end;
cumdist = cumsum(dist,2);

%Assign each patch a random number in range 0:1, and associated colour
for i = 1:size(dist,1);
  A = rand();
  B = min(find(cumdist(i,:)>A));
  C(i,1:3) = N_colours(B,:);
endfor;



%Plot each rectangle
f = figure;
hold on;
for i = 1:size(dist,1);
  t(i) = fill(P(i,[3,5,7]),P(i,[4,6,8]),C(i,:));
endfor;
axis off;
axis equal;

%Save image file with outlines
print([start_time,'_outlined.png']);

for i = 1:size(dist,1);
  set(t(i),"edgecolor",C(i,:));
endfor;

%Save image file without outlines
print([start_time,'_clean.png']);

%save underlying data
dlmwrite([start_time,'_colours.txt'],C);
dlmwrite([start_time,'_patches.txt'],P);

close(f);

