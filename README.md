# debug_omd_tt
Debug Template Toolkit files on OMD (Open Monitoring Distribution, https://labs.consol.de/omd/index.html)

## Purpose 
This script was written to simplify the debugging of Template Toolkit files used in OMD for notifications (`notify-by-email.pl`). 

The script makes it easy to test TT templates with an number of variables. They only have to be set in the `debug_tt.rc` file. Each variable in this file will be passed to the `tpage` command (in mode "t") or to the notification script (mode "m"). )

## Usage 

### Print processed template to STDOUT

```
./debug_tt.sh  -f $OMD_ROOT/etc/mail-templates/notify-by-email.host.NEW.tpl -t
```

### Send processed template as notification

```
./debug_tt.sh  -f $OMD_ROOT/etc/mail-templates/notify-by-email.host.NEW.tpl -m
```

Use a custom notification script: 

```
./debug_tt.sh  -f $OMD_ROOT/etc/mail-templates/notify-by-email.host.NEW.tpl -s $OMD_ROOT/local/lib/nagios/plugins/notify-by-email-CUSTOM.pl
```

Start the notification script with with the Perl debugger (`perl -d`): 

```
./debug_tt.sh  -f $OMD_ROOT/etc/mail-templates/notify-by-email.host.NEW.tpl -d
```
