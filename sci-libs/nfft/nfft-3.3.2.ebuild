# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="library for nonequispaced discrete Fourier transformations"
HOMEPAGE="http://www-user.tu-chemnitz.de/~potts/nfft"
SRC_URI="http://www-user.tu-chemnitz.de/~potts/nfft/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openmp static-libs"

RDEPEND="sci-libs/fftw:3.0[threads,openmp?]"
DEPEND="${RDEPEND}"

pkg_pretend() {
	use openmp && ! tc-has-openmp && \
		die "Please switch to an openmp compatible compiler"
}

src_configure() {
	local myeconfargs=(
		--enable-all
		$(use_enable openmp)
	)
	econf ${myeconfargs}
}
