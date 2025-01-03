import numpy as np

# R,G,B greyscale max transformation, given the image with (3,img_size,img_size) dimension
def max_transformation(img):
    img_size = img.shape[1]
    max_transformation_results = np.zeros((img_size,img_size))
    for x in range(img_size):
        for y in range(img_size):
            max_transformation_results[x][y] = max(img[0][x][y],img[1][x][y],img[2][x][y])
    return max_transformation_results

# R,G,B greyscale average transformation, given the image with (3,img_size,img_size) dimension
def average_transformation(img):
    img_size = img.shape[1]
    average_transformation_results = np.zeros((img_size,img_size))
    for x in range(img_size):
        for y in range(img_size):
            average_transformation_results[x][y] = (img[0][x][y]+img[1][x][y]+img[2][x][y])//3

    return average_transformation_results

# R,G,B weighted greyscale transformation, given the image with (3,img_size,img_size) dimension
def weighted_transformation(img):
    img_size = img.shape[1]
    weighted_transformation_results = np.zeros((img_size,img_size))
    for x in range(img_size):
        for y in range(img_size):
            weighted_transformation_results[x][y] = (img[0][x][y]//4 + img[1][x][y]//2 + img[2][x][y]//4)

    return weighted_transformation_results

# Do max pooling with stride 2 , inputs are the image with (img_size,img_size) dimension
# If img size is 4x4 , then dont do max pooling
def max_pooling(img):
    img_size = img.shape[0]

    if(img_size == 4):
        return img

    max_pooling_results = np.zeros((img_size//2,img_size//2))
    for i in range(0,img_size,2):
        for j in range(0,img_size,2):
            max_pooling_results[i//2][j//2] = max(img[i][j],img[i+1][j],img[i+1][j+1],img[i][j+1])

    return max_pooling_results

def negate_img(img):
    img_size = img.shape[0]
    negated_img = np.zeros((img_size,img_size))
    for x in range(img_size):
        for y in range(img_size):
            negated_img[x][y] = 255 - img[x][y]
    return negated_img

def horizontal_flip(img):
    img_size = img.shape[0]
    flipped_img = np.zeros((img_size,img_size))
    for x in range(img_size):
        for y in range(img_size):
            flipped_img[x][y] = img[x][img_size-y-1]
    return flipped_img

# Do replication padding on the image, then do image median filtering
def median_filter(img):
    img_size = img.shape[0]
    padded_img = replication_padding(img)
    median_filtered_img = np.zeros((img_size,img_size))
    for x in range(1,img_size+1):
        for y in range(1,img_size+1):
            median_filtered_img[x-1][y-1] = np.median(padded_img[x-1:x+2,y-1:y+2])
    return median_filtered_img

# Do replication padding on the image
def replication_padding(img):
    img_size = img.shape[0]
    padded_img = np.zeros((img_size+2,img_size+2))

    # Top left corner
    padded_img[0][0] = img[0][0]
    # Top right corner
    padded_img[0][img_size+1] = img[0][img_size-1]
    # Bottom left corner
    padded_img[img_size+1][0] = img[img_size-1][0]
    # Bottom right corner
    padded_img[img_size+1][img_size+1] = img[img_size-1][img_size-1]

    # Top row
    for y in range(1,img_size+1):
        padded_img[0][y] = img[0][y-1]

    # Bottom row
    for y in range(1,img_size+1):
        padded_img[img_size+1][y] = img[img_size-1][y-1]

    # Left column
    for x in range(1,img_size+1):
        padded_img[x][0] = img[x-1][0]

    # Right column
    for x in range(1,img_size+1):
        padded_img[x][img_size+1] = img[x-1][img_size-1]

    # Copy the original image
    padded_img[1:img_size+1,1:img_size+1] = img

    return padded_img

# Given an image, and a 3x3 template,first zero-pad then do cross-correlation
def cross_correlation(img,template):
    img_size = img.shape[0]
    padded_img = np.zeros((img_size+2,img_size+2))
    padded_img[1:img_size+1,1:img_size+1] = img
    cross_correlation_results = np.zeros((img_size,img_size))
    for x in range(1,img_size+1):
        for y in range(1,img_size+1):
            cross_correlation_results[x-1][y-1] = np.sum(padded_img[x-1:x+2,y-1:y+2]*template)
    return cross_correlation_results
