# Unlock music in shell for macOS/Linux
一个在macOS（兼容Linux）下解锁特殊格式音频文件的简单脚本，以达到一键调用解锁功能的效果（终端键入或双击打开）。<br>脚本可能还存在着不足，请见谅。

项目来源：[Unlock Music](https://github.com/unlock-music/unlock-music.git)、[Unlock Music-CLI](https://github.com/unlock-music/cli.git)
<br>在此感谢原作者的贡献！🙏🙏

## Command Tool
- 需要系统已部署`um`的环境。[[原下载地址]](https://github.com/unlock-music/cli/releases)、[[Apple M1版(个人编译)]](https://github.com/hepsontam/shell-unlock-music/raw/main/um)
```
## 以macOS为例：下载

# M1芯片
curl -o um https://ghproxy.com/https://github.com/hepsontam/shell-unlock-music/raw/main/um
# 非M1芯片
curl -o um https://ghproxy.com/https://github.com/unlock-music/cli/releases/download/v0.0.5/um-darwin-amd64

## 授权；软链接

chmod +x ./um
sudo ln -s ./um /usr/bin
```

## Usage
```
## 下载并赋予执行权限

curl -o UNLOCK.sh https://ghproxy.com/https://raw.githubusercontent.com/hepsontam/shell-unlock-music/main/UNLOCK.sh
chmod +x ./UNLOCK.sh

## 执行

./Unlock.sh
```

## Feature of the script
- [x] 设置音频文件所在路径
- [x] 检测可解锁的文件
- [x] 批量解锁
- [x] 单独解锁文件夹中的某个文件
- [ ] 选择输出格式
- [ ] 转换格式

[[→支持解锁的文件格式]](https://github.com/hepsontam/shell-unlock-music/raw/main/支持格式.png)
