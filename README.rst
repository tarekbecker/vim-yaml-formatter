==================
VIM YAML Formatter
==================

Prerequisite
============
Python package ``pyyaml`` need to be installed.

.. code-block:: bash

     pip install pyyaml


Installation
============

Using `Vundle <https://github.com/VundleVim/Vundle.vim#about>`_:

.. code-block:: vim

     Plugin 'tarekbecker/vim-yaml-formatter'

Usage
=====
Execute ``YAMLFormat`` to format the current buffer

.. code-block:: vim

     :YAMLFormat

A range formatting is not supported.

Configuration
=============

VIM's configuration ``tabstop`` determines the number of spaces used for
indention.

Per default collection items have the same indention level as their parent:

.. code-block:: yaml

     name:
     - item
     - item

``yaml_formatter_indent_collection=1`` can be used to indent the items:

.. code-block:: yaml

     name:
          - item
          - item

.. code-block:: vim

     let g:yaml_formatter_indent_collection=1

