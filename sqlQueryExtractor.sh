  #script is use to execute sql command and stores its output into the file
    #output file is encrypted using any algorithm which is supported by 7za as mentioned below and is mailed to list of recipients as an attachment
    #both output file and its encrypted version is removed after sending mail

    # set password for encryption of output file
    PASSWORD="password"
    timestamp=$(date +%Y-%m-%d)

    # Live recipients
    TO_RECIPIENTS="abc@xyz.com"
    CC_RECIPIENTS="def@xyz.com"

    # directory where output file is created
    OUTPUT_DIRECTORY=.
    cd $OUTPUT_DIRECTORY

    # output file name
    OUTPUT_FILENAME=outputFile_$timestamp.csv
    OUTPUT_FILE=$OUTPUT_DIRECTORY/$OUTPUT_FILENAME

    # input SQL query to be executed
    QUERY="select column1, column2 from table_name;"

    # execute input query
    echo "Process SQL query ..."
    psql -h hostname -U user_name -c "$QUERY" > $OUTPUT_FILE

    # archiving and encrypting file with AES256 algorithm
	# 7za supports: ZipCrypto, AES128, AES192, AES256 algorithms
    echo "Archiving and encrypting output file \"$OUTPUT_FILENAME\" with AES192 to \"$OUTPUT_FILENAME.zip\""
    7za a -tzip -p$PASSWORD -mem=AES192 $OUTPUT_FILE.zip $OUTPUT_FILE > /dev/null

    # send content of output file and also encrypted output file as attachment in the mail to above mention recipients
    cat $OUTPUT_FILE | sendEmail -q -u "Subject Text (TransferFilename: $OUTPUT_FILENAME)" -t $TO_RECIPIENTS -cc $CC_RECIPIENTS -f admin@xyz.com -m "" -a $OUTPUT_FILE.zip

    # removing both unzip and zipped output file
    rm $OUTPUT_FILE $OUTPUT_FILE.zip
    echo "Task completed!"