function img = clamp_img(img, bounds)

img = img + (img > bounds(2)).*(bounds(2)-img) + (img < bounds(1)).*(bounds(1)-img);
