" baidu_trans.vim: 用baidu翻译接口在vim中翻译
" Author:       river
" Date:         2014-12-23
" Version:      0.1
" Ref:          http://code.google.com/p/jiazhoulvke/downloads/detail?name=googletranslate.vim
"-------------------------------------------------

function! Baidu_Translate(lan1,lan2,word)
python << EOM
#coding=utf-8
import vim,urllib,urllib2,json,time,hashlib
word = vim.eval("a:word")
word=word.replace('\n','')
rword = urllib.urlencode({'q':word})
lan1 = vim.eval("a:lan1")
lan2 = vim.eval("a:lan2")
headers = {
    'User-Agent':'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'
}
tm = str(int(time.time()))
url = 'http://api.fanyi.baidu.com/api/trans/vip/translate?appid=20160226000013643&salt=' + tm + '&q=' + rword + '&from=' + lan1 + '&to=' + lan2 + '&sign=' + hashlib.md5('20160226000013643' + rword + tm + 'Ih8adJtQ0gylKxu0QkAC').hexdigest()

req = urllib2.Request(
    url = url,
    headers = headers
)
resultstr=''
gtresult = urllib2.urlopen(req)
if gtresult.getcode()==200:
    gtresultstr=gtresult.read()
    rst=json.loads(gtresultstr)
    resultstr='[F:%s T:%s]' % (rst['from'], rst['to'])
    for r in rst['trans_result']:
        resultstr+=r['dst']
vim.command('let resultstr = "%s"' % resultstr)
EOM
return resultstr
endfunction
function! Baidu_Translate_Selected_String(lan1,lan2)
    normal `<
    normal v
    normal `>
    silent normal "ty
    return Baidu_Translate(a:lan1,a:lan2,@t)
endfunction
if !hasmapto('<leader>e2c','n')
    nmap <silent> <leader>e2c :echo Baidu_Translate('en','zh',expand('<cword>'))<CR>
endif
if !hasmapto('<leader>c2e','n')
    nmap <silent> <leader>c2e :echo Baidu_Translate('zh','en',expand('<cword>'))<CR>
endif
if !hasmapto('<leader>b2c','n')
    nmap <silent> <leader>b2c :echo Baidu_Translate('auto','zh',expand('<cword>'))<CR>
endif
if !hasmapto('<leader>b2e','n')
    nmap <silent> <leader>b2e :echo Baidu_Translate('auto','en',expand('<cword>'))<CR>
endif
if !hasmapto('<leader>e2c','v')
    vmap <silent> <leader>e2c <ESC>:echo Baidu_Translate_Selected_String('en','zh')<CR>
endif
if !hasmapto('<leader>c2e','v')
    vmap <silent> <leader>c2e <ESC>:echo Baidu_Translate_Selected_String('zh','en')<CR>
endif
if !hasmapto('<leader>b2c','v')
    vmap <silent> <leader>b2c <ESC>:echo Baidu_Translate_Selected_String('auto','zh')<CR>
endif
if !hasmapto('<leader>b2e','v')
    vmap <silent> <leader>b2e <ESC>:echo Baidu_Translate_Selected_String('auto','en')<CR>
endif
if !exists(":E2C")
    command! -nargs=+ E2C :echo Baidu_Translate("en","zh",<q-args>)
endif
if !exists(":C2E")
    command! -nargs=+ C2E :echo Baidu_Translate("zh","en",<q-args>)
endif
if !exists(":A2C")
    command! -nargs=+ A2C :echo Baidu_Translate("auto","zh",<q-args>)
endif
if !exists(":A2E")
    command! -nargs=+ A2E :echo Baidu_Translate("auto","en",<q-args>)
endif
