#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS/Debian/Ubuntu
#	Description: Libsodium Install
#	Version: 1.1.0
#	Author: Toyo & July
#	Blog: https://doub.io/shell-jc6/
#=================================================

Libsodiumr_file="/usr/local/lib/libsodium.so"
Libsodiumr_ver_backup="1.0.17"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}" && Error="${Red_font_prefix}[错误]${Font_color_suffix}" && Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
	bit=`uname -m`
}
Check_Libsodium_ver(){
	echo -e "${Info} 开始获取 libsodium 最新版本..."
	Libsodiumr_ver=$(wget -qO- "https://github.com/jedisct1/libsodium/tags"|grep "/jedisct1/libsodium/releases/tag/"|head -1|sed -r 's/.*tag\/(.+)\">.*/\1/')
	[[ -z ${Libsodiumr_ver} ]] && Libsodiumr_ver=${Libsodiumr_ver_backup}
	echo -e "${Info} libsodium 最新版本为 ${Green_font_prefix}[${Libsodiumr_ver}]${Font_color_suffix} !"
}
Install_Libsodium(){
	if [[ -e ${Libsodiumr_file} ]]; then
		echo -e "${Error} libsodium 已安装 , 是否覆盖安装(或者更新)？[y/N]"
		read -e -p "(默认: n):" yn
		[[ -z ${yn} ]] && yn="n"
		if [[ ${yn} == [Nn] ]]; then
			echo "已取消..." && exit 1
		fi
	else
		echo -e "${Info} libsodium 未安装，开始安装..."
	fi
	Check_Libsodium_ver
	check_sys
	if [[ ${release} == "centos" ]]; then
		yum update
		echo -e "${Info} 安装依赖..."
		yum -y groupinstall "Development Tools"
		echo -e "${Info} 下载..."
		wget  --no-check-certificate -N "https://github.com/jedisct1/libsodium/releases/download/${Libsodiumr_ver}/libsodium-${Libsodiumr_ver}.tar.gz"
		if [[ -e libsodium-${Libsodiumr_ver}.tar.gz ]]; then
			echo  -e "${Info} 下载成功..."
		else
			echo  -e "${Error} 下载失败，启用备用下载地址..."
			wget  --no-check-certificate -N -O libsodium-${Libsodiumr_ver}.tar.gz "https://download.libsodium.org/libsodium/releases/libsodium-${Libsodiumr_ver}.tar.gz"
			if  [[ -e libsodium-${Libsodiumr_ver}.tar.gz ]]; then
				echo  -e "${Info} 备用下载地址下载成功..."
			else
				echo  -e "${Error} 下载失败，尝试下载历史版本..."
				Libsodiumr_ver=${Libsodiumr_ver_backup}
				wget  --no-check-certificate -N "https://github.com/jedisct1/libsodium/releases/download/${Libsodiumr_ver}/libsodium-${Libsodiumr_ver}.tar.gz"
				[[ ! -e libsodium-${Libsodiumr_ver}.tar.gz ]] && echo -e "${Error} libsodium 下载失败 !" && exit 1
			fi
		fi
		echo -e "${Info} 解压..."
		tar -xzf libsodium-${Libsodiumr_ver}.tar.gz
		cd libsodium-${Libsodiumr_ver}
		echo -e "${Info} 编译安装..."
		./configure --disable-maintainer-mode
		make -j2
		make install
		echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
	else
		apt-get update
		echo -e "${Info} 安装依赖..."
		apt-get install -y build-essential
		echo -e "${Info} 下载..."
		wget  --no-check-certificate -N "https://github.com/jedisct1/libsodium/releases/download/${Libsodiumr_ver}/libsodium-${Libsodiumr_ver}.tar.gz"
		if [[ -e libsodium-${Libsodiumr_ver}.tar.gz ]]; then
			echo  -e "${Info} 下载成功..."
		else
			echo  -e "${Error} 下载失败，启用备用下载地址..."
			wget  --no-check-certificate -N -O libsodium-${Libsodiumr_ver}.tar.gz "https://download.libsodium.org/libsodium/releases/libsodium-${Libsodiumr_ver}.tar.gz"
			if  [[ -e libsodium-${Libsodiumr_ver}.tar.gz ]]; then
				echo  -e "${Info} 备用下载地址下载成功..."
			else
				echo  -e "${Error} 下载失败，尝试下载历史版本..."
				Libsodiumr_ver=${Libsodiumr_ver_backup}
				wget  --no-check-certificate -N "https://github.com/jedisct1/libsodium/releases/download/${Libsodiumr_ver}/libsodium-${Libsodiumr_ver}.tar.gz"
				[[ ! -e libsodium-${Libsodiumr_ver}.tar.gz ]] && echo -e "${Error} libsodium 下载失败 !" && exit 1
			fi
		fi
		echo -e "${Info} 解压..."
		tar -xzf libsodium-${Libsodiumr_ver}.tar.gz
		cd libsodium-${Libsodiumr_ver}
		echo -e "${Info} 编译安装..."
		./configure --disable-maintainer-mode
		make -j2
		make install
	fi
	ldconfig
	cd ..
	rm -rf libsodium-${Libsodiumr_ver}.tar.gz
	rm -rf libsodium-${Libsodiumr_ver}
	[[ ! -e ${Libsodiumr_file} ]] && echo -e "${Error} libsodium 安装失败 !" && exit 1
	echo && echo -e "${Info} libsodium 安装成功 !" && echo
}
action=$1
[[ -z $1 ]] && action=install
case "$action" in
	install)
	Install_Libsodium
	;;
    *)
    echo "输入错误 !"
    echo "用法: [ install ]"
    ;;
esac