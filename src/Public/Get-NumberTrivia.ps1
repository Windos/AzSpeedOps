function Get-NumberTrivia {
    Invoke-RestMethod -Method Get -Uri 'http://numbersapi.com/random/trivia'
}
