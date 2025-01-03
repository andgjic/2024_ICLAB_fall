import numpy as np
import pdb

def color_auto_focus(image):
  def calculate_contrast(img):
    
    # dot product the input image with weight to convert to grayscale
    # gray = np.dot(img[...,:3], [0.2989, 0.5870, 0.1140])
    gray = np.dot(img[...,:3], [0.25, 0.5, 0.25])
    gray = np.array(gray)
      
    # calculate the difference in 'gray'
    dx = np.diff(gray, axis=1) # -
    dy = np.diff(gray, axis=0) # |

    return int(np.sum(np.abs(dx)) + np.sum(np.abs(dy))) / (img.size*3)
  
  contrasts = []
  center_point = image.shape[0]//2
  
  for i in range(0, 3): 
    
    center = image[center_point-1-i:center_point+1+i, center_point-1-i:center_point+1+i, :]
    
    contrasts.append(calculate_contrast(center))
  
  # Find the maximum value's index in the contrasts list
  return np.argmax(contrasts), contrasts


def color_auto_exposure(image, ratio):
  adjusted_image = np.clip(image * ratio, 0, 255).astype(np.uint8)
  print(f"Brightness after adjusted: {np.mean(np.dot(adjusted_image[...,:3], [0.25, 0.5, 0.25]))}")
  return adjusted_image


if __name__ == "__main__":
  test_af = np.random.randint(0, 256, (32, 32, 3), dtype=np.uint8)
  best_focus, _ = color_auto_focus(test_af)
  print(f"Best focus index: {best_focus}")

  for i in range (1, 5):
    test_ae = np.random.randint(0, 256, (32, 32, 3), dtype=np.uint8)
    adjusted_ae = color_auto_exposure(test_ae, pow(2, i)*0.25)

