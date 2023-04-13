#!/bin/bash

#db credentials
DB_NAME=salon
DB_USER=freecodecamp

#create db
psql --username=$DB_USER --dbname=postgres -c "CREATE DATABASE salon;"

PSQL="psql --username=$DB_USER --dbname=$DB_NAME -t --no-align -c"

# connect to database and create tables

$($PSQL "CREATE TABLE IF NOT EXISTS customers (
  customer_id SERIAL PRIMARY KEY,
  name VARCHAR(50),
  phone VARCHAR(20) UNIQUE
);")

$($PSQL "CREATE TABLE IF NOT EXISTS services (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE
);")

$($PSQL "INSERT INTO services (name) VALUES
  ('cut'),
  ('color'),
  ('perm'),
  ('style'),
  ('trim');")

$($PSQL "CREATE TABLE IF NOT EXISTS appointments (
  appointment_id SERIAL PRIMARY KEY,
  customer_id INTEGER REFERENCES customers(customer_id),
  service_id INTEGER REFERENCES services(service_id),
  time VARCHAR(10)
);")

# Display salon services and prompt user for input
echo "~~~~~ MY SALON ~~~~~"
echo "Welcome to My Salon, how can I help you?"
# Get a list of services from the database
services=$($PSQL "SELECT service_id, name FROM services")

# Parse the services into an array
readarray -t services_array <<< "$services"


# Loop until a valid service ID is selected
while true; do
    # Display a numbered list of services
    echo "Services offered:"
    for i in "${!services_array[@]}"; do
        IFS='|' read -r SERVICE_ID SERVICE_NAME <<< $(echo "${services_array[$i]}")
        
        # Display the service as a numbered option
        echo "$SERVICE_ID) $SERVICE_NAME"
    done
    # Get user input for the selected service
    read -p "Please enter the service ID you want: " SERVICE_ID_SELECTED
    # Validate the selected service
    if (( SERVICE_ID_SELECTED < 1 || SERVICE_ID_SELECTED > ${#services_array[@]} )); then
        echo "Invalid service ID. Please enter a valid service ID."
    else
        # Extract the service name from the selected array element
        #echo "You selected service #$service_id_selected: $service_name_selected"
        break
    fi
done


# Prompt user for phone number and name if phone number doesn't exist
while true; do
  read -p "What's your phone number? " CUSTOMER_PHONE
  if [[ -z "$CUSTOMER_NAME" ]]; then
    read -p "I don't have a record for that phone number, what's your name? " CUSTOMER_NAME
    $PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');"
    if [ $? -ne 0 ]; then
      echo "Error executing SQL statement"
    else
      break
    fi
  else
    break
  fi
done

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")

# Prompt user for appointment time and insert appointment into database
read -p "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME? " SERVICE_TIME
$PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');"
$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
# Output confirmation message
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME"
exit 1
