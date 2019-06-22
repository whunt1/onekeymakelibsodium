# libsodium 一键安装脚本-修复版

修复逗比一键脚本不能安装最新版 libsodium 库的问题   
修复逗比一键脚本不能识别 centos 操作系统的问题   

- 脚本说明: libsodium 一键安装管理脚本
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+
- 使用参考: <https://doubibackup.com/6jfbj938-2.html>   
  
#### 下载安装:

执行下面的代码下载并运行脚本:
```bash
wget -N --no-check-certificate https://raw.githubusercontent.com/whunt1/onekeymakelibsodium/master/libsodium.sh && chmod +x libsodium.sh && bash libsodium.sh
```
运行脚本后会直接开始检测安装，如果**以前安装的有 libsodium** 则还会提示：
```bash
libsodium 已安装 , 是否覆盖安装(或者更新)？[y/N](默认: n):# 输入 Y 并回车即可。
```
本脚本只有一个 安装libsodium 功能，不过 升级libsodium 和安装步骤是一样的，但是因为 libsodium 当前安装的版本无法检测，所以 只能把升级和安装都扔在一起了。   

**手动安装教程：[ShadowsocksR 安装libsodium 以支持 Chacha20/Chacha20-ietf 加密方式](https://doubibackup.com/z2a4lk3l-3.html)**