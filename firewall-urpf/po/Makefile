#
# Copyright 2017,2020 NIC.br
#
# You may redistribute this program and/or modify it under the terms of
# the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# This must not be inside any define..endef block,
# otherwise the bizantine-obfuscator-maximum stuff will
# will utterly break it by trashing all shell variables
i18n-build:
	mkdir -p $(PKG_I18N_DIR)
	find . -type f -name '*.po' -print | while read -r pofile ; do \
		pobase=$${pofile%*.po} ; pobase=$${pobase##*/} ; \
		podir=$${pofile%/*} ; \
		polang=$${podir##*/} ; \
		po2lmo $${pofile} $(PKG_I18N_DIR)/$${pobase}.$${polang}.lmo ; \
	done
