function s = buildBagofFeatures(categories,annotations,centroids,install,testnum,bound)
%returns bag of features for training images in s. The struct contains each
%category  and avergae bag of images in a struct. 
%testnum number of training images
%install installs vl_sift
%bound uses the bounding box
%centroids uses cluster of  sift features
%annotations are useful for bounding.


[rCt,cCt] = size(centroids);
bag = zeros(1,cCt);
bagtotal = zeros(1,cCt);



if install ==1
run('vlfeatroot/toolbox/vl_setup')
vl_version verbose
end

 %listing = dir('101_ObjectCategories');
 % listingA = dir('Annotations');

 %[r,c]= size(listing) 

%categories = '';
%annotations = '';
%countcat= 1;





[rc,cc]= size(categories);
%countimg = 1;

%rc = catnum; %The new code that allows for selecting a certain number of categories.
%categories1 =  categories(2:rc)
for i = 1:rc   %For each category
listing2 = dir(horzcat('101_ObjectCategories/',char(categories(i))));
listingA2 = dir(horzcat('Annotations/',char(annotations(i))));

[r,c]=size(listing2);
[ra,ca]=size(listingA2);

images1 = '';
annotations1 = '';
countimg = 1;

for j = 1:r
if strcmp(listing2(j).name, '.') || strcmp('..', listing2(j).name)
else
image1 = cellstr(listing2(j).name);
annotation1 = cellstr(listingA2(j).name);
if countimg ==1
images1 = image1;
annotations1 = annotation1;
countimg = 2;
else
images1 = vertcat(images1, image1);
annotations1 = vertcat(annotations1,annotation1);
end


end
end

%Get all images and annotations
images1;     %all images
annotations1;   %all annotations

%testnum = 10
char(categories(i))
[ci,ri] =  (size(images1));

testimages = images1(1:testnum,1);
testannot = annotations1(1:testnum,1);
testimage = '';

%Take a subset of this.
for k = 1:testnum %find the sift for the image and build the histogram; testnum >1 only when training
%k = 10;
char(testimages(k))
char(categories(i))

testimage = horzcat('101_ObjectCategories/',char(categories(i)),'/',char(testimages(k)));
annotate = horzcat('Annotations\',char(annotations(i)),'/',char(testannot(k)));


testimage;
annotate;
%show_annotation(testimage,annotate)

testimage = imread(testimage);
%show_annotation(testimage,str(annotate))
annotate = load(annotate);
box_coord = annotate.box_coord;
%show_annotation(testimage,annotate)

[rim,cim,dim]= size(testimage);
dim;
if dim == 1
else
testimage = rgb2gray(testimage); % convert the image to gray scale. (run through sift)


end

size(testimage)
box_coord(1)


if bound ==1
testimage2 = testimage(box_coord(1):box_coord(2),box_coord(3):box_coord(4));
else
testimage2 = testimage;
end

%imshow(testimage2);
%show_annotation('101_ObjectCategories/accordion/image_0001.jpg','Annotations\accordion\annotation_0001.mat')



[F,D] = vl_sift(single(testimage2));% extract feature points and descriptors.

%plot(F(1,:),F(2,:),'r+', 'MarkerSize', 2);
%We will try first collecting the clusters in one place 
%if compare ==0
%tocompare = D; 

[rD,cD]=size(D);



for fd =1:cD  %for all features
similarity = zeros(1,cCt);
for ct = 1:cCt   %replace 25 with the k centroids
similarity(1,ct) = sqDistance(double(centroids(:,ct)),double(D(:,fd)));
%similarity2(1,ct) = dumdistance(double(centroids(:,ct)),double(D(:,fd)));

hey =centroids(:,ct);
hey1 = D(:,fd);
end  %compare the feature with all the centroids

[minval,clustAss]=min(similarity); %Assign that feature to the nearest cluster. %assign feature to corresponding bag
bag(clustAss) = bag(clustAss) +1; %Add a weight to that particular cluster. 
end

%Find the square distance to each centroid.  
%Take the least square distance and assign it to the histogram.
bagtotal = bagtotal + bag; 
bag = zeros(1,cCt);
end
bagav = bagtotal/testnum;   %average of the histogram of bags.
bagtotal =0;
s(i) = struct('bag',bagav,'cat',categories(i));

end % For all categories


%now we have features for clustering
%categories = categories(1:catnum);



end

