" ==============================================================================
" The CoffeeScript documentation should follow the 'jsdoc' conventions, since
" there is no official CoffeeScript documentation.
" see https://jsdoc.app
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m#\@<!##\@!.\+$'
let b:doge_pattern_multi_line_comment = '\m###.\{-}###'

let b:doge_supported_doc_standards = ['jsdoc']
let b:doge_doc_standard = get(g:, 'doge_doc_standard_coffee', b:doge_supported_doc_standards[0])
if index(b:doge_supported_doc_standards, b:doge_doc_standard) < 0
  echoerr printf(
  \ '[DoGe] %s is not a valid CoffeeScript doc standard, available doc standard are: %s',
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
\    'format': '@param {!type} {name} !description',
\  },
\  'insert': 'above',
\}

" ==============================================================================
" Define the pattern types.
" ==============================================================================
let s:prototype_function_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\([[:alnum:]_$]\+\)::\([[:alnum:]_$]\+\)\s*=\s*[-=]>',
\  'match_group_names': ['className', 'funcName'],
\})

let s:function_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\([[:alnum:]_$]\+\)\s*=\s*(\(.\{-}\))\s*[-=]>',
\  'match_group_names': ['funcName', 'parameters'],
\  'parameters': {
\    'match': '\m\([^,]\+\)',
\    'match_group_names': ['name'],
\  },
\})

" ==============================================================================
" Define the doc standards.
" ==============================================================================
let b:doge_patterns.jsdoc = [
\  doge#helpers#deepextend(s:prototype_function_pattern, {
\    'template': [
\      '###',
\      '!description',
\      '',
\      '@function {className}#{funcName}',
\      '###',
\    ],
\  }),
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '###',
\      '!description',
\      '',
\      '@function {funcName|}',
\      '%(parameters|{parameters})%',
\      '###',
\    ],
\  }),
\]

let &cpoptions = s:save_cpo
unlet s:save_cpo
