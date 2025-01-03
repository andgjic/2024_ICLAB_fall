import functions
import numpy as np
import copy
import utils
#%%

#inputs
img_size = 0 # 4x4,8x8,16x16
template = [] # 3x3 , 8 bit unsigned
# numpy array
img = []  # 4X4,8X8,16X16, 8 bit unsigned (r,g,b)
num_of_actions = 0
PAT_NUM = 0

num_of_actions_list = []
opt_list = []

# delete output.txt
open('output.txt', 'w').close()

def run(img_size, template, img, opt_list):
    # Inputs images
    if img_size_num == 0:
        img_size = 4
    elif img_size_num == 1:
        img_size = 8
    else:
        img_size = 16

    # Reshape img to (3,img_size,img_size) r,g,b channels
    img = np.array(img).reshape(img_size,img_size,3)
    # reshape image into 3,img_size,img_size
    ifm = np.transpose(img,(2,0,1))

    # Reshape template to (3,3) kernel
    template = np.array(template).reshape(3,3)

    # Perform the actions on the image
    with open('output.txt', 'a') as file:
        for set_of_action in range(8):
            actions_q = opt_list[set_of_action]
            ofm = copy.deepcopy(ifm)

            # perform actions
            for action in actions_q:
                if action == 0: # grey scale max
                    ofm = functions.max_transformation(ofm)
                elif action == 1: # grey scale avg
                    ofm = functions.average_transformation(ofm)
                elif action == 2: # grey scale weighted
                    ofm = functions.weighted_transformation(ofm)
                elif action == 3: # max pooling
                    ofm = functions.max_pooling(ofm)
                elif action == 4: # negate image
                    ofm = functions.negate_img(ofm)
                elif action == 5: # horizontal flip
                    ofm = functions.horizontal_flip(ofm)
                elif action == 6: # median
                    ofm = functions.median_filter(ofm)
                elif action == 7: # cross correlation
                    ofm = functions.cross_correlation(ofm,template)

            # Write the ofm to output file
            ofm_shape = ofm.shape[0]
            file.write(f"{ofm_shape*ofm_shape}\n\n")

            for i in range(ofm_shape):
                for j in range(ofm_shape):
                    # expected number of ofm

                    # convert ofm to int
                    tmp = int(ofm[i][j])

                    bin_out = utils.int2bin(tmp,20)
                    file.write(f"{bin_out} ")

            file.write("\n\n")

# Read the input file into a list of strings
with open('input.txt', 'r') as file1:
    # read in pattern number and convert to integer then jump over empty line
    PAT_NUM = int(file1.readline())
    file1.readline()

    for _ in range(PAT_NUM):
        # read in image size
        img_size_num = int(file1.readline())
        file1.readline()

        # read in RGB image channels, r0,g0,b0,r1,g1,b1,...,rn,gn,bn
        img = list(map(int, file1.readline().split()))
        file1.readline()

        # read in template of size 3x3
        template = list(map(int, file1.readline().split()))
        file1.readline()
        num_of_actions = 0
        num_of_actions_list = []
        opt_list = []
        for i in range(8):
            # read in the number of actions
            num_of_actions = int(file1.readline())
            num_of_actions_list.append(num_of_actions)

            file1.readline()
            # read in the actions
            opt_list.append(list(map(int, file1.readline().split())))
            file1.readline()

        run(img_size_num, template, img, opt_list)


#%%
