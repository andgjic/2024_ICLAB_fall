# Some interesting script for ICLAB
**[可以參考HACKMD上比較漂亮的說明](https://hackmd.io/@JyunWei-Su/ICLAB-script)**
## 功能介紹
1. **登入時顯示目前 quota 百分比**
    ![](https://hackmd.io/_uploads/BJEdAREzT.png

2. **快速切換資料夾**
    ```
    輸入 0 快速切換到 00_TESTBED
    輸入 1 快速切換到 01_RTL
    輸入 2 快速切換到 02_SYN
    輸入 3 快速切換到 03_GATE
    輸入 4 快速切換到 04_MEM
    輸入 9 快速切換到 09_SUBMIT
    輸入 m 快速切換到 Memory
    ```
    ![](https://hackmd.io/_uploads/rkrX1yBfa.gif)

3. **一鍵修改 clk peroid**
    輸入 <kbd>c</kbd> 查看目前 `clk` 設定
    輸入 <kbd>c</kbd> <kbd>peroid</kbd>修改並顯示 `clk`
    ![](https://hackmd.io/_uploads/H1bweyrGT.gif)

4. **一鍵開啟/關閉 fsdb**
    輸入 <kbd>f</kbd> 查看目前 `fsdb` 設定
    輸入 <kbd>f</kbd> <kbd>rtl</kbd> <kbd>on/off</kbd>修改並顯示 `rtl fsdb` 設定
    輸入 <kbd>f</kbd> <kbd>gate</kbd> <kbd>on/off</kbd>修改並顯示 `gate fsdb` 設定
    輸入 <kbd>f</kbd> <kbd>post</kbd> <kbd>on/off</kbd>修改並顯示 `post fsdb` 設定
    ![](https://hackmd.io/_uploads/SkwQzyHzT.gif)

5. **一鍵開啟 DesignWare IP User Guide**
    輸入 <kbd>dwip</kbd> 開啟 DesignWare IP Pdf
    輸入 <kbd>io</kbd> 開啟 IO Pdf
    ![](https://hackmd.io/_uploads/rJpx7krGa.gif)

## 腳本內容與設定方式
1. 切換回家目錄
    ```sh=
    cd $HOME
    ```

2. 將 `src` 內的 `.cshrc` 和 `script` 資料夾直接丟到家目錄

    ![](https://hackmd.io/_uploads/SkVb7sCnA.png)

3. Terminal 輸入指令: `source $HOME/.cshrc`

4. **之後如果要修改Lab路徑**
    * 編輯`~script/setting.csh`中的`set FOLDER="Lab??/Exercise"`
    * 或直接輸入`setting`，將跳出 `VSCode` 視窗後進行編輯
    ![](https://hackmd.io/_uploads/HJID4ErMa.png)

