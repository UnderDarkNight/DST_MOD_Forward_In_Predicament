前期准备：
    1、下载安装 git  （git 是工具，github是网站，是两个东西）： https://registry.npmmirror.com/-/binary/git-for-windows/v2.43.0.windows.1/Git-2.43.0-64-bit.exe
    
    2、下载安装 Watt Toolkit  。这个是 通用加速器，能加速 github 。官网 ：  https://steampp.net/
    

下载步骤：
    1、启用 Watt Toolkit 。加速选项里  勾选 【Github】  和 【国外验证码平台】、【公共CDN】

    2、进入 饥荒 MOD的根目录，如【E:\SteamLibrary\steamapps\common\Don't Starve Together\mods】

    3、右键空白处，选择【Git Bash Here】

    4、 输入 命令   ：     
        git clone https://github.com/UnderDarkNight/DST_MOD_Forward_In_Predicament.git

    5、 等待下载完成。这个时候会多出个文件夹【DST_MOD_Forward_In_Predicament】。这个就是MOD的所有东西。

    6、 进入【DST_MOD_Forward_In_Predicament】文件夹，重新右键【Git Bash Here】

    7、 输入以下命令：
        git reset --hard
    
    8、 输入以下命令：
        git pull
    
    9、 输入以下命令：
        git pull origin main

更新步骤：
    1、启用 Watt Toolkit 。加速选项里  勾选 【Github】  和 【国外验证码平台】、【公共CDN】

    2、进入【DST_MOD_Forward_In_Predicament】文件夹，重新右键【Git Bash Here】

    3、 输入命令： 【注意！！！】最后那个  【点】不能漏掉。
        git checkout .
    
    4、 输入以下命令：
        git pull origin main

意外情况：
    1、 SSL 验证失败，关闭git验证SSL：  git config --global http.sslverify false

强制完全同步远程版本：
    git fetch --all
    git reset --hard origin/main
    git pull 
    git pull origin main