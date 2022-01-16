#!/bin/bash
GREEN_FONT_PREFIX="\033[32m"
YELLOW_FONT_PREFIX="\033[33m"
FONT_COLOR_SUFFIX="\033[0m"
INPUT="${GREEN_FONT_PREFIX}⇢${FONT_COLOR_SUFFIX}"

declare -i tr i n num # 传参判定 路径索引 曲目索引 解锁曲目序号
declare -a dir format names unlock  # 路径 格式 曲目名称 解锁项索引集合
dir=( '' "$HOME/Music/酷狗音乐/SQ/kgma" "$HOME/Music/酷狗音乐/HQ/kgm" "$HOME/Music/酷狗音乐/BQ/kgm" )
format=( '' '\.kgm' '\.kwm' '\.ncm' '\.qmc' '\.tkm' '\.bkc' '\.tm' '\.mflac' '\.mgg' '\.xm' )
IFS=`echo -en "\n\b"`     #### （重要）修改分隔符 或 IFS=$'\n'

function title(){
	echo -e '
🍷 欢迎使用本程序，此程序用于解锁特殊格式音频文件。🎶
'
}

function repairPath(){          # 绝对路径适配
	result=$1
	judge=${1:0:2}
	case $judge in
	'~')
		result="${HOME}"
		;;
	'~/')
		repair=`echo $1 | sed 's@~/@@'`
		result="${HOME}/${repair}"
		;;
	'.')
		result="${PWD}"
		;;
	'./')
		repair=`echo $1 | sed 's@./@@'`
		result="${PWD}/${repair}"
		;;
	'..')
		dname=$(dirname "$PWD")
		repair=`echo $1 | sed 's@../@@'`
		result="${dname}/${repair}"
		;;
	esac
	echo -e $result
}

function rangeComplete(){                    # 补全数列
	# range=`echo {1..${sum}}`               # 此表述有语法兼容性问题
	range='1'
	for ((m=2;m<=${1};m++)); do
		range="$range $m"
	done
	echo $range
}

## 检测是否有唯一传参(路径)
tr=0
echo $1
if [[ ! -z $1 ]]; then
	i=4
	dir[4]=`repairPath $1`                  # 事实上“传参”已是绝对路径
	tr=1
fi

if [[ $tr -eq 0 ]]; then
	title
	echo '请选择歌曲所属文件夹(非macOS请手动输入路径）⬇️：'
	echo '[1] 酷狗音乐/SQ   [2] 酷狗音乐/HQ   [3] 酷狗音乐/BQ   [4] 自定义路径'
	echo -e "${INPUT} \c"
	read i    # i不变

	# 判断
	if [[ $i -eq 4 ]]; then
		echo '请输入文件夹的路径⬇️：'
		echo -e "${INPUT} \c"
		read dir[4]
		if [[ -z ${dir[4]} ]]; then
			i=0
		else
			dir[4]=`repairPath ${dir[4]}` 
		fi

	fi

	if [[ $i -lt 1 || $i -gt 4 ]]; then
		echo -e '
		❗️ 未选择路径，程序即将退出...'
		sleep 1s       # macOS省s；Linux接s
		exit
	fi
fi

n=1                        # 初始化
for ((m=1;m<11;m++)); do   # 遍历10种格式
	if [[ `ls ${dir[$i]} | grep "${format[$m]}" | wc -l` -gt 0 ]]; then
		for line in `ls ${dir[$i]} | grep "${format[$m]}"`; do    # 获取曲目名称(index)
			names[$n]=$line
			n=`expr $n + 1`
		done
	fi
done

# if [[ ${#names[*]} -eq 0 ]]; then
if [[ -z ${names[*]} ]]; then
	echo
	echo '❓ 文件夹内并无可解锁内容，程序即将退出...'
	sleep 1s
	exit
fi

clear
if [[ $tr -eq 1 ]]; then
	title
