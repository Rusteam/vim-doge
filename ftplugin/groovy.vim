" ==============================================================================
" The Groovy documentation should follow the 'JavaDoc' conventions.
" see https://www.oracle.com/technetwork/articles/javase/index-137868.html
"
" This ftplugin should always reflect the logic of the ftplugin/java.vim.
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m\(\/\*.\{-}\*\/\|\/\/.\{-}$\)'
let b:doge_pattern_multi_line_comment = '\m\/\*.\{-}\*\/'

let b:doge_supported_doc_standards = ['javadoc']
let b:doge_doc_standard = get(g:, 'doge_doc_standard_groovy', b:doge_supported_doc_standards[0])
if index(b:doge_supported_doc_standards, b:doge_doc_standard) < 0
  echoerr printf(
  \ '[DoGe] %s is not a valid Groovy doc standard, available doc standard are: %s',
  \ b:doge_doc_standard,
  \ join(b:doge_supported_doc_standards, ', ')
  \ )
endif

let b:doge_patterns = {}

" ==============================================================================
" Define our base for every pattern.
" ==============================================================================
let s:pattern_base = {
\  'parameters': {
\    'format': '@param {name} !description',
\  },
\  'insert': 'above',
\}

" ==============================================================================
" Define the pattern types.
" ==============================================================================
let s:class_method_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(\%(public\|private\|protected\|static\|final\)\s*\)*\%(\%(\([[:alnum:]_]\+\)\?\s*\%(<[[:alnum:][:space:]_,]*>\)\?\)\?\s\+\)\?\%([[:alnum:]_]\+\)(\(.\{-}\))\s*[;{]',
\  'match_group_names': ['returnType', 'parameters'],
\  'parameters': {
\    'match': '\m\%(\([[:alnum:]_]\+\)\%(<[[:alnum:][:space:]_,]\+>\)\?\)\%(\s\+[.]\{3}\s\+\|\s\+[.]\{3}\|[.]\{3}\s\+\|\s\+\)\([[:alnum:]_]\+\)',
\    'match_group_names': ['type', 'name'],
\  },
\})

" ==============================================================================
" Define the doc standards.
" ==============================================================================
let b:doge_patterns.javadoc = [
\  doge#helpers#deepextend(s:class_method_pattern, {
\    'template': [
\      '/**',
\      ' * !description',
\      '%(parameters| *)%',
\      '%(parameters| * {parameters})%',
\      '%(returnType| * @return !description)%',
\      ' */',
\    ],
\  }),
\]

let &cpoptions = s:save_cpo
unlet s:save_cpo
