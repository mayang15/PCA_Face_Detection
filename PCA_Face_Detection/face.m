clear,clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% training
p = 34;                     % select p main eigen vectors
X_ori = zeros(108*75,35);   % training images(each column of X_ori)
for i=1:35
    filename = sprintf('%s%03d%s','imgs/clip_image',i,'.jpg');
    image = double(imread(filename));
    for x = 1:108
        for y = 1:75
            X_ori((x-1)*75+y,i) = image(x,y);
        end
    end
end
X = X_ori;
for i = 1:8100
    m = mean(X(i,:));
    X(i,:) = X(i,:) - m;
end
C = X'*X/35;
[E,D] = eig(C);
V = X*E;                             % each column is an eigen vector
image_p = V(:,35-p+1:35)'*X_ori;     % descending dimention images:
                                     % projection of original images on V
averg = zeros(p,1);
for i = 1:p
    averg(i) = mean(image_p(i,:));
end
show = zeros(108,75);                % show several eigen vectors
averg_face = zeros(108,75);          % show average face
for i = 1:p
    for x = 1:108
        for y = 1:75
            show(x,y) = V((x-1)*75+y,35-p+i);
        end
    end
    MIN = min(min(show));
    MAX = max(max(show-MIN));
    show = (show-MIN)/MAX*255;
    averg_face = averg_face + averg(i)*show;
%     figure;
%     imshow(uint8(show));
%     imwrite(uint8(show),sprintf('%s%02d%s','eigen_face',i,'.jpg'));
end
averg_face = averg_face/sum(averg);
% imshow(uint8(averg_face));
% imwrite(uint8(averg_face),'averg_face.jpg');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testing
test_image = imread('horse.jpg');
test_vector = zeros(8100,1);
for x = 1:108
    for y = 1:75
          test_vector((x-1)*75+y) = test_image(x,y);
%         if x>105
%             test_vector((x-1)*75+y) = 0; 
%         else
%             test_vector((x-1)*75+y) = test_image(x,y);
%         end
    end
end
test_p = V(:,35-p+1:35)'*test_vector;  % descending dimention test_image:
                                       % projection of test_image on V
sim = averg'*test_p;
if sim > 1.42e+16                    % choose a proper threshold
    fprintf('%s\n','判定结果：人脸');
else
    fprintf('%s\n','判定结果：非人脸');
end
fprintf('%s%f\n','sim=',sim);

