import numpy as np
import random
import copy

#inputs
img_size = 0 # 4x4,8x8,16x16
template = [] # 3x3 , 8 bit unsigned
# numpy array
img = []  # 4X4,8X8,16X16, 8 bit unsigned (r,g,b)
num_of_actions = 0
LOWER_BOUND = 0
UPPER_BOUND = 255
PATTERN_NUM = 100
BIT_WIDTH = 8

# Example inputs
ex_img_size  = 8
ex_template  = [3,7,4,4,0,1,6,6,3]
ex_red_channel = np.array([
    [6, 2, 5, 7, 7, 6, 1, 1],
    [4, 2, 0, 4, 1, 3, 4, 1],
    [0, 8, 7, 6, 8, 1, 9, 1],
    [9, 9, 2, 2, 6, 0, 0, 7],
    [2, 9, 0, 6, 0, 7, 9, 0],
    [7, 2, 0, 0, 2, 3, 3, 5],
    [4, 0, 5, 9, 4, 2, 1, 7],
    [4, 4, 8, 2, 1, 6, 5, 4]
])

# Green channel
ex_green_channel = np.array([
    [0, 5, 8, 4, 5, 9, 8, 1],
    [8, 2, 3, 1, 0, 4, 3, 9],
    [5, 3, 7, 2, 2, 0, 6, 0],
    [4, 6, 0, 0, 5, 5, 6, 5],
    [8, 9, 9, 1, 2, 5, 1, 7],
    [0, 4, 9, 1, 7, 6, 8, 2],
    [3, 3, 4, 1, 0, 9, 9, 3],
    [3, 3, 3, 5, 3, 8, 1, 9]
])

# Blue channel
ex_blue_channel = np.array([
    [9, 2, 9, 9, 4, 0, 6, 7],
    [4, 0, 2, 7, 5, 6, 8, 5],
    [5, 6, 8, 4, 8, 3, 1, 2],
    [6, 1, 8, 2, 6, 1, 6, 5],
    [1, 7, 5, 8, 4, 3, 4, 8],
    [8, 8, 7, 6, 0, 0, 1, 5],
    [7, 1, 3, 3, 5, 1, 9, 8],
    [4, 9, 8, 4, 6, 2, 5, 0]
])


# ex actions
ex_num_of_actions = 3
ex_opts = [0,3,7]


random.seed(1234)

if __name__ == '__main__':
    with open('input.txt', 'w') as f:
        f.write(f"{PATTERN_NUM}\n\n")
        for i in range(PATTERN_NUM):
            # Matrix size 4,8,16
            if i == 0:
                img_size = ex_img_size
            else:
                img_size = random.choice([4,8,16])

            if img_size == 4:
                f.write(f"{0}\n\n")
            elif img_size == 8:
                f.write(f"{1}\n\n")
            else:
                f.write(f"{2}\n\n")

            img = np.zeros((3,img_size,img_size),dtype=np.uint8)

            # With each image size, generates the R,G,B channels
            for x in range(img_size):
                for y in range(img_size):
                    if(i==0):
                        r_pixel = ex_red_channel[x][y]
                        g_pixel = ex_green_channel[x][y]
                        b_pixel = ex_blue_channel[x][y]
                    else:
                        r_pixel = random.randint(LOWER_BOUND,UPPER_BOUND)
                        g_pixel = random.randint(LOWER_BOUND,UPPER_BOUND)
                        b_pixel = random.randint(LOWER_BOUND,UPPER_BOUND)

                    f.write(f"{r_pixel} ")
                    f.write(f"{g_pixel} ")
                    f.write(f"{b_pixel} ")

                    img[0][x][y] = r_pixel
                    img[1][x][y] = g_pixel
                    img[2][x][y] = b_pixel

            f.write("\n\n")

            template = np.zeros((3,3),dtype=np.uint8)

            # 3x3 , template
            for x in range(3):
                for y in range(3):
                    if(i==0):
                        kernal_value = ex_template[x*3+y]
                    else:
                        kernal_value = random.randint(LOWER_BOUND,UPPER_BOUND)

                    template[x][y] = kernal_value
                    f.write(f"{kernal_value} ")

            f.write("\n\n")

            # Repeats these actions 8 times for each pattern
            for num_of_act in range(8):
                # Number of mid actions
                if(i==0 and num_of_act == 0):
                    num_of_actions = 1
                else:
                    num_of_actions = random.randint(0,6)

                f.write(f"{num_of_actions+2}\n\n")
                opt_q = []

                # First actions
                opt_q.append(random.randint(0,2))
                # Other actions
                for _ in range(num_of_actions):
                    opt_q.append(random.randint(3,6))
                # Last action
                opt_q.append(7)

                if(i==0 and num_of_act == 0):
                    opt_q = copy.deepcopy(ex_opts)

                # Write the actions to file
                for opt in opt_q:
                    f.write(f"{opt} ")

                f.write("\n\n")