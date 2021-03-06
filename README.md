# Unlock music in shell for macOS
一个在macOS下解锁特殊格式音频文件的简单脚本，以便更简易地调用解锁指令（终端键入或双击打开）。脚本可能存在着不足，请见谅。

## Command Tool
- 需要系统已配置`um`的环境变量（自行操作，注意赋予执行权限即可）。[[原下载地址]](https://github.com/unlock-music/cli/releases/tag/v0.0.5)、[[Apple M1版(个人编译)]](https://github.com/hepsontam/shell-unlock-music/raw/main/um)

项目来源：[Unlock Music](https://github.com/unlock-music/unlock-music.git)、[Unlock Music-CLI](https://github.com/unlock-music/cli.git)
<br>在此感谢原作者的贡献！🙏🙏

## Usage
1.直接启动，按内容选择

2.命令+路径（推荐）,比如在macOS下
```
cd shell-unlock-music
chmod +x UNLOCK_macOS.sh
UNLOCK_macOS.sh <Path to unlock>
```

## Feature of the script
- [x] 设置音频文件所在路径
- [x] 检测可解锁的文件
- [x] 批量解锁
- [x] 单独解锁文件夹中的某个文件
- [ ] 选择输出文件格式
- [ ] 转换格式

[[→支持解锁的文件格式]](https://github.com/hepsontam/shell-unlock-music/raw/main/支持格式.png)
