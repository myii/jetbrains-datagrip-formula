# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import datagrip with context %}

   {%- if datagrip.pkg.use_upstream_macapp %}
       {%- set sls_package_clean = tplroot ~ '.macapp.clean' %}
   {%- else %}
       {%- set sls_package_clean = tplroot ~ '.archive.clean' %}
   {%- endif %}

include:
  - {{ sls_package_clean }}

datagrip-config-clean-file-absent:
  file.absent:
    - names:
      - /tmp/dummy_list_item
               {%- if datagrip.config_file and datagrip.config %}
      - {{ datagrip.config_file }}
               {%- endif %}
               {%- if datagrip.environ_file %}
      - {{ datagrip.environ_file }}
               {%- endif %}
               {%- if grains.kernel|lower == 'linux' %}
      - {{ datagrip.linux.desktop_file }}
               {%- elif grains.os == 'MacOS' %}
      - {{ datagrip.dir.homes }}/{{ datagrip.identity.user }}/Desktop/{{ datagrip.pkg.name }}{{ '' if 'edition' not in datagrip else '\ %sE'|format(datagrip.edition) }}*  # noqa 204
               {%- endif %}
    - require:
      - sls: {{ sls_package_clean }}
