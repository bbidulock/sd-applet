#!/usr/bin/perl -w

use ExtUtils::MakeMaker;
my $VERSION = '0.01';
if (-d ".git") {
	$VERSION = `git describe --tags`;
	$VERSION =~ s/-.*//;
}

WriteMakefile(
	NAME => q(sd-applet),
	VERSION => $VERSION,
	LICENSE => 'perl',
	EXE_FILES => [qw(
		sd-applet
	)],
	PREREQ_PM => {
		'Getopt::Long' => 0.00,
		'Glib' => 0.00,
		'Gtk2' => 0.00,
		'Gtk2::Unique' => 0.00,
		'Net::DBus' => 0.00,
		'Net::DBus::GLib' => 0.00,
	},
	# basically strip the pod out of the .pm file and squeeze blank lines
	PM_FILTER => qq{(sed '/^=[^c]/,/^=cut/d'|cat -s)},
);

sub MY::postamble {
	return <<MAKE_FRAG;

.PHONY: install_desktop
install:: install_desktop

install_desktop:
	install -Dm644 sd-applet.desktop "\$(DESTDIR)/etc/xdg/autostart/sd-applet.desktop"
	install -Dm644 sd-applet.desktop "\$(DESTDIR)/usr/share/applications/sd-applet.desktop"
	rm -f "\$(DESTDIR)\$(INSTALLSITESCRIPT)/sd-files"
	ln -sf sd-applet "\$(DESTDIR)\$(INSTALLSITESCRIPT)/sd-files"
	install -Dm644 sd-files.desktop "\$(DESTDIR)/usr/share/applications/sd-files.desktop"
	rm -f "\$(DESTDIR)\$(INSTALLSITESCRIPT)/sd-units"
	ln -sf sd-applet "\$(DESTDIR)\$(INSTALLSITESCRIPT)/sd-units"
	install -Dm644 sd-units.desktop "\$(DESTDIR)/usr/share/applications/sd-units.desktop"
	rm -f "\$(DESTDIR)\$(INSTALLMAN1DIR)/sd-files.\$(MAN1EXT)"
	ln -sf sd-applet.\$(MAN1EXT) "\$(DESTDIR)\$(INSTALLMAN1DIR)/sd-files.\$(MAN1EXT)"
	rm -f "\$(DESTDIR)\$(INSTALLMAN1DIR)/sd-units.\$(MAN1EXT)"
	ln -sf sd-applet.\$(MAN1EXT) "\$(DESTDIR)\$(INSTALLMAN1DIR)/sd-units.\$(MAN1EXT)"

MAKE_FRAG
}
