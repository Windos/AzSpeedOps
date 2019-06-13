function Measure-RandomNumbers {
    [CmdletBinding(DefaultParameterSetName = 'Sum')]
    param (
        [Parameter(ParameterSetName = 'Sum')]
        [Switch] $Sum,

        [Parameter(ParameterSetName = 'Avg')]
        [Switch] $Average
    )

    switch ($PSCmdlet.ParameterSetName) {
        Sum { (Get-RandomNumberOfNumbers | Measure-Object -Sum).Sum }
        Avg { [math]::Round((Get-RandomNumberOfNumbers | Measure-Object -Average).Average,2) }
    }
}