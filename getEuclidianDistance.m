

function distance = getEuclidianDistance (i, j, x, y, z)

    vector1 = [x(i) - x(1), y(i) - y(1), z(i) - z(1)];
    vector2 = [x(j) - x(1), y(j) - y(1), z(j) - z(1)];

    distance = norm(vector1-vector2);

end