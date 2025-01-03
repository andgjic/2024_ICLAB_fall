import random
import json

if __name__ == "__main__":
  pic_data = []
  with open ("DRAM/dram12.dat", 'w') as f:
    for pic in range (16):
      f.write(f"@{(65536+pic*3072):X}\n")
      temp = []
      for color in range (3):
        # R, G, B
        temp_pic = []
        for i in range (32):
          for j in range (32):
            value = random.randint(0, 255)
            f.write(f"{value:X} ")
            temp_pic.append(value)
        f.write(f"\n")
        temp.append(temp_pic)
      
      f.write(f"\n")
      pic_data.append(temp)
  
  # with open ("DRAM/dram9.json", 'w') as f:
  #   json.dump(pic_data, f, indent=2)
