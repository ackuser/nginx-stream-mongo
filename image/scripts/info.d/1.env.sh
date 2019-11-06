#!/bin/bash

env | grep "^com.produban*" | sort

echo "----------------- NGINX version and modules ----------------------------------"

nginx -V

