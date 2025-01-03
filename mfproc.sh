
#===========================FUNCS=====================================

function usecase(){
    echo "mfproc [-u username] [-s S|R|Z]]"
}
function getDet(){
    loc=$(ls /proc| nl | awk -v var="$var" '$1 == var' | awk '{print $2}') 
    if test -e /proc/$loc/status;then 
        PD=$(cat /proc/$loc/status -ns | awk 'NR == 6  {print $3}') 
        PPD=$(cat /proc/$loc/status -ns | awk 'NR == 7  {print $3}')
        UD=$(cat /proc/$loc/status -ns | awk 'NR == 9 {print $3 " " $4 " " $5 " " $6}')
        GD=$(cat /proc/$loc/status -ns | awk 'NR == 10  {print $3 " " $4 " " $5 " " $6}')
        STT=$(cat /proc/$loc/status -ns | awk 'NR == 3  {print $3}')
        NAME=$(cat /proc/$loc/status -ns | awk 'NR == 1  {print $3}')
        var=$(($var+1)) 
    else 
     var=$(($var+1))
    fi
}

#=======================================MAIN==========================================================
echo -e "NAME\t PID\t PPID\t UID\t GID\t STATE"
num=$(ls /proc | grep -c '[0..9]') 
declare -i var=1 
parnum=$#
if [ $parnum -lt 5 ] && [ $parnum -gt 0 ];then 

   
    declare -i cnt=0 

    if [ $1 == "-u" ];then 
       if !(echo $2 | grep [0..9]);then 
            usecase 
            exit
        fi 
    
        if [ "$3" == "-s" ];then 
            if !(echo "$4" | egrep -q '[RSZ]' ); then 
               usecase
                exit
            fi

    
           while [ $var -lt $num ]
           do    
                getDet
                checkUD=$(echo "$UD"|awk '{print $1}') 
                checkSTT=$(echo "$STT") 
                
                if [ "$checkUD" -eq "$2" ] && [ "$checkSTT" = "$4" ];then 
                   echo -e "$NAME\t $PD\t $PPD\t $UD\t $GD\t $STT"
                    cnt=$cnt+1 
                fi
                
            done
            
            if [ $cnt -eq 0 ];then 
                echo $cnt
                exit 1 
            fi
            exit 0

        elif [ $3 != "-s" ];then 
            usecase 
            exit
        else 
            while [ $var -lt $num ] 
           do    
                getDet
                checkUD=$(echo "$UD"|awk '{print $1}')       
                if [ "$checkUD" -eq "$2" ] ;then 
                    echo -e "$NAME\t $PD\t $PPD\t $UD\t $GD\t $STT"
                  cnt=$cnt+1
               
                 fi
                

            done
            if [ $cnt -eq 0 ];then
                 echo $cnt
                exit 1
            fi
            exit 0
        fi
    elif [ $1 == '-s' ];then 

        if !(echo "$2" | egrep -q '[SRZ]' ); then 
               usecase
                exit
        fi

        while [ $var -lt $num ]
        do    
            getDet
            checkUD=$(echo "$UD"|awk '{print $1}')
            checkSTT=$(echo "$STT")
                
            if [ "$checkSTT" = "$2" ];then
               echo -e "$NAME\t $PD\t $PPD\t $UD\t $GD\t $STT"
                cnt=$cnt+1
            fi
            

        done
        if [ $cnt -eq 0 ];then
            echo $cnt
            exit 2
        fi       
        exit 0
    else 
        usecase
    fi

elif [ $parnum -eq 0 ];then 
    while [ $var -lt $num ]
    do 
        getDet
                echo -e "$NAME\t $PD\t $PPD\t $UD\t $GD\t $STT"

        
    done

else 
    echo Too many parametres!
    usecase

fi

