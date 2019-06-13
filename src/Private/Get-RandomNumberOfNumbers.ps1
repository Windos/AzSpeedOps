function Get-RandomNumberOfNumbers {
    $AmmountOfRandomNumbers = Get-Random -Minimum 1 -Maximum 10

    1..$AmmountOfRandomNumbers | ForEach-Object {
        Get-Random -Minimum 1 -Maximum 1000
    }
}
