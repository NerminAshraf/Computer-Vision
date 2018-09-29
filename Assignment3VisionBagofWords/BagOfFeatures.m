function [categories,annotations,tocluster] = BagOfFeatures(install,testnum,catnum,bound)
%Extracts the SIFT features from categories of images specified.

%set install = 1 the first time, then zero in subsequent runs
%testnum number of traiing images.
%catnum number of categories
%bound uses the bounding box

if install ==1
run('vlfeatroot/toolbox/vl_setup')
vl_version verbose
end

listing = dir('101_ObjectCategories');
listingA = dir('Annotations');

 [r,c]= size(listing); 

categories = '';
annotations = '';
countcat= 1;



tocluster = 0;

for i = 1:r
if strcmp(listing(i).name, '.') || strcmp('..', listing(i).name)
else
category = cellstr(listing(i).name);
annotation = cellstr(listingA(i).name);
if countcat ==1
categories = category;
annotations = annotation;
countcat = 2;
else
categories = vertcat(categories, category);
annotations = vertcat(annotations, annotation);
end


end
end

categories;
annotations;

[rc,cc]= size(categories);
countimg = 1;

rc = catnum; %The new code that allows for selecting a certain number of categories.
%categories1 =  categories(2:rc)
for i = 1:rc
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

images1;
annotations1;

%testnum = 10
char(categories(i));
[ci,ri] =  (size(images1));

testimages = images1(1:testnum,1);
testannot = annotations1(1:testnum,1);
testimage = '';
for k = 1:testnum %find the sift for 10 pictures and include them in a giant array of features that will be run throught the k-means.
%k = 10;
char(testimages(k));
char(categories(i));

testimage = horzcat('101_ObjectCategories/',char(categories(i)),'/',char(testimages(k)));
annotate = horzcat('Annotations\',char(annotations(i)),'/',char(testannot(k)));


testimage;
annotate;
%show_annotation(testimage,annotate) you can take it off again.

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

%imshow(testimage2); take it off again if you need.
%show_annotation('101_ObjectCategories/accordion/image_0001.jpg','Annotations\accordion\annotation_0001.mat')



[F,D] = vl_sift(single(testimage2));% extract feature points and descriptors.
%plot(F(1,:),F(2,:),'r+', 'MarkerSize', 2);
%We will try first collecting the clusters in one place 
if tocluster ==0
tocluster = D;

else
tocluster = horzcat(tocluster,D);
end

end



end % For all the images.


%now we have features for clustering
categories = categories(1:catnum);
annotations = annotations(1:catnum);




