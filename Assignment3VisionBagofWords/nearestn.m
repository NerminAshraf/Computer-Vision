function near = nearestn(BofW1,BofW2)
%Similarity function tht takes two vectors and outputs similarity score
%maximum is 1
mult =BofW1.*BofW2;
summult = sum(mult); %make sure you are adding in the right dimension
BofW1_2 = BofW1.^2; %square every element of the two bag of words
BofW2_2 = BofW2.^2;
sumBofW1_2 = sum(BofW1_2);
sumBofW2_2 = sum(BofW2_2);
sqrtBofW1 = sqrt(sumBofW1_2);
sqrtBofW2 = sqrt(sumBofW2_2);

near  = summult/(sqrtBofW1* sqrtBofW2);
end

