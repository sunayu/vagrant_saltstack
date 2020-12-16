include:
- .setup_minion

# Salt master setup
setup_master reactor conf:
  file.managed:
  - name: /etc/salt/master.d/reactor.conf
  - contents:
    - "reactor:"
    - "- 'salt/auth':"
    - "  - /srv/salt/reactor/accept_minion.sls"

add log_level to master:
  file.managed:
  - name: /etc/salt/master.d/log_level.conf
  - contents: 'log_level: info'

setup_master restart saltmaster:
  service.running:
  - name: salt-master
  - enable: true
  - watch:
    - file: setup_master reactor conf

