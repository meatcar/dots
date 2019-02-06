if [ `ps aux | grep ' X ' | wc -l` -eq 1 ]; then 
    xinit &
fi
