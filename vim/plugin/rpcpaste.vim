" Vim Pastebin XML-RPC 
"  (c) 2008 Olivier Lê Thanh Duong <olethanh@gmail.com>
" Vim script for pastebin using a XML-RPC interface compatible with
"  http://paste.debian.net/rpc-interface.html

" Based on the VimPastebin script from djcraven
"  http://djcraven5.blogspot.com/2006/10/vimpastebin-post-to-pastebin-from.html


" Make sure the Vim was compiled with +python before loading the script...
if !has("python")
        finish
endif

" Map a keystroke for Visual Mode only (default:F2)
:vmap <f2> :PasteCode<cr>

" Define two commands.. One for just pastebinning alone, and another for
" Gajiming the results
:command -range             PasteCode :py PasteMe(<line1>,<line2>)
:command -range -nargs=*    PasteGajim :py PasteMe(<line1>,<line2>,<args>)
:command                    PasteFile :py PasteMe()

python << EOF
import vim
import xmlrpclib

def PasteMe(start=-1, end=-1, jid="None"):
    url = PBSend(start, end)
    if not jid == "None":
        gajim_send_url(jid, url)

def PBSend(start=-1, end=-1):
################### BEGIN USER CONFIG ###################
    # Set this to your preferred pastebin
    pastebin = 'http://paste.debian.net/'
    # XML-RPC path on the server
    rpcpath = '/server.pl'
    # Set this to your preferred username
    user = 'mc'
#################### END USER CONFIG ####################

    if not (pastebin[:7] == 'http://'):
        pastebin = 'http://' + pastebin

    server = xmlrpclib.Server(pastebin + rpcpath)

    if start != -1 and end !=-1:
        code = '\n'.join(vim.current.buffer[int(start)-1:int(end)])
    else:
        code = '\n'.join(vim.current.buffer[:])

    # Detect file type
    format = vim.eval('&ft')

    supported_formats = server.paste.getLanguages()['langs']

    if format not in supported_formats:
        format = ''

    rep = server.paste.addPaste(code, user, '', format)

    if rep['rc'] != 0 :
        print 'An error occured : %s ' % (rep['statusmessage'])
    else:
        print rep['statusmessage']
        print 'Code pasted at %s%i' % (pastebin, rep['id'])
        return '%s%i' % (pastebin, rep['id'])

def gajim_send_url(jid, url):
    try:
        import dbus
        sbus = dbus.SessionBus()
        obj = sbus.get_object('org.gajim.dbus', '/org/gajim/dbus/RemoteObject')
        interface = dbus.Interface(obj, 'org.gajim.dbus.RemoteInterface')

        # Try to get the actual JID from your contact list
        list = interface.__getattr__('list_contacts')
        roster = list()
        for contact in roster:
            if jid.lower() == contact['name'].lower():
                jid = contact['jid']

        send = interface.__getattr__('send_message')
        if not send(jid, url):
            print "%s not found in Gajim roster." % jid
    except:
        print "Error sending message to %s." % jid

EOF
