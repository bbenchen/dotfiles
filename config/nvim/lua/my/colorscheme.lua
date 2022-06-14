vim.cmd [[
try
  let g:nord_disable_background = v:true
  colorscheme nord
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]
