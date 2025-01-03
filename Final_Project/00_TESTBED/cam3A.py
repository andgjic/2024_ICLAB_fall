import numpy as np
import pdb

def color_auto_focus(image):
  """
  處理彩色圖片的自動對焦算法
  :param image: 32x32x3 彩色圖像，numpy array
  :return: 最佳"焦距"的索引
  """
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
  
  for i in range(0, 3):  # 模拟不同"焦距"，遍历中心区域
    
    center = image[center_point-1-i:center_point+1+i, center_point-1-i:center_point+1+i, :]  # 提取不同大小的中心
    print(center_point-1-i, center_point+1+i)
    contrasts.append(calculate_contrast(center))
  
  # Find the maximum value's index in the contrasts list
  return np.argmax(contrasts)

# def color_auto_exposure(image, target_brightness=128):
#   """
#   處理彩色圖片的自動曝光算法
#   :param image: 16x16x3 彩色圖像，numpy array
#   :param target_brightness: 目標平均亮度
#   :return: 調整後的圖像
#   """
#   # 計算當前亮度（使用 Y 分量）
#   # current_brightness = np.mean(np.dot(image[...,:3], [0.2989, 0.5870, 0.1140]))
#   current_brightness = np.mean(np.dot(image[...,:3], [0.25, 0.5, 0.25]))
#   adjustment = target_brightness / current_brightness

#   print(f"Current brightness: {current_brightness:.2f}, Target:{target_brightness:.2f}, Adjustment: {adjustment:.2f}")

#   # 分別調整每個顏色通道
#   # 並使用 np.clip 限制在 0-255 之間
#   adjusted_image = np.clip(image * adjustment, 0, 255).astype(np.uint8)
#   print(f"Brightness after adjusted: {np.mean(np.dot(adjusted_image[...,:3], [0.25, 0.5, 0.25]))}")
#   return adjusted_image

def color_auto_exposure(image, ratio):
  """
  處理彩色圖片的自動曝光算法
  :param image: 16x16x3 彩色圖像，numpy array
  :param target_brightness: 目標平均亮度
  :return: 調整後的圖像
  """
  # 計算當前亮度（使用 Y 分量）
  # current_brightness = np.mean(np.dot(image[...,:3], [0.2989, 0.5870, 0.1140]))
  current_brightness = np.mean(np.dot(image[...,:3], [0.25, 0.5, 0.25]))
  # adjustment = target_brightness / current_brightness

  print(f"Current brightness: {current_brightness:.2f}, Adjustment: {ratio:.2f}")

  # 分別調整每個顏色通道
  # 並使用 np.clip 限制在 0-255 之間
  adjusted_image = np.clip(image * ratio, 0, 255).astype(np.uint8)
  print(f"Brightness after adjusted: {np.mean(np.dot(adjusted_image[...,:3], [0.25, 0.5, 0.25]))}")
  return adjusted_image

def simple_auto_white_balance(image):
  """
  簡化版自動白平衡算法（灰度世界假設）
  :param image: 12x12x3 彩色圖像，numpy array
  :return: 白平衡後的圖像
  """
  r, g, b = image[:,:,0], image[:,:,1], image[:,:,2]
  r_avg, g_avg, b_avg = np.mean(r), np.mean(g), np.mean(b)
  avg = (r_avg + g_avg + b_avg) / 3
  
  r_gain = avg / r_avg
  g_gain = avg / g_avg
  b_gain = avg / b_avg
  
  balanced = np.stack([
      np.clip(r * r_gain, 0, 255),
      np.clip(g * g_gain, 0, 255),
      np.clip(b * b_gain, 0, 255)
  ], axis=-1)

  return balanced.astype(np.uint8)

# 測試代碼
if __name__ == "__main__":
  # 自動對焦測試
  # test_af = np.random.randint(0, 256, (32, 32, 3), dtype=np.uint8)
  # best_focus, _ = color_auto_focus(test_af)
  # print(f"Best focus index: {best_focus}")

  # 自動曝光測試
  # for i in range (1, 5):
  #   test_ae = np.random.randint(0, 256, (64, 64, 3), dtype=np.uint8)
  #   adjusted_ae = color_auto_exposure(test_ae, pow(2, i)*0.25)
    # print(f"Original mean brightness: {np.mean(np.dot(test_ae[...,:3], [0.2989, 0.5870, 0.1140])):.2f}")
    # print(f"Adjusted mean brightness: {np.mean(np.dot(adjusted_ae[...,:3], [0.2989, 0.5870, 0.1140])):.2f}")

  # 自動白平衡測試
  test_awb = np.random.randint(0, 256, (64, 64, 3), dtype=np.uint8)
  balanced_awb = simple_auto_white_balance(test_awb)
  print(f"Original channel means: R={np.mean(test_awb[:,:,0]):.2f}, G={np.mean(test_awb[:,:,1]):.2f}, B={np.mean(test_awb[:,:,2]):.2f}")
  print(f"Balanced channel means: R={np.mean(balanced_awb[:,:,0]):.2f}, G={np.mean(balanced_awb[:,:,1]):.2f}, B={np.mean(balanced_awb[:,:,2]):.2f}")
  
  # breakpoint()