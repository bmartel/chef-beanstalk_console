name              "beanstalk_console"
maintainer        "Mathias Hansen"
maintainer_email  "me@codemonkey.io"
license           "Apache 2.0"
description       "Installs and configures beanstalk_console"
version           "0.1.0"

recipe "beanstalk_console", "Installs  and configures beanstalk_console"

%w{ ubuntu debian centos redhat amazon scientific oracle fedora }.each do |os|
  supports os
end

%w{ php }.each do |cookbook|
  depends cookbook
end