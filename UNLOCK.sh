#!/bin/bash

declare -i i n   # 路径索引 曲目索引
declare -a dir format names unlock  # 路径 格式 曲目名称 解锁项索引集合
dir=( '' "$HOME/Music/酷狗音乐/SQ/kgma" "$HOME/Music/酷狗音乐/HQ/kgm" "$HOME/Music/酷狗音乐/BQ/kgm" )
format=( '' '\.kgm' '\.kwm' '\.ncm' '\.qmc' '\.tkm' '\.bkc' '\.tm' '\.mflac' '\.mgg' '\.xm' )

echo
echo '🍷 欢迎使用本程序，此程序用于解锁特殊格式音频文件。🎶'
echo
echo '请选择歌曲所属文件夹⬇️：'
echo '[1] 酷狗音乐/SQ   [2] 酷狗音乐/HQ   [3] 酷狗音乐/BQ   [4] 自定义路径'
read -p '⇢ ' i

# 判断
if [[ $i -eq 4 ]]
then
	echo '请输入文件夹的绝对路径⬇️：'
	read -p '⇢ ' dir[4]
	if [[ -z ${dir[4]} ]]
	then
		i=0
	fi
fi

if [[ $i -lt 1 ]] || [[ $i -gt 4 ]] 
then
	echo
	echo '❗️ 未选择路径，程序即将退出...'
	sleep 1s
	exit
fi
            
n=1                    # 初始化
for ((m=1;m<11;m++))   # 遍历格式
do
	if [[ `ls ${dir[$i]} | grep "${format[$m]}" | wc -l` -gt 0 ]]
	then
		for line in `ls ${dir[$i]} | grep "${format[$m]}" | sed s,\ -\ ,-,g` # 为了使系统能正确识别内容，暂时将空格去掉
		do
			names[$n]=$line
			n=`expr $n + 1`
		done
	fi
done

if [[ -z ${names[*]} ]]
then
	echo
	echo '❓ 文件夹内并无可解锁内容，程序即将退出...'
	sleep 1s
	exit
fi

clear
echo "当前路径：${dir[$i]}"
echo
printf "%12s%-20s\n" '————————————' '——————————————————————————'
printf "%4s |\t     %-21s\n" ' 序号' '🔐 可解锁曲目'
printf "%12s%-20s\n" '————————————' '——————————————————————————'
n=1
for name in ${names[*]}    
do
	echo -e "  $n   |   `echo $name | sed s/-/\ -\ /g`"
	names[$n]=`echo $name | sed s/-/\ -\ /g`                             # 恢复原本名称
	n=`expr $n + 1`
done
printf "%12s%-20s\n" '————————————' '——————————————————————————'
echo '0.退出'
echo
echo '请输入需要解锁的曲目序号（可依次输入多项，默认解锁所有曲目）：'
read -p '⇢ ' unlocktext

if [[ -z ${unlocktext} ]]                    # 无输入（直接回车），则全选
then
	unlocktext='1'
	for ((m=2;m<=${#names[*]};m++))
	do
		unlocktext="$unlocktext $m"
	done
elif [[ ${unlocktext} = '0' ]]               # 0 则退出
then
	exit
fi

unlocktext=`echo ${unlocktext} | sed s/\ /,/g`   # 统一使用用为逗号分隔符，目的：输入时可用空格或逗号分隔
num=`echo ${unlocktext} | grep -o , | wc -l`     # 输入的解锁序号的数量-1 (逗号的个数)

# 判断
for ((m=1;m<`expr $num + 2`;m++))            # 根据内容判定索引是否有效
do
	n=`echo ${unlocktext} | cut -d , -f $m`  # 获取解锁曲目的序号(数组)
	if [[ -z ${names[$n]} ]]
	then
		continue
	fi
	unlock[$m]=$n                            # 有指向内容则保存
done

if [[ -z ${unlock[*]} ]]                     # unlock无内容（长度为0）则退出
then
	echo
	echo '❗️ 输入序号有误，并未有选中的解锁曲目，程序即将推出...'
	sleep 1s
	exit
elif [[ `expr $num + 1` -gt ${#unlock[*]} ]]
then
	echo '输入序号有误，已自动修正～'
fi

if [[ ! -d $HOME/Desktop/unlock_music_output ]] # 创建文件夹
then
	mkdir $HOME/Desktop/unlock_music_output
fi

echo
echo ' 进度  序号      👍 解锁曲目                   状态' 
echo '----------------------------------------------------'
m=1
for content in ${unlock[*]}
do
	printf "%4s %4s   %s \t\t%c" "${m}/${#unlock[*]}" "$content" "${names[$content]}" '/'
	sleep 0.09s
	printf "\b%c" '-'           # \b 退1格；\r 退1行 
	sleep 0.09s
	cmd=`um -o $HOME/Desktop/unlock_music_output -i ${dir[$i]}/"${names[$content]}"`        # 解锁命令；推测命令自带禁止转义
	info=`echo $cmd | cut -d ' ' -f 4`
	printf "\b%c" '\'
	sleep 0.09s
	printf "\b%c" '|'
	sleep 0.09s
	m=`expr $m + 1`
	if [[ ${#info} -ne 12 ]]    # ‘successfully’
	then
		printf "\b"
		echo ❗️ 
		continue
	fi
	printf "\b"
	echo ✅
done
echo '----------------------------------------------------'
echo
echo '🎉🎉 解锁工作已完成，项目已输出至桌面“unlock_music_output”文件夹～' 
