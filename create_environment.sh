#!/bin/bash

# Ask user to entre their name 
read -p "ENter your name: " user_name

# Making a variable assigne it to main directory
MAIN_DIR="submission_reminder_${user_name}"

# Create the main directory
mkdir -p $MAIN_DIR
cd $MAIN_DIR || exit

# Create subdirectories 
mkdir -p app modules assets config 

# Create and populate the reminder.sh file in the directory app
cat <<_EOF_ > app/reminder.sh
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
_EOF_
chmod +x app/reminder.sh

# Create and populate functions.sh file in the moduless directory
cat <<_EOF_ > modules/functions.sh
#!/bin/bash
# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
_EOF_
chmod +x modules/functions.sh

# Create and populate the submission.txt file in the assets directory
cat <<_EOF_ > assets/submission.txt
Student, Assignment, Submission Status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Enoke, Shell Basics, submitted
Alice, Shell Basics, submitted
Robert, Git, submitted 
Raissa, Git, submitted
Erick, Shell Basics, submitted
Nadine, Git, submitted
_EOF_

# Create and populate the config.env file in the config directory 
cat <<_EOF_ > config/config.env
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
_EOF_


# Create the startup.sh file 
cat <<_EOF_ > $MAIN_DIR/startup.sh
#!/bin/bash

# Make run the reminder application
./app/reminder.sh
_EOF_
chmod +x starup.sh

# Successful 
echo "The set up of ENvironment is complete! Run the startup.sh script to start the reminder app."
