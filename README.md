# Goatee

Goatee is a web interface to Gmsh.

## Deployment

 1. Sign up for [Amazon EC2][].

  [amazon ec2]: https://aws.amazon.com/ec2/

 2. Start an Ubuntu 12.04 instance with the following User Data:
 
    <img src="https://raw.github.com/ariofrio/goatee/master/doc/1-launch-instance.png" width="200">
    <img src="https://raw.github.com/ariofrio/goatee/master/doc/2-select-classic-wizard.png" width="200">
    <img src="https://raw.github.com/ariofrio/goatee/master/doc/3-choose-an-ami.png" width="200">
    <img src="https://raw.github.com/ariofrio/goatee/master/doc/4-instance-details.png" width="200">

        #!/bin/bash
        set -ex

        function first-setup() {
          apt-get update
          apt-get install --yes git npm rubygems gmsh
          gem install foreman
          npm install -g coffee-script

          cd /home/ubuntu
          sudo -u ubuntu git clone --bare \
            git://github.com/ariofrio/goatee.git
        }

        function start() {
          cd /home/ubuntu/goatee.git
          sudo -u ubuntu wget -O hooks/post-receive \
            https://raw.github.com/gist/3178891/post-receive
          chmod +x hooks/post-receive
          sudo -Hu ubuntu hooks/post-receive
        }

        if [ ! -d /home/ubuntu/goatee.git ]; then
          first-setup &>> /var/log/goatee-setup.log
        fi
        start &>> /var/log/goatee-setup.log

    If you haven't yet, create a new Key Pair and download it. You will need
    it to access the instance if it fails, and to update its software.
    
    Finally, if you haven't yet, you'll need to create a new Security Group:
    add an SSH rule and an HTTP rule.

    After 5 minutes, open the app by visiting the Public DNS or a Public IP.

## Debugging

The setup script logs to `/var/log/goatee-setup.log`. The app logs to
`/tmp/goatee-PORT-XXXXXX.log`.
 
