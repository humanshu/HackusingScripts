echo "start"
searchText='ABCDEF';
# filename as the first argument
INPUT_FILE="$1"

# check if argument is > or < 1(fileName) exit
if (( $# != 1 )); then
    echo "Illegal number of parameters, script exiting...."
    echo "usage: <scriptname> <inputFilename>"
    exit;
    fi

# list of recipients for the mail
REPORT_RECIPIENTS="xxx@abc.com"

# Output file parameters
OUTPUT_FILE=outputFile.csv
TIMESTAMP_PREFIX=`date +%Y-%m-%d_%H%M%S`

function extractLines {
    # read each line and extract columns {Column1,Column2,Column3,Column4(ddMMMYYYY)} from INPUT_FILE
    while read -r line
        do
            case $line in
            *${searchText}*)
            echo $line | cut -d ',' -f2,1,2,3,4 >> ./tmp.log
            ;;
        *)
        esac
        done < "$INPUT_FILE"

	# add columns names in first row of the file
    echo "Column1,Column1,Column3,Column4,Column5" > ./$OUTPUT_FILE
    # sort file based on Column4(ddMMMYYYY) date in descending order (latest first)
    sort  -t ',' -k 4.6,4.9nr  -k 4.3,4.5Mr -k 4.1,4.2nr ./tmp.log > ./$OUTPUT_FILE   
    rm tmp.log
}

function sendReportMail {
    # rename INPUT_FILE add timestamp prefix
    mv ./$OUTPUT_FILE ./${TIMESTAMP_PREFIX}_${OUTPUT_FILE}
    # encrypt file before sending mail
    #encrpytion supported by 7za: ZipCrypto, AES128, AES192, AES256
    7za a -tzip -p$PASSWORD -mem=AES192 ./${TIMESTAMP_PREFIX}_${OUTPUT_FILE}.zip ./${TIMESTAMP_PREFIX}_${OUTPUT_FILE} > /dev/null
    # send mail along with biopsy test csv file attached
    cat ./${TIMESTAMP_PREFIX}_${OUTPUT_FILE}  | sendEmail -q -u "Subject Text" -t $REPORT_RECIPIENTS -f admin@XXX.com -m "" -a ${TIMESTAMP_PREFIX}_${OUTPUT_FILE}.zip
    rm ./${TIMESTAMP_PREFIX}_${OUTPUT_FILE}
}

extractLines
sendReportMail

echo "finish"