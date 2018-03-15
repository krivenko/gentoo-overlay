# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rpm

DESCRIPTION="Xerox UNIX Print Drivers"
HOMEPAGE="http://www.support.xerox.com/"
SRC_URI="
		amd64? ( http://download.support.xerox.com/pub/drivers/CQ8580/drivers/linux/pt_BR/Xeroxv5Pkg-Linuxx86_64-${PV}.rpm )
		x86? ( http://download.support.xerox.com/pub/drivers/CQ8580/drivers/linux/pt_BR/Xeroxv5Pkg-Linuxi686-${PV}.rpm )"

LICENSE="Xerox-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"
RESTRICT="fetch mirror bindist strip"

DEPEND="dev-util/patchelf"
RDEPEND="
	net-print/cups
"

src_unpack() {
	rpm_src_unpack ${A}
}

src_prepare() {
	eapply_user

	# Unpack man pages
	pushd usr/share/man/man1
	unpack $WORKDIR/usr/share/man/man1/*.1.gz
	popd
}

src_install() {
	default

	local p="opt/Xerox/prtsys"
	local xerox_libs=/$p/v5lib

	for f in $p/xsf $p/xerox*; do
		patchelf --set-rpath $xerox_libs $f || die
	done
	exeinto /$p
	doexe $p/PatchSELinuxPolicy $p/xsf $p/xerox*

	insinto /$p
	doins $p/XeroxXSF $p/XeroxQScript $p/*.pp

	insinto /$p/db
	doins $p/db/*

	insinto /$p/icon
	doins -r $p/icon/*

	for f in $p/v5lib/*.so $p/v5lib/libgcc_s.so.1 $p/v5lib/libstdc++.so.6; do
		patchelf --set-rpath $xerox_libs $f || die
	done
	insinto /$p/v5lib
	doins -r $p/v5lib/*
	for f in $p/v5lib/*; do
		fperms 0755 /${f}
	done

	dobin usr/bin/*

	exeinto /usr/libexec/cups/filter
	doexe usr/lib/cups/filter/*

	doman usr/share/man/man1/*.1
}
