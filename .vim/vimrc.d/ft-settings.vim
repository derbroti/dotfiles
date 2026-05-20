" make uses real tabs
au FileType make set noexpandtab
" Go uses tabs
au FileType go set noexpandtab tabstop=4 shiftwidth=4
" make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79
au FIleType python let g:airline#extensions#coli#columns = 80
au FileType ruby   set softtabstop=2 tabstop=2 shiftwidth=2

au FileType mkern set listchars=tab:◦\ ,trail:•
