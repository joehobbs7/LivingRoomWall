%Inputs

%Define all colour patches (xmin, xmax, ymin, ymax), 1 row per patch
P = zeros(400,4);
P(1,:) = [0,0.1,0,0.1];
for i = 2:400;
  if (P(i-1,2)>2);
    P(i,:) = [0,0.1,P(i-1,3:4)+0.1];
  else;
    P(i,:) = [P(i-1,1:2)+0.1,P(i-1,3:4)];
  endif;
endfor;

%Assign each patch a colour triplet
C = zeros(400,3);
for i = 1:400;
  for j = 1:3;
    C(i,j) = rand();
  endfor
endfor

%Asign colours to given points (x,y,r,g,b)
N = [0,0,244/255,217/255,66/255;
1,1,244/255,176/255,66/255;
2,2,244/255,119/255,66/255];
N_centres = N(:,1:2)
N_colours = N(:,3:5)

%For each patch, calculate centre coordinates, node coordinates and distances from nodes
centres = [mean(P(:,1:2),2),mean(P(:,3:4),2)];

for i = 1:size(centres,1);
  for j = 1:size(N_centres,1);
    vector = centres(i,:)-N_centres(j,:);
    dist(i,j) = (vector(1)^2 + vector(2)^2);
  endfor
endfor

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
endfor



%Plot each rectangle
figure;
hold on;
for i = 1:400;
  rectangle("Position",[P(i,1),P(i,3),P(i,2)-P(i,1),P(i,4)-P(i,3)],"FaceColor",C(i,:),"EdgeColor",C(i,:));
endfor;

axis off;