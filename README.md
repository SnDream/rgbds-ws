# rgbds-ws

rgbds的集成编译环境。

包含如下部分

1. 一个rgbds代码工程，提供一些预设代码，可以对ROM进行简单的修改。
2. 一个Windows集成环境，可以不依赖系统安装的各个工具，直接在里面适用。
3. （目前还没有计划）一个Linux集成环境，可以不依赖系统安装的RGBDS。

## 外部安装

不论是Windows还是Linux系统，都建议预先安装如下内容：

1. `VS Code`
2. `VS Code` 的 `Python` 和 `rgbds` 插件

## rgbds-ws-win

为 `Windows 10 1909` 以上版本提供的rgbds集成编译环境。

包含下列工具：
1. `rgbds 0.7.0`: GB汇编/图像编译工具
    - 包含 `rgbasm` ，GB 汇编编译器
    - 包含 `rgblink` ，GB 汇编连接器
    - 包含 `rgbfix` ，GB ROM文件修正工具
    - 包含 `rgbgfx` ，GB 图像转换工具
2. `busybox-w32 FRP-5301-gda71f7c57`: 精简Unix工具集合
    - 包含 `sh` ，类似Unix下bash的ash shell，编译集成环境使用它作为基本交互
    - 包含 `md5sum` ，用于计算文件md5校验值
    - 包含 `crc32` ，用于计算文件crc32校验值
    - 包含 `unzip` ，用于解压文件
    - 包含 `make` ，但是对现有工程兼容问题较多，未开启
    - 包含 `cd` ，切换工作目录
    - 包含其他大量Unix工具
3. `python 3.12.2`: 高级语言环境，常用于汉化/工程脚本
    - 预装 `pip` ，提供额外安装 python 包的支持
    - 预装 `openpyxl` ，提供xlsx文件读写支持，可用于汉化文本读写
4. `tcc 0.9.27`: 提供基础的C代码编译支持
5. `GNU make 4.2.93`: 自动化编译脚本
    - 使用通过 `tcc` 编译的版本，比较旧，但是方便嵌入

另外，提供 `rgbds-ws.code-workspace` 文件，安装 `VS Code` 后可以直接打开该工作区，预先配置了一些环境内容。

## 使用方法

- 执行 `run.bat` 可以打开一个 `sh` 终端，可以在其中执行相关工具。
- 安装 `VS Code` 后，可以打开 `rgbds-ws.code-workspace` 文件，将进入定制的工作区。
    - 可以用 `Ctrl + ~` 的方式打开终端，也是配置好的相关 `sh` 终端。
    - 初次使用，或者移动工作目录后，在打开 `VS Code` 前必须至少执行一次 `run.bat` 。
- 第一次进入终端，可以配置语言。可以使用 `wslang` 更换。
- 终端可以用 `wshelp` 看简单的说明。
- 建议使用如下方式构建自己的工程
    - `home` 用于存放编译代码目录，建议在目录中创建子目录，在相关子目录中开发。
        - 可以将 `rgbds-workspace` 放入使用。
        - 使用 `cd` 命令切换目录。 `cd ..` 切换到上一级目录。 `cd ~` 跳转到 `home` 目录。
    - `bin` 用于存放编译工具。可以往目录中增加自己的工具或者脚本，方便编译引用。
    - `cfg` 用于存放一些配置文件。
    - `tmp` 用于存放一些临时文件。迁移时可以不保留这个目录，每次会自动重建。

## 构建流程

构建在windows下进行

下载 `https://frippery.org/files/busybox/busybox64u.exe` ，并重命名为 `sh.exe`

进入 `win` 目录，将 `build.sh` 拖动到 `sh.exe`，将会执行如下内容：

1. 自动下载 `rgbds` 、 `busybox` 、 `python3` 嵌入式版本 、 `python3` pip安装脚本 、 `tcc` 、`gnu make` 源代码。
2. 下载的各种内容将缓存在 `cache_dir` 中，重新生成时直接使用目录中的文件。可以删除后重新激活下载。
3. 自动解压、编译、安装各个包到 `build_dir` 中。
4. 复制一部分定制脚本和配置到 `build_dir` 中。

# rgbds-ws-linux

目前还没有制作Linux版的计划。

上述各个工具，Linux一般都有预装，除了 `rgbds` 需要手动安装或编译。即便这个操作在Linux上也很简单。

`rgbds-ws` 里的内容对Linux同样适用。
