function! s:UsingPython3()
  if has('python3')
    return 1
  endif
  return 0
endfunction


let s:using_python3 = s:UsingPython3()
let s:python_until_eof = s:using_python3 ? 'python3 << EOF' : 'python << EOF'

function! YAMLFormat()
    if (!has('python3') && !has('python'))
        echo 'Either +python or python3 as vim option is needed'
        finish
    endif

    exec s:python_until_eof
from __future__ import print_function
import re
try:
    import vim
    import yaml
    from collections import OrderedDict
except ImportError:
    print('Please ensure that pyyaml for your vim-python version is ' +\
          'installed: pip install pyyaml or pip3 install pyyaml')
else:
    # using ordered dict and pyyaml: https://stackoverflow.com/a/21912744
    def ordered_load(stream, Loader=yaml.Loader,
                     object_pairs_hook=OrderedDict):
        class OrderedLoader(Loader):
            pass

        def construct_mapping(loader, node):
            loader.flatten_mapping(node)
            return object_pairs_hook(loader.construct_pairs(node))

        OrderedLoader.add_constructor(
            yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, construct_mapping)
        return yaml.load(stream, OrderedLoader)

    def ordered_dump(data, stream=None, Dumper=yaml.Dumper, **kwds):
        class OrderedDumper(Dumper):
            pass

        def _dict_representer(dumper, data):
            return dumper.represent_mapping(
                yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, data.items())

        OrderedDumper.add_representer(OrderedDict, _dict_representer)
        return yaml.dump(data, stream, OrderedDumper, **kwds)

    def fix_indent(yaml, indent=4):
        # TODO: multiline strings that start '-' are changed, too
        def replacer(match):
            return match.group(1) + indent * ' ' + '-'

        return re.sub(r'^( *)-', replacer, yaml, flags=re.MULTILINE)

    def get_variable(name, default):
        return vim.eval("get(g:, '%s', '%s')" % (name, default))

    indent = int(vim.eval('&ts'))
    fix_list_indent = int(get_variable('yaml_formatter_indent_collection', 0))

    current_buffer = '\n'.join(vim.current.buffer)
    data = ordered_load(current_buffer)
    yaml_formatted = ordered_dump(
        data, default_flow_style=False, indent=indent)

    if fix_list_indent:
        yaml_formatted = fix_indent(yaml_formatted, indent=indent)

    vim.current.buffer[:] = yaml_formatted.split('\n')
EOF
endfunc

command! YAMLFormat call YAMLFormat()