fi
echo -e "当前路径：${YELLOW_FONT_PREFIX}\"${dir[$i]}\"${FONT_COLOR_SUFFIX}"
echo
printf "%12s%-32s\n" '————————————' '——————————————————————————————————————'
printf "%4s |\t\t   %-21s\n" ' 序号' '🔐 可解锁曲目'
printf "%12s%-32s\n" '————————————' '——————————————————————————————————————'
n=1
for name in ${names[*]}; do
	echo -e "  $n   |   $name"
	n=`expr $n + 1`
done
printf "%12s%-32s\n" '————————————' '——————————————————————————————————————'
echo -e '0.退出

请输入需要解锁的曲目序号（可依次输入多项，默认解锁所有曲目）：'

echo -e "${INPUT} \c"
read unlocktext                                  # 确定需要解锁曲目（序号）

if [[ -z ${unlocktext} ]]; then                  # 无输入（直接回车），则全选，使用满数列
	unlocktext=`rangeComplete ${#names[*]}`
elif [[ ${unlocktext} == '0' ]]; then            # 0 则退出
	exit
fi

unlocktext=`echo ${unlocktext} | sed s/\ /,/g`   # 统一使用逗号分隔符，目的：输入时可用空格或逗号分隔
num=`echo ${unlocktext} | grep -o , | wc -l`     # 逗号的个数 (输入的解锁序号的数量减1)

# 判断
for ((m=1;m<`expr $num + 2`;m++)); do            # 根据内容判定索引是否有效
	n=`echo ${unlocktext} | cut -d , -f $m`      # 获取解锁曲目的序号(数组)
	if [[ -z ${names[$n]} ]]; then
		continue
	fi
	unlock[$m]=$n                                # 有指向内容则保存
done

if [[ -z ${unlock[*]} ]]; then                   # unlock无内容（长度为0）则退出
	echo
	echo '❗️ 输入序号有误，并未有选中的解锁曲目，程序即将推出...'
	sleep 1s
	exit
elif [[ `expr $num + 1` -gt ${#unlock[*]} ]]; then
	echo '输入序号有误，已自动修正～'
fi


mkdir -p $HOME/Desktop/unlock_music_output
echo -e '
 状态 进度  序号      👍 解锁曲目                                    
---------------------------------------------------------------------'

m=1
for index in ${unlock[*]}; do
	printf "%-4s %4s %4s\t  %-s" '  /' "${m}/${#unlock[*]}" "$index" "${names[$index]}"
	sleep 0.09
	printf "\r%-4s %4s %4s\t  %-s" '  -' "${m}/${#unlock[*]}" "$index" "${names[$index]}" # \b 退1格；\r 退1行 
	sleep 0.09
	um -o $HOME/Desktop/unlock_music_output -i "${dir[$i]}/${names[$index]}" > /tmp/unlock_music.log 2>&1     
	## 解锁命令；推测命令自带禁止转义
	info=`cat /tmp/unlock_music.log | grep -o successfully`
	printf "\r%-4s %4s %4s\t  %-s" '  \' "${m}/${#unlock[*]}" "$index" "${names[$index]}"
	# printf "\b%c" '\'
	sleep 0.09
	printf "\r%-4s %4s %4s\t  %-s" '  |' "${m}/${#unlock[*]}" "$index" "${names[$index]}"
	# printf "\b%c" '|'
	sleep 0.09
	if [[ -z ${info} ]]; then  # Without 'successfully’
		printf "\r%-4s %4s %4s\t  %-s" '   ❗️' "${m}/${#unlock[*]}" "$index" "${names[$index]}"
		echo
		continue
	fi
	printf "\r%-4s %4s %4s\t  %-s" '   ✅' "${m}/${#unlock[*]}" "$index" "${names[$index]}"
	m=`expr $m + 1`
	echo
done
echo -e "---------------------------------------------------------------------

🎉🎉 解锁工作已完成，项目已输出至${YELLOW_FONT_PREFIX}桌面“unlock_music_output”${FONT_COLOR_SUFFIX}文件夹～"
