if ! command -v expect &> /dev/null
then
    echo "Expect не установлен. Установим его..."
    sudo apt-get update && sudo apt-get install -y expect
fi

output=$(expect -c "
spawn make do
expect {
    \"Password for root@*:\" {
        send \"PASSWORD HERE\r\"
        exp_continue
    }
}
")


filtered_output=$(echo "$output" | grep -v "fcntl(): Operation not supported" | grep -v "ld: warning:" | grep -v "Password" | grep -v "dm.pl: building package" | grep -v "\*\*\*")


if echo "$filtered_output" | grep -q "Processing triggers for"; then
    echo "$filtered_output"
    echo ""
    echo -e "\033[32mСкомпилирован и установлен на устройство.\033[0m"
else
    echo "$filtered_output"
    echo ""
    echo -e "\033[31mОшибка при компиляции твика.\033[0m"
    exit 1
fi
echo ""
