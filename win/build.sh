#!/bin/sh

# set -x

# 各个主程序文件链接的配置
# 如果不需要某个组件，将下载地址参数改为空。

## 本地文件缓存目录，优先从这里获取
SRC_CACHE_DIR=cache_dir

## rgbds，二进制文件压缩包，如有需要可以换成其他rgbds版本
ADDR_RGBDS='https://github.com/gbdev/rgbds/releases/download/v0.7.0/rgbds-0.7.0-win64.zip'

## busybox-w32，二进制文件，编写当时版本为FRP-5301-gda71f7c57，下面默认获取最新版本。
ADDR_BUSYBOX='https://frippery.org/files/busybox/busybox64u.exe'
## 如果最新版本不再兼容，可以尝试换成脚本编写当时的版本，将上面的行修改为下面的行
## ADDR_BUSYBOX='https://frippery.org/files/busybox/busybox-w64u-FRP-5301-gda71f7c57.exe'

## python 3.12.2，嵌入式包
ADDR_PYTHON='https://www.python.org/ftp/python/3.12.2/python-3.12.2-embed-amd64.zip'

## get-pip，python脚本，用于安装pip
ADDR_GETPIP='https://bootstrap.pypa.io/get-pip.py'
## 随pip安装的包，默认包含pyreadline3和openpyxl
PIP_PACKAGES="pyreadline3 openpyxl"

## tcc，二进制文件压缩包
# ADDR_TCC='https://download.savannah.gnu.org/releases/tinycc/tcc-0.9.27-win64-bin.zip'
ADDR_TCC='http://nongnu.askapache.com/tinycc/tcc-0.9.27-win64-bin.zip'

## GNU make，源代码
# ADDR_MAKE_TCC='https://download.savannah.gnu.org/releases/tinycc/tcc-busybox-for-win32.zip'
ADDR_MAKE_TCC='http://nongnu.askapache.com/tinycc/tcc-busybox-for-win32.zip'

export http_proxy=127.0.0.1:7890
export https_proxy=127.0.0.1:7890

TDIR='temp_dir'
BDIR='build_dir'

hint() {
	echo "===> $@"
}

cache_get() {
	if [ -d "${SRC_CACHE_DIR}" ]
	then
		local cache="${SRC_CACHE_DIR}/$(basename "$2")"
		[ -e "${cache}" ] || {
			wget "$1" -O "${cache}" || {
				rm -rf "${cache}"
				return 1
			}
		}
		cp "${cache}" $2
	else
		wget "$1" -O "$2"
	fi
}

clean_up() {
	rm -rf "${TDIR}"
	[ "$1" -eq 0 ] || rm -rf "${BDIR}"
	exit $1
}

empty_dir() {
	rm -rf "$@" && mkdir -p "$@"
}

empty_dir "${BDIR}" "${TDIR}" || {
	hint "Gene dir failed."
	clean_up 1
}

## rgbds and busybox

hint "Get rgbds and busybox."
empty_dir "${BDIR}/tmp" &&
empty_dir "${BDIR}/home" &&
empty_dir "${BDIR}/bin" &&
cache_get "${ADDR_RGBDS}" "${TDIR}/rgbds.zip" &&
cache_get "${ADDR_BUSYBOX}" "${BDIR}/bin/sh.exe" &&
unzip -o "${TDIR}/rgbds.zip" -d "${BDIR}/bin" || {
	hint "Get rgbds and busybox failed."
	clean_up 1
}

## python3 and pip (optional)

if [ -n "${ADDR_PYTHON}" ]
then
	hint "Get python."

	export PYDIR="${BDIR}/bin/python3"
	empty_dir "${PYDIR}" &&
	cache_get "${ADDR_PYTHON}" "${TDIR}/python3.zip" &&
	unzip -o "${TDIR}/python3.zip" -d "${PYDIR}" || {
		hint "Get python failed."
		clean_up 1
	}

	export PYTHONDONTWRITEBYTECODE=y
	export PATH="$(realpath "${PYDIR}"):$(realpath "${PYDIR}/Scripts"):${PATH}"

	if [ -n "${ADDR_GETPIP}" ]
	then
		hint "Get pip and packages."
		cache_get "${ADDR_GETPIP}" "${TDIR}/get-pip.py" &&
		find "${PYDIR}" -name 'python*._pth' -delete &&
		python "${TDIR}/get-pip.py" || {
			hint "Get pip failed."
			clean_up 1
		}
		if [ -n "${PIP_PACKAGES}" ]
		then
			hint "Get pip packages."
			hint "Packages: ${PIP_PACKAGES}"
			pip install ${PIP_PACKAGES} || {
				hint "Get pip packages failed."
				clean_up 1
			}
		else
			hint "pip packages is not included."
		fi

		find "${PYDIR}/Lib" -name '*.pyc' -delete
		find "${PYDIR}/Lib" -name '__pycache__' -delete
	else
		hint "pip (and packages) is not included."
	fi

	mkdir -p "${PYDIR}/Scripts"
	print '#/bin/sh\nexec python "$@"\n' > "${PYDIR}/Scripts/python3"
else
	hint "Python is not included."
fi

## tcc and gnu make (optional)

if [ -n "${ADDR_TCC}" ]
then
	hint "Get tcc."

	export TCCDIR="${BDIR}/bin/tcc"
	empty_dir "${TCCDIR}" &&
	cache_get "${ADDR_TCC}" "${TDIR}/tcc.zip" &&
	unzip -o "${TDIR}/tcc.zip" -d "${BDIR}/bin" || {
		hint "Get tcc failed."
		clean_up 1
	}
	
	PATH="$(realpath "${TCCDIR}"):${PATH}"

	if [ -n "${ADDR_MAKE_TCC}" ]
	then
		hint "Get gnu make."
		empty_dir "${TDIR}/make-tcc" &&
		cache_get "${ADDR_MAKE_TCC}" "${TDIR}/make-tcc.zip" &&
		unzip -o "${TDIR}/make-tcc.zip" 'tcc-busybox-for-win32/gmake/*' -d "${TDIR}/make-tcc" &&
		mv "${TDIR}/make-tcc/tcc-busybox-for-win32/gmake" "${TDIR}/make-tcc/" &&
		( cd "${TDIR}/make-tcc/gmake" && T="-m64" tcc @0.tcc/gmake.tcc.rsp -w ) &&
		cp "${TDIR}/make-tcc/make.exe" "${BDIR}/bin"
	else
		hint "gnu make is not included."
	fi

else
	hint "tcc (and gnu make) is not included."
fi

cp helper_bin/* "${BDIR}/bin/"
cp README.md run.bat env_setup "${BDIR}"
cp code-workspace "${BDIR}/rgbds-ws.code-workspace"
cp -r ../rgbds-ws "${BDIR}/home/example"
