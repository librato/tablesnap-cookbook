maintainer       "Librato"
maintainer_email "mike@librato.com"
license          "Apache 2.0"
description      "Installs/Configures tablesnap"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.6"

depends "build-essential"
depends "git"

supports "ubuntu"

recipe "tablesnap", "Installs tablesnap from git"
