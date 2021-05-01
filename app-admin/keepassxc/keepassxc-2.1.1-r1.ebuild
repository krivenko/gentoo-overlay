# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SCM=""
[[ "${PV}" == 9999 ]] && SCM="git-r3"
inherit cmake ${SCM}
unset SCM

DESCRIPTION="KeePassXC - KeePass Cross-platform Community Edition"
HOMEPAGE="https://github.com/keepassxreboot/keepassxc"

if [[ "${PV}" != 9999 ]] ; then
	SRC_URI="https://github.com/keepassxreboot/keepassxc/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	EGIT_REPO_URI="https://github.com/keepassxreboot/${PN}"
fi

LICENSE="LGPL-2.1 GPL-2 GPL-3"
SLOT="0"
#IUSE="autotype debug http test -yubikey"
IUSE="autotype debug http test"

RDEPEND="dev-libs/libgcrypt:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtnetwork:5
	sys-libs/zlib
	http? ( net-libs/libmicrohttpd )
	autotype? (
		x11-libs/libXi
		x11-libs/libXtst
		dev-qt/qtx11extras:5
	)
"
# yubikey? ( sys-auth/libyubikey )
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	dev-qt/qtconcurrent:5
	test? ( dev-qt/qttest:5 )
"

src_prepare() {
	 use test || \
		sed -e "/^find_package(Qt5Test/d" -i CMakeLists.txt || die

	 cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_XC_AUTOTYPE="$(usex autotype)"
		-DWITH_XC_HTTP="$(usex http)"
		-DWITH_TESTS="$(usex test)"
		-DWITH_GUI_TESTS=OFF
	)
#	-DWITH_XC_YUBIKEY="$(usex yubikey)"
	cmake-utils_src_configure
}
