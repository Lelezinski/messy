if [ -n "${ZSH_VERSION:-}" ]
then
    DIR="$(readlink -f -- "${(%):-%N}")"
    DIRNAME="$(dirname $DIR)"
    GAP_SDK_HOME=$(echo $DIRNAME)
    export GAP_SDK_HOME
    setopt shwordsplit
else
    export GAP_SDK_HOME="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
fi

EXCLUDE="clean.sh common.sh jlink.sh openocd.sh gap9_v2.sh"
EXCLUDE_FILES=
for i in $EXCLUDE
do
    EXCLUDE_FILES="$EXCLUDE_FILES -not -iname *$i"
done

BOARDS=$(find $GAP_SDK_HOME/configs -maxdepth 1 -type f -iname "*.sh" $EXCLUDE_FILES | sort)

n=0
board=
echo "Select the target : "
for i in $BOARDS
do
    n=$(($n+1))
    board=$(basename $(echo $BOARDS | tr '[:lower:]' '[:upper:]' | cut -d ' ' -f $n) .SH)
    echo -e "\t$n - $board"
done

if [ "$#" -eq 1 ]
then
    board=$1
else
    read board
fi

if [ -z "$board" ] || [ "$board" -gt "$n" ] || [ "$board" -le 0 ]
then
    source $GAP_SDK_HOME/configs/gap9_evk_audio.sh
else
    board=$(echo $BOARDS | cut -d ' ' -f $board)
    source $board
fi

if [ -e $GAP_SDK_HOME/internal/scripts/environment/install_hooks.sh ]; then
    $GAP_SDK_HOME/internal/scripts/environment/install_hooks.sh
fi

echo The target board you have chosen is : $BOARD_NAME, $TARGET_CHIP.

unset EXCLUDE EXCLUDE_FILES BOARDS board n
