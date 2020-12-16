add log level:
  file.managed:
  - name: /etc/salt/minion.d/log_level.conf
  - contents: 'log_level: info'

add default grain:
  file.managed:
  - name: /etc/salt/grains
  - contents:
    - 'initialized: False'

salt minion service:
  service.running:
  - name: salt-minion
  - enable: true
  - watch:
    - file: add log level
    - file: add default grain

