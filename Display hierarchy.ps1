$services = Get-Service
foreach ($main_service in $services) {
    Write "  $($main_service.name) depends on:"
    foreach ($sub_service in $main_service.requiredservices) {
       
        Write "`t $($sub_service.name)"
    }
}