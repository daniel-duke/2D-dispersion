function [theta,costheta] = angle2(v1,v2)
    costheta = dot(v1,v2)/(norm(v1)*norm(v2));
    theta = acos(costheta);
end
    