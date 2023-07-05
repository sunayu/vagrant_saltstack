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
  - watch_in:
    - service: setup_master restart saltmaster

add log_level to master:
  file.managed:
  - name: /etc/salt/master.d/log_level.conf
  - contents: 'log_level: info'
  - watch_in:
    - service: setup_master restart saltmaster

add pillarstack to master:
  file.serialize:
  - name: /etc/salt/master.d/pillarstack.conf
  - serializer: yaml
  - dataset:
      ext_pillar:
      - stack: /srv/pillar/stack/stack_assign.cfg
      - stack: /srv/pillar/stack/stack.cfg
  - watch_in:
    - service: setup_master restart saltmaster

setup_master restart saltmaster:
  service.running:
  - name: salt-master
  - enable: true

