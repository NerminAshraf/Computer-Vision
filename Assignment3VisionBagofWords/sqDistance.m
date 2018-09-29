function D = sqDistance(X, Y) %Finds the square distance between two points X and Y using vectorization.
D = bsxfun(@plus,dot(X,X,1)',dot(Y,Y,1))-2*(X'*Y);