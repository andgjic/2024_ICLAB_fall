import numpy as np
import json
import pdb
from cam3A import color_auto_focus, color_auto_exposure, simple_auto_white_balance

if __name__ == "__main__":
  lines = []
  with open ("DRAM/dram.json", 'r') as f:
    data = json.load(f)
  
  img = np.array(data[0]).reshape(3, 32, 32)
  img = np.transpose(img, (1, 2, 0))
  ans, contrasts = color_auto_focus(img)
  for i in range (1, 5):
    adjust_img = color_auto_exposure(img, pow(2, i)*0.25)
  
  adjust_img = color_auto_exposure(img, 0.25)
  pdb.set_trace()
  
  